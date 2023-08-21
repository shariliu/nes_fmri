import os
import subprocess as sp
import sys

# Version history:
# Updated by Shari Liu on 9/22/2020

# ---------- FILL IN -----------------------------

# change to your own directory
# videoPath = '/Users/shariliu/Downloads/test/'
# videoPath = '/Users/ShariLiu/Dropbox (MIT)/Research/Studies/' + \
#     '_NIRS/NES/exp2/experiment_scripts/VOE/voe_stimuli/' + \
#     'physics/permanence_create_one-becomes-two-fan/boot/less_contrast/'

videoPath = '/Users/ShariLiu/Dropbox (MIT)/Research/Studies/' + \
    '_NIRS/NES/exp2/experiment_scripts/VOE/voe_stimuli/' + \
    'psychology/goal_1.1_obstacles/trial_19_ramp/more_contrast'

# ----------- DO NOT EDIT WITHOUT ASKING ---------

videoFiles = os.listdir(videoPath)

for video in videoFiles:
    sp.call([
        "ffmpeg",
        "-y",
        "-i",
        os.path.join(videoPath, video),
        "-vf",
        # brightness range: -1 to +1 (default 0); contrast range: -2 to + 2 (default 1)
        "eq=brightness=0:contrast=0.7",
        "-an",
        os.path.join(videoPath, video + "_edited.mp4")
    ])
