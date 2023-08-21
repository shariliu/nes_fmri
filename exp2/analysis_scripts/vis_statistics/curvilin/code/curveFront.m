clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

frontVids = dir([imgDir filesep 'fac_f_*.jpg']); frontVids = {frontVids.name};
[frontCurve,frontRect] = curviRectInfo_avgAll(imgDir,frontVids);

toc
save([thisDir filesep 'data' filesep 'crFront4.mat']);