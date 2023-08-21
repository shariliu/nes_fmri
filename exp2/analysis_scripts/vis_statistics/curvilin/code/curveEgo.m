clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

egoImgs = dir([imgDir filesep 'scn_e_*.jpg']); egoImgs = {egoImgs.name};
[egoCurve,egoRect] = curviRectInfo_avgAll(imgDir,egoImgs);

toc
save([thisDir filesep 'data' filesep 'crEgo4.mat']);