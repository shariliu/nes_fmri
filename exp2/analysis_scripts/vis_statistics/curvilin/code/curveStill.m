clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

stillImgs = dir([imgDir filesep 'scn_s_*.jpg']); stillImgs = {stillImgs.name};
[stillCurve,stillRect]= curviRectInfo_avgAll(imgDir,stillImgs);

toc
save([thisDir filesep 'data' filesep 'crStill4.mat']);