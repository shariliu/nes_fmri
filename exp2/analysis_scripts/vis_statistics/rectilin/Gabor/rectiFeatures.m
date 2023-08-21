function featureVector = rectiFeatures(img,rectiArray,d1,d2)

% RECTIFEATURES extracts the rectilinear features of the image.
% It creates a column vector, consisting of the image's features.
% The feature vectors are normalized to zero mean and unit variance. (EDIT:
% this feature has been removed -- Ben Deen, 3/2015)
%
%
% Inputs:
%       img         :	Matrix of the input image 
%       rectiArray	:	Gabor filters bank created by the function gaborFilterBank
%       d1          :	The factor of downsampling along rows.
%                       d1 must be a factor of n if n is the number of rows in img.
%       d2          :	The factor of downsampling along columns.
%                       d2 must be a factor of m if m is the number of columns in img.
%               
% Output:
%       featureVector	:   A column vector with length (m*n*u*v)/(d1*d2). 
%                           This vector is the Gabor feature vector of an 
%                           m by n image. u is the number of scales and
%                           v is the number of orientations in 'rectiArray'.
%
%
% Sample use:
% 
% img = imread('cameraman.tif');
% rectiArray = rectiFilterBank(5,8,39,39);  % Generates the filter bank
% featureVector = rectiFeatures(img,rectiArray,4,4);   % Extracts feature vector, 'featureVector', from the image, 'img'.
% 
% 
% (C)	Mohammad Haghighat, University of Miami
%       haghighat@ieee.org
%       NOTE: edited from gaborFeatures to rectiFeatures by Ben Deen, 3/2015.


if (nargin ~= 4)    % Check correct number of arguments
    error('Use correct number of input arguments!')
end

if size(img,3) == 3	% % Check if the input image is grayscale
    img = rgb2gray(img);
end

img = double(img);

plotResults = 0;


%% Filtering

% Filter input image by each filter
[u,v] = size(rectiArray);
rectiResult = cell(u,v);
for i = 1:u
    for j = 1:v
        rectiResult{i,j} = conv2(img,rectiArray{i,j},'same');
    end
end


%% Feature Extraction

% Extract feature vector from input image
[n,m] = size(img);
s = (n*m)/(d1*d2);
l = s*u*v;
featureVector = zeros(l,1);
c = 0;
for i = 1:u
    for j = 1:v
        
        c = c+1;
        rectiAbs = abs(rectiResult{i,j});
        if d1>1
            rectiAbs = downsample(rectiAbs,d1);
        end;
        if d2>1
            rectiAbs = downsample(rectiAbs.',d2);
        end;
        rectiAbs = reshape(rectiAbs.',[],1);
        
        % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
        %rectiAbs = (rectiAbs-mean(rectiAbs))/std(rectiAbs,1);
        
        featureVector(((c-1)*s+1):(c*s)) = rectiAbs;
        
    end
end


%% Show filtered images

if plotResults
    % Show real parts of filtered images
    figure('NumberTitle','Off','Name','Real parts of filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j)    
            imshow(real(rectiResult{i,j}),[]);
        end
    end
    
    % Show magnitudes of filtered images
    figure('NumberTitle','Off','Name','Magnitudes of filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j)    
            imshow(abs(rectiResult{i,j}),[]);
        end
    end
end;
