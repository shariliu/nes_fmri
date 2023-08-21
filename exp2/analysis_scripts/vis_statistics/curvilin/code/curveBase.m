clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

baseImgs = dir([imgDir filesep 'bsl*.jpg']); baseImgs = {baseImgs.name};
[baseCurv,baseRect] = curviRectInfo_avgAll(imgDir,baseImgs);

toc
save([thisDir filesep 'data' filesep 'crBase4.mat']);