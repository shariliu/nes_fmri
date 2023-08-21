function [w,h] = frameSize(picDir,imgNames)
w = 720;
h = 480;
for iImg = 1:length(imgNames)
    img = im2double(imread([picDir filesep imgNames{iImg}]));
    if size(img,1)<h
        h = size(img,1);
    end
    if size(img,2)<w
        w = size(img,2);
    end
end