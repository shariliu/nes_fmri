function getImgs(picDir,imgNames,newImgDir)
w = 210;
h = 140;
for iImg = 1:length(imgNames)
    % read image
    img = im2double(imread([picDir filesep imgNames{iImg}]));
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    if size(img,1)>h*2
        img = img(1:2:end,:,:);
    end
    if size(img,2)>w*2
        img = img(:,1:2:end,:);
    end
    cH = size(img,1);
    cW = size(img,2);
    y = round(cH/2);
    x = round(cW/2);
    imgNew = img((y-(h/2)):(y+(h/2)-1),(x-(w/2)):(x+(w/2)-1),:);
    % convert to grayscale image
    g = rgb2gray(img);
    % normalize to mean 0 std dev 1
    tmp = reshape(g,[1 numel(g)]);
    n = normalize(tmp);
    nImg = reshape(n,size(g));
    imwrite(nImg,[newImgDir filesep imgNames{iImg}]);
end