clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

agentImgs = dir([imgDir filesep 'agt*.jpg']); agentImgs = {agentImgs.name};
[agentCurv,agentRect] = curviRectInfo_avgAll(imgDir,agentImgs);

toc
save([thisDir filesep 'data' filesep 'crAgent4.mat']);