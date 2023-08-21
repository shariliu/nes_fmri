clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

expImgs = dir([imgDir filesep 'fac_x_*.jpg']); expImgs = {expImgs.name};
[expCurve,expRect] = curviRectInfo_avgAll(imgDir,expImgs);

toc
save([thisDir filesep 'data' filesep 'crExp4.mat']);