clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

shapeImgs = dir([imgDir filesep 'obj_s_*.jpg']); shapeImgs = {shapeImgs.name};
[shapeCurve,shapeRect] = curviRectInfo_avgAll(imgDir,shapeImgs);

toc
save([thisDir filesep 'data' filesep 'crShapes4.mat']);