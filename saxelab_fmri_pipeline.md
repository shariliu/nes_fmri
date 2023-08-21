# Saxe lab standard fMRI pipeline: 

# Packages and software

We use singularity containers for all processes in the lab pipeline. We are currently working on making our containers accessible publicly, but for now here is a list of software versions we use:   

* Singularity: 3.4.1 
  * Docker image version of singularity available [here](https://quay.io/repository/singularity/singularity)

We also use FSL for group level analyses: 
* FSL (for randomise, cluster): 5.0.9
  * Docker image available [here](https://hub.docker.com/layers/brainlife/fsl/5.0.9/images/sha256-fbd262c385e9de22aa58bf7b6311cbd5cd96c7b4eaff151f879191e869bf224e?context=explore)

software below used within Singularity containers:
* heudiconv: 0.9.0 (data analyzed before summer 2022: 0.5.4.dev1)
  * singularity image from Docker [here](https://hub.docker.com/layers/nipy/heudiconv/0.9.0/images/sha256-42a4ab94a4af122e1031648f28dbc40a05b8b6cd6e720c7e94e539e93a519636?context=explore)
* fmriprep: 22.0.2 (data analyzed before summer 2022: v1.2.6)
  * singularity image from Docker [here](https://hub.docker.com/layers/nipreps/fmriprep/22.0.2/images/sha256-0fc089c95ff044640cb7e818b73620ecd33762f402f304433eddb632ff951d92?context=explore)
* nipy/nipype: 1.5.1
  * singularity image from Docker (closest match) [here](https://hub.docker.com/layers/nipype/nipype/py36/images/sha256-1216c6324e6dafdec79d118009af3a6d2d18bb5fb0dc48f439fdb3ff80d828b2?context=explore)

* conda:
  * 4.5.12 (heudiconv; fmriprep)
  * 4.8.4 (nipype; univariate/multivariate ROI analyses)
* python:
  * 3.6.7 (used in heudiconv container)
  * 3.7.1 (fmriprep container)
  * 3.6.5 (nipype container)
  * 3.8.3 (univariate/multivariate ROI analyses container)

# Processes 

## Convert DICOMs to BIDS 

We use [heudiconv](https://github.com/nipy/heudiconv) in a singularity container to convert fMRI data to BIDS format based on the experimental design. 

## Preprocess data  

We preprocess data using fMRI data using the [fMRIprep](https://fmriprep.org/en/stable/) toolbox within a singularity container. Here is an example of how we call fMRIprep using the standard flags for our pipeline: 

`fmriprep $data_directory/BIDS $data_directory/BIDS/derivatives participant --participant_label $subject_id --mem_mb 15000 --ignore slicetiming --use-aroma -w $scratch --fs-license-file $FSL_license_path --output-spaces MNI152NLin6Asym:res-2`


Note, fMRIprep is technically nondeterministic; there is slight computational variability that results in slightly different reconstructions each time fMRIprep is run. For this reason, we try to maintain a standard of sharing subject-level preprocessed data as well as raw BIDS data when possible (i.e., when we have consent to share). 

fMRIprep includes standard fMRI preprocessing, and with the `--use-aroma` flag, it also runs "soft" artifact correction and generates the confounds used as nuisance regressors in first-level modeling. See fMRIprep pages (linked above) for details.


## Motion exclusions 

After preprocessing, we use [fMRIprep](https://fmriprep.org/en/stable/)'s Frame Displacement (FD) estimate per run to flag volumes within each run that have greater than X units of change (typically: 0.4 units) in FD from the start of the run. These volumes are excluded from first-level analyses. If greater than Y% (typically: 25%) of any run is flagged as motion, the whole run is excluded. 


## First level analyses 

We use [Nipype](https://nipype.readthedocs.io/en/latest/) to combine tools from different software packages, mainly relying on Nipype's FSL interface to fit the run-level (first-level) GLM. The model is fit using FSL's [FEAT tool](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FEAT/UserGuide). 

There are event regressors per each contrast specified in the study-specific contrast file, as well as confounds imported from fMRIprep preprocessing. Specifically, this step relies on the confounds text file that fmriprep outputs and the realigned and normalized bold and anatomical images, as well as the events.tsv files located inside the BIDS directory specifying the onset and duration for every condition in the experiment (instructions to create the events.tsv file below).

The design for the experiment is calculated from those event files, along with nuisance regressors specified below. Each event regressor is convolved with a double-gamma HRF, and a high-pass filter is applied to both the data and the model. 

Artifact detection is performed using nipype’s RapidART toolbox, which is itself an implementation of SPM’s ART toolbox. Individual TRs are identified as outliers if they exceed a motion threshold of more than .4 units of frame displacement, or if the average signal intensity of that volume is more than three standard deviations away from the mean average signal intensity.

In addition to the ART outliers (one regressor per outlier volume), the current Saxelab script includes a summary movement regressor (framewise displacement, or FD), and 6 anatomical CompCor regressors that are intended to control for the average signal in white matter and CSF.

A smoothing kernel of 6mm is applied to the preprocessed bold images, and finally, FSL’s GLM runs the first-level model. The current default is to run the model in MNI space, though this can be changed in your fmriprep command.

Contrasts are estimated based on the contrasts specified in the contrasts.tsv file, located in the data/BIDS/code directory.

The standard outputs of an FSL analysis are created in the output directory, including parameter estimates (pe*.nii.gz), contrast estimates (con*.nii.gz), and residuals. For exploring significance at the run level, the con*zstat.nii.gz are the most useful files, while higher-level models will use the cope and varcope images as inputs to their mixed-effects models.

## Second level analyses 

Subject-level or second-level modeling combines the GLMs across runs, per subject. 

The subject-level scripts will take the data from first level analyses and do operations on them; namely, we use the copes (beta estimates) and varcopes (variance estimates) using FSL's fixed-effects flow. We again use Nipype to execute this. Specifically, we use the FSL FEAT sub-tool called FLAME (FMRIB's Local Analysis of Mixed Effects). 

There are two avenues for combining run-level model outputs after creating first-level models, though the second is more commonly used, and also includes the outputs of the first:

(1) Traditional: Create a single second-level model combining all runs of a task, per subject and per contrast.

(2) Iterative: Iteratively create a second-level model for each set of n-1 runs (excluding 1 run from all n runs), per task, per subject, per contrast. (Note: we will call each of these leave-one-run-out combinations a "fold.") This allows us to e.g., select the top voxels based on n-1/n of the data and extract the betas only from the held-out run. We repeat for each possible fold (leave out each run once), then average the results from the held-out runs. 