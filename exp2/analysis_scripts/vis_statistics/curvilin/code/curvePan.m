clear all
close all
clc
tic
thisDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4';
imgDir = [thisDir filesep 'normImgs'];

panImgs = dir([imgDir filesep 'scn_p_*.jpg']); panImgs = {panImgs.name};
[panCurve,panRect] = curviRectInfo_avgAll(imgDir,panImgs);

toc
save([thisDir filesep 'data' filesep 'crPan4.mat']);