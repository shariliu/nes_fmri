clear all
close all
clc

newImgDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4/normImgs';

vidDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/vidFrames';
frames = dir([vidDir filesep '*.jpg']); frames = {frames.name};
getImgs(vidDir,frames,newImgDir);

picDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/pics';
pics = dir([picDir filesep '*.jpg']); pics = {pics.name};
getImgs(picDir,pics,newImgDir);