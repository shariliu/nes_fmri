clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

feetVids = dir([imgDir filesep 'bod_f_*.jpg']); feetVids = {feetVids.name};
[feetCurve,feetRect] = curviRectInfo_avgAll(imgDir,feetVids);

toc
save([thisDir filesep 'data' filesep 'crFeet4.mat']);