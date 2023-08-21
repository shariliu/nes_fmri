clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

handsVids = dir([imgDir filesep 'bod_h_*.jpg']); handsVids = {handsVids.name};
[handCurve,handRect] = curviRectInfo_avgAll(imgDir,handsVids);

toc
save([thisDir filesep 'data' filesep 'crHands4.mat']);