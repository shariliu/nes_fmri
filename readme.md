# Violations of physical and psychological expectations in the human adult brain

This paper reports data from two experiments. Within each folder, one per experiment, there are:

## experiment_scripts
This sub-dir contains all the code and stimuli required to executve all the tasks in the experiment. The VOE and DOTSloc tasks were created using jsPsych, and can be run in any browser by opening the associated html file, e.g. `VOE/VOE_fMRI_exp2.html` The two other tasks (MotionLoc and spWMLoc) require Matlab and Psychtoolbox. The versions on our scanning computer were: Matlab version R2022a and Psychtoolbox version 3.0.18. 

## analysis_scripts
This sub-dir contains all the code and ROI data required to clean, process, and excecute the analyses reported in the paper. They should be run in the order they are listed, i.e. first `0_ProcessData`, then `1_Univariate`, etc

HTML outputs for each file are available at:

https://rpubs.com/shariliu/nes_exp1_univariate
https://rpubs.com/shariliu/nes_exp2_univariate
https://rpubs.com/shariliu/nes_exp1_multivariate
https://rpubs.com/shariliu/nes_exp1_multivariate
https://rpubs.com/shariliu/nes_results

The `input_data/` dir contains basic information about all the subjects who participated `study_subjects.csv`, all the ROI parcels `manyregions_info.csv`, and the ROI analysis outputs. 

The `outputs/` dir contains results and summaries derived from the input data.

The `event_scripts/` dir contains scripts required to convert raw outputs from Matlab and jsPsych (one per run per per task perparticipant; not openly shared because they contain dates and other information that could be used, together with other data, to guess who participated) into a condensed format required for fMRI analysis.

The `vis_statistics/` dir (in exp2) contains scripts for splitting stimulus videos into stills, and calculating the following features:
- luminance
- contrast
- motion
- curvilinearity
- rectilinearity
- low spatial frequency 
- high spatial frequency

To reproduce all the results and figures in the paper, run the following scripts in the order they are listed.

In `0a_StimulusFeatures_Prepare.Rmd` (in exp 2), we read in the results of the visual statistics scripts, z score them, and organize them by experiment, saving the outputs to (`outputs/visual_statistics/`). We also do some summary statistics over the features per condition. 

In `0_ProcessData.Rmd`, we take the ROI data and join it with data about the subjects who participated in the study, as well as extra information about the regionss. This script also computes the pairwise distances between all conditions (psych unexp and exp, phys unexp and exp). Additionally, we take the ROI data for each event presented ("single betas") and join it with information about visual statistics for each video. For all of these tasks, we save the resulting outputs downstream analysis (in `outputs/`).

In `1_Univariate.Rmd`, we conduct both confirmatory and exploratory univariate analyses, and save the outputs.

In `2_Multivariate.Rmd`, we conduct both confirmatory and exploratory multivariate analyses, and save the outputs.

In `3_ReportFindings.Rmd` (only in exp 1 - but reports findings from both experiments), we read in data from `outputs/` and report them in APA format. 

In `4_Data_Codebooks`, we generate codebooks for all original input data.

Throughout these analyses, the domain label for `psychology-action` events is `psychology` and the domain label for `psychology-environment` events is `both` - since the events cross domain boundaries. This differs from the paper which calls the three domains: `physics` `psychology-action` `psychology-environment`.

## Large files
There are some files, that are too large and/or unwieldy to share on Github. Below we indicate that paths of these files, and where you can find them on OSF. To run the experiment and analysis scripts, these files should be slotted back into the appropriate directory.

- Experiment 1 VOE stimuli `exp1/experiment_scripts/stim/`
- Experiment 2 VOE stimuli `exp2/experiment_scripts/VOE/voe_stimuli`
- Experiments 1-2 DOTS stimuli `exp*/experiment_scripts/DOTSloc/fischer_videos`
- Experiment 1 input data to analysis `exp1/analysis_scripts/input_data`
- Experiment 2 input data to analysis `exp2/analysis_scripts/input_data`

## Brain images and parcels
ROI parcels for this project can be found at https://osf.io/tyh5b. De-faced brain images for a subset of this dataset will be uploaded to OpenNeuro upon publication of this paper.

```
.
├── LICENSE
├── arrays
├── exp1
│   ├── analysis_scripts
│   └── experiment_scripts
├── exp2
│   ├── analysis_scripts
│   └── experiment_scripts
├── readme.md
├── roi_parcels
│   ├── README
│   ├── domain_specific_data_driven_parcels
│   ├── md_parcels
│   └── visual_parcels
└── saxelab_fmri_pipeline.md
```