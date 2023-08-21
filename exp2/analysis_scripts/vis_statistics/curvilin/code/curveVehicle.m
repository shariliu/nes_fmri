clear all
close all
clc

tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

vehicleImgs = dir([imgDir filesep 'obj_v_*.jpg']); vehicleImgs = {vehicleImgs.name};
[vehicleVidCurve,vehicleVidRect] = curviRectInfo_avgAll(imgDir,vehicleImgs);

toc
save([thisDir filesep 'data' filesep 'crVehicle4.mat']);
