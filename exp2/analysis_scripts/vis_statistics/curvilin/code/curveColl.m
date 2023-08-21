clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

collImgs = dir([imgDir filesep 'obj_c_*.jpg']); collImgs = {collImgs.name};
[collCurve,collRect] = curviRectInfo_avgAll(imgDir,collImgs);

toc
save([thisDir filesep 'data' filesep 'crColl4.mat']);