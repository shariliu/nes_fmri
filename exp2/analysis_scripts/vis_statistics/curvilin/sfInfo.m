function [lowSFinfo,highSFinfo] = sfInfo(picDir,imgNames)

for iImg = 1:length(imgNames)
    % read image
    img = im2double(imread([picDir filesep imgNames{iImg}]));
    % convert to grayscale image
    g = rgb2gray(img);
    % normalize to mean 0 std dev 1
    tmp = reshape(g,[1 numel(g)]);
    n = normalize(tmp);
    nImg = reshape(n,size(g));
    
    % take 2-D FFT
    F=fftshift(abs(fft2(nImg)));

    %%% filter design
    [f1,f2] = freqspace(size(F),'meshgrid');
    SF = sqrt(f1.^2 + f2.^2);

    % low SF info
    lowSF = ones(size(f1));
    lowSF(SF>.1) = 0;
    lowFilt = lowSF .* F;
    lowSFinfo(iImg) = mean(mean(lowFilt,'omitnan'));

    % high SF info
    highSF = ones(size(f1));
    highSF(SF<.5) = 0;
    highFilt = highSF .* F;
    highSFinfo(iImg) = mean(mean(highFilt,'omitnan'));
end