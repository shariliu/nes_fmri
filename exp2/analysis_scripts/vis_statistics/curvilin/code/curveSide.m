clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

sideImgs = dir([imgDir filesep 'fac_s_*.jpg']); sideImgs = {sideImgs.name};
[sideCurve,sideRect] = curviRectInfo_avgAll(imgDir,sideImgs);

toc
save([thisDir filesep 'data' filesep 'crSide4.mat']);