# EXPT_MDLoc_matlab

This repository contains the MDLoc (multiple demand network
localizer) experiment programmed using Psychtoolbox-3 in
MATLAB.

https://github.mit.edu/EvLab/EXPT_MDLoc_matlab

### Prerequisites

To run this experiment, make sure you have the following installed:
- `Matlab`
- `Psychtoolbox-3 (3.0.17.10)` 
(to verify, open Matlab and type `PsychtoolboxVersion`; it should print out a version number)

If you do not, please [install Matlab](https://ist.mit.edu/matlab/all).
Then follow the [instructions to install PTB-3 from a zip/tar.gz file](https://github.com/Psychtoolbox-3/Psychtoolbox-3/releases/tag/3.0.17.10).



### Usage

1. Open `matlab`
1. `cd` to the directory containing the experiment (suggested location: `~/evlab-experiments/grid-mdloc/`)
1. run the matlab script `grid_MDloc_ips224_2021(SUBJECT_ID, ORDER)`


### Backing up

This experiment uses `git` to backup experiment code as well
as data across evlab computers and openmind. The backups are
hosted at [`github.mit.edu/EvLab/MDLoc_matlab`](https://github.mit.edu/EvLab/MDLoc_matlab.git)
and require MIT login to access. The following section will
guide you about how to backup the files.

1. make sure there are no loose ends: 
    - `git status` should print out *nothing to commit*
    - if it prints *Changes to be committed: ...*, it means someone did not commit files from a prior session.
     You should carefully look at what files are "staged", and write a commit message if the files should be
     backed up. If they should not be backed up, simply do `git reset` (this only "unstages" files, it does
     not delete anything).
1. identify the data files generated from current session
    - check the `data/` subdirectory.
    - identify the filename (e.g., `TEST_1_data.txt`)
1. "stage" the file for backup: `git add data/TEST_1_data.txt`
1. "commit" the file (be **sure** you have the correct file/s) with a helpful descriptor
    - `git commit --author="Your Name <youremail@mit.edu>" -m "Added data file from scanning session on 1970-01-01 at 2:43pm, session ID FED19700101 blah blah"`
1. `git push` to transmit your changes to the remote copy at `mit.github.edu`
    - if git complains about changes on the remote, you may have to pull first before you push
    `git pull`
