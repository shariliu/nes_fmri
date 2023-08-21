% Leyla Tarhan
% 6/2017
% MATLAB R2015b

% Step 2 in calculating motion energy using the Gallant Lab's code: check
% out and format the outputs for each video. This includes making some
% summary figures to see what the output looks like, and making a feature
% matrix (videos x ME features) from a reduced version of the original
% 6,555 output "features" from Step1.

% In this version, tried to methodically work through several ways of
% transforming the raw motion energy output into a feature matrix:
    % (1) Collapse across frames to get one feature vector (6,555 long) per video
       % (a) average -- decided to go with this one
       % (b) max
       % (c) gaussian downsampling
       % (https://en.wikipedia.org/wiki/Gaussian_blur)
       % (methods based largely on the options in Mark Lescroart's code to
       % downsample output to match the TR)
       
   % (2) Once you've done (1), reduce the # of features from 6,555 to 
   % something more tractable
        % (a) PCA (how many PC's is optimal? Actually need a LOT of PC's bc
        % each one only accounts for a small amount of the total variance.)
        % (b) don't make any changes, just do feature modeling with
        % regularized regression on the 120-by-6,555 feature matrix. --
        % decided to go with this one, so this script also saves the
        % resulting feature matrix for use in feature modeling.
        
    % (3) Do some sanity checks to make sure the outputs are making sense.

% Step2_makeFeatureMatrix_take1:
    % Here, I tried two different ways of reducing the output features using
    % PCA:
        % - (1) average across all rows (frames) to get a feature vector for
        % each video, then get the first 20 PC's from the resulting matrix
        % - (2) do the PCA on the super-matrix first, then average across all
        % rows (frames) in each video
%--------------------------------------------------------------------------
% To Do:
%% Clean up
clear all
close all
clc

%% Set up directories/paths

% directory to get the output data from:
dataDir = 'data';

% directory to save figures in:
saveDir = 'Figures';
if ~exist(saveDir, 'dir'); mkdir(saveDir); end

% directory to save the feature matrix in:
saveDir_fm = 'C:\Users\Leyla\Dropbox (KonkLab)\Research-Tarhan\Project - ActionMapping - Videos\Experiments - fMRI\Analysis\Analysis2b-RegularizedFeatureModeling\Data\FeatureModels';
if ~exist(saveDir_fm, 'dir'); mkdir(saveDir_fm); end

% directory with the key frames:
kfDir = 'C:\Users\Leyla\Dropbox (KonkLab)\Research-Tarhan\Project - ActionMapping - Videos\Experiments - Turk\Exp6 - Means iter 3\VideoImages_iter2';

% # of frames per video:
numFrames = 75;

% # of videos:
numVids = 120;

% # wavelets in the motion energy function:
numWaves = 6555;

addpath('Helpers');
addpath(genpath('Helpers-MotionEnergy'));

% If running step 3, can go straight there from here.
%% Get the list of data files

dataList = dir(fullfile(dataDir, '*.*'));
dataList = {dataList.name}';
dataList(strncmp('.', dataList, 1)) = [];

dataList

%%
%--------------------------------------------------------------------------
% (1) Collapse across frames
%--------------------------------------------------------------------------
disp('Question 1: how should I collapse across the frames?...')
%% Load in the data

% set up a cube to save the data in (frames x waves x vids)
cube = nan(numFrames, numWaves, length(dataList));
% set up matrices to store collapsed feature vectors (vids x 
vectors_ave = nan(length(dataList), numWaves);
vectors_max = nan(length(dataList), numWaves);
vectors_gauss = nan(length(dataList), numWaves);
% set up a vector for video names:
names = [];

% loop through the data files:
for d = 1:length(dataList)
   % get the vidName:
   vn1 = strsplit(dataList{d}, '_MEoutput.mat');
   vn = vn1{1};
   names{d} = lower(vn);
   
   % add the feature matrix (frames x wavelets) to the cube:
   dat = load(fullfile(dataDir, dataList{d}));
   cube(:, :, d) = dat.S_fin;
   
   % average across frames and add the resulting feature vector to the
   % matrix of vectors:
   vectors_ave(d, :) = mean(dat.S_fin, 1);  
   
   % max across frames:
   vectors_max(d, :) = max(dat.S_fin);
   
   % gaussian:
   S_gauss2 = []; 
   S_gauss = [];
   params.gaussParams = [1,2]; % mean, standard deviation
   ksigma = params.gaussParams(1);
   if ksigma~=0
       fr_per_sample = 2.5*30; % or could just use numFrames
       % from original Gallant lab code:
       % fr_per_sample = params.sampleSec*params.imHz 
       % so, vid duration * frame rate = 2.5*30 fps
       ki = -ksigma*2.5:1/fr_per_sample:ksigma*2.5;
       k = exp(-ki.^2/(2*ksigma^2));
       % S = conv2(S, k'/sum(k), 'same');
       S_gauss = conv2(dat.S_fin, k'/sum(k), 'same');
   end
   sonset = 7;
   if length(params.gaussParams)>=2
       sonset = params.gaussParams(2);
   end
   S_gauss2 = S_gauss(sonset:fr_per_sample:end,:);
   
   vectors_gauss(d, :) = S_gauss2;
end

disp('Finished loading and data and collapsing across frames.')

%% Normalize the collapsed data before assessing the best method
% original output was normalized, but now that I've transformed it seems
% reasonable to re-normalize.

% specify some parameters (directly from Gallant lab's code:
% preprocNormalize_GetMetaParameters(2))
params.valid_w_index = []; % specific index of channels to keep (overrides .reduceChannels)
params.normalize = 'zscore'; % normalization method
params.crop = []; % min/max to which to crop; empty does nothing
% check out the params:
params

% lifted directly from Gallant lab's code: preprocNormalize.m):
% z-score the mean-collapsed features:
[vectors_ave_norm, stds_ave, means_ave] = norm_std_mean(vectors_ave);

% Quickly check that this worked:
figure(); hist(stds_ave); title('Normalized standard deviations')
figure(); hist(means_ave); title('Normalized means')
params.means.ave = means_ave;
params.stds.ave = stds_ave;

% z-score the max-collapsed features:
[vectors_max_norm, stds_max, means_max] = norm_std_mean(vectors_max);
params.means.max = means_max;
params.stds.max = stds_max;

% z-score the gaussian-collapsed features:
[vectors_gauss_norm, stds_gauss, means_gauss] = norm_std_mean(vectors_gauss);
params.means.gauss = means_gauss;
params.stds.gauss = stds_gauss;

disp('Z-scored all collapsed data.')
% [] hm, now means are all zeroed but so are std's...

%% Compare collapsing methods

% make some general-use RDM's:
rdm_ave = pdist(vectors_ave_norm, 'correlation');
rdm_max = pdist(vectors_max_norm, 'correlation');
rdm_gauss = pdist(vectors_gauss_norm, 'correlation');

% (1) How similar are their results?
% correlate RDM's 
figure('Position', [20, 80, 1000, 500], 'color', [1 1 1])
colormap('jet')

subplot(2, 5, 1)
imagesc(squareform(rdm_ave))
axis square tight off
title('Mean-collapsed')

subplot(2, 5, 2)
corr_ave_max = corrcoef(rdm_ave, rdm_max);
h = text(.5, .5, sprintf('<--- r = %2.2f --->', corr_ave_max(2)), 'FontSize', 12);
set(h, 'HorizontalAlignment', 'center');
axis square tight off

subplot(2, 5, 3)
imagesc(squareform(rdm_max))
axis square tight off
title('Max-collapsed')

subplot(2, 5, 4)
corr_max_gauss = corrcoef(rdm_max, rdm_gauss);
h = text(.5, .5, sprintf('<--- r = %2.2f --->', corr_max_gauss(2)), 'FontSize', 12);
set(h, 'HorizontalAlignment', 'center');
axis square tight off

subplot(2, 5, 5)
imagesc(squareform(rdm_gauss));
axis square tight off
title('Gaussian-collapsed')

subplot(2, 5, 8)
corr_ave_gauss = corrcoef(rdm_ave, rdm_gauss);
h = text(.5, .5, sprintf('<--- r = %2.2f --->', corr_ave_gauss(2)), 'FontSize', 12);
set(h, 'HorizontalAlignment', 'center');
axis square tight off

saveFigureHelper(1, saveDir, 'CompareCollapsingMethods_corr.png')
close

%--------------------------------------------------------------------------

% (2) How reasonable are their results?
% For each method: 
    % - pull out the 4(?) most and least similar videos based on the RDM's
    % - compare how reasonable those seem

% load in the video model, which has paths to each video's key frame:
load(fullfile('Video Model', 'V.mat'));

% make and save a new version, with the updated key frame paths:
for v = 1:numVids
    % get the file name without the path:
    keyFramePath_1 = V.keyFramePath{v};
    pathParts = strsplit(keyFramePath_1, '\');
    pathlessName = pathParts{end};
    
    % make sure it's in the same order as the data:
    nameAlone = strsplit(pathlessName, '.');
    nameAlone = nameAlone{1};
    dataIdx = find(strcmp(names, lower(nameAlone)));
    assert(dataIdx == v, ['Order mismatch bt RPC data and key frame paths: ', nameAlone'.'])
    
    % add on the new path and store it:
    newKeyFramePath{v} = fullfile(kfDir, pathlessName);
end

vidName = V.vidName;
videoPath = V.videoPath;
activityGroup = V.activityGroup;
actionAndNum = V.actionAndNum;
action = V.action;
exemplarNum = V.exemplarNum;
displayName = V.displayName;
turkSetName = V.turkSetName;

% add in the other fields from V and save it:
save(fullfile('Video Model', 'V2.mat'), 'newKeyFramePath', 'vidName', ...
    'videoPath', 'activityGroup', 'actionAndNum', 'action', 'exemplarNum', ...
    'displayName', 'turkSetName');
disp('Saved new video model with updated key frame paths.')

% plot extremes of the similarity spectrum:
figure('Color', [1 1 1], 'Position', [10, 80, 1000, 900])    
methods = {'Mean-collapsed', 'Max-collapsed', 'Gaussian'};

spcounter = 1;
for m = 1:length(methods)
    if strcmp(methods{m}, 'Mean-collapsed')
        currRDM = rdm_ave;
    elseif strcmp(methods{m}, 'Max-collapsed')
        currRDM = rdm_max;
    elseif strcmp(methods{m}, 'Gaussian')
        currRDM = rdm_gauss;
    end
    
    % (a) most similar pair
    % loop through the squareformed rdm and see which value matches the
    % minimum from the lower-triangle-vector
    rdm_square = squareform(currRDM);
    answer = [];
    for i = 1:numVids
        for j = 1:numVids
            if rdm_square(i, j) == min(currRDM)
                answer = [i, j];
            end
        end
    end
    
    % plot the most similar pair:
    subplot(3, 2, spcounter)   
    [hi1, hi2] = newKeyFramePath{answer};
    montage([{hi1}, {hi2}])
    
    if m == 1
        title('Most Similar Vids')
    end
    
    ylabel(methods{m})

    % (b) least similar pair (max. dissimilarity)
    answer = [];
    for i = 1:numVids
        for j = 1:numVids
            if rdm_square(i, j) == max(currRDM)
                answer = [i, j];
            end
        end
    end
    
    % plot the least similar pair:
    subplot(3, 2, spcounter + 1)   
    [low1, low2] = newKeyFramePath{answer};
    montage([{low1}, {low2}])
    
    if m == 1
        title('Least Similar Vids')
    end    
    spcounter = spcounter + 2;
end

% save it:
saveFigureHelper(1, saveDir, 'CompareCollapsingMethods_lohi.png')
close

% -------------------------------------------------------------------------
% (3) Going with just the mean-collapsing method, do a deeper dive into how
% reasonable the results are:

figure('Color', [1 1 1], 'Position', [10, 80, 1000, 900])

% sort the lower-triangle vector to get the highest and lowest pairwise 
% similarities:
numPairs = 4;
rdm_square = squareform(rdm_ave);
[s si] = sort(rdm_ave);
% check out the distribution -- they're really all quite similar to
% one another (probably bc of the normalization?) -- not enough variance in
% the model to be well-fitted?
hist(s); title('Distribution of pairwise dissimilarities after mean-collapsing frames')
highestPairs = s(1:numPairs); % most similar = lowest correlation distance
lowestPairs = s(end-(numPairs-1):end);

% loop through the squareforms rdm and see which values match the pairs:
spCounter = 1;
for p = 1:numPairs
   % current low:
   answer = [];
   for i = 1:numVids
       for j = 1:numVids
           if rdm_square(i, j) == lowestPairs(p)
               answer = [i, j];
           end
       end
   end
   
   % plot the least similar pair:
   subplot(numPairs, 2, spCounter)
   [lo1, lo2] = newKeyFramePath{answer};
   montage([{lo1}, {lo2}])
   
   if p == 1
       title('Least Similar Pairs')
   end
   
   % current high:
   answer = [];
   for i = 1:numVids
       for j = 1:numVids
           if rdm_square(i, j) == highestPairs(p)
               answer = [i, j];
           end
       end
   end
   
   % plot the least similar pair:
   subplot(numPairs, 2, spCounter+1)
   [hi1, hi2] = newKeyFramePath{answer};
   montage([{hi1}, {hi2}])
   
   if p == 1
       title('Most Similar Pairs')
   end
   
   spCounter = spCounter + 2;
end

% save it:
saveFigureHelper(1, saveDir, 'MeanCollapse_lohi.png')
close all

%%
%--------------------------------------------------------------------------
% (2) Reduce the # of features
%--------------------------------------------------------------------------
clc
disp('Question 2: how should I deal with the high # of features?')
%%
% Decided to go with the mean-collapsing method, so everything from here
% out is performed on those data.

% N.B.: a reasonable alternative would be to just use regularized
% regression (probably lasso -- need to look deeper into this)

% use built-in PCA function to get out the first 20 (arbitrary) PC's and 
% look at their variance explained:

%     COEFF = pca(X) returns the principal component coefficients for the N
%     by P data matrix X. Rows of X correspond to observations and columns to
%     variables. Each column of COEFF contains coefficients for one principal
%     component. The columns are in descending order in terms of component
%     variance (LATENT). pca, by default, centers the data and uses the
%     singular value decomposition algorithm. For the non-default options,
%     use the name/value pair arguments.

%     [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(X) returns a vector
%     containing the percentage of the total variance explained by each
%     principal component.

[itemsInPCSpace, pcScores, latent, tsquared, varExplained] = pca(vectors_ave');
% itemsInPCSpace ('COEFF') = the relevant data to put in a feature matrix
% (won't return more than min(# observations, # features), so it's a
% 120-by-120 matrix)

% pull out just the first 20:
pcScores_20 = itemsInPCSpace(:, 1:20); % feature matrix = 120 x 20

% look at the variance explained by these first 20:
compVariance = varExplained(1:20)./sum(varExplained).*100; % variance in % for each PC
totalVariance = cumsum(compVariance); % at each stage, how much of the variance is accounted for?

% plot it:
bar(compVariance)
xlim([0 21]);
ylim([0 100]);
hold on
plot(totalVariance, 'k', 'LineWidth', 2)
xlabel('Components');
ylabel('% variance explained');
title('Individual and cumulative variance explained by PC 1 - 20')
saveFigureHelper(1, saveDir, 'PCVarianceExplained.png')
close

%% Save the feature matrix

% will be 120-by-6,555+1 (+1 for total motion energy -- see Huth et al., 
% 2012 for details) (collapsed across frames using averaging)

dimLabels = [];
for d = 1:size(vectors_ave_norm, 2)
   dimLabels{d} = ['wavelet-' num2str(d)];
end
dimLabels{end+1} = 'total motion energy'

dimLabels
itemLabels = names
featureMatrix = vectors_ave_norm;

% add in total motion energy: Huth (2012) and Nishimoto (2011) included
% this as the mean of all the channel-specific outputs (they used 2,139
% instead of 6,555):
totalMotionEnergy = mean(featureMatrix, 2);
[totalMotionEnergy_norm, stds, max] = norm_std_mean(totalMotionEnergy); % normalize
featureMatrix(:, end+1) = totalMotionEnergy_norm; % normalize it

save(fullfile(saveDir_fm, 'MotionEnergy_Gallant_6555_120.mat'), 'featureMatrix', 'itemLabels', 'dimLabels');
disp('Motion Energy - Gallant Style Feature Matrix for 120 actions saved.');

%% (3) Sanity checks

% (1) look at the videos with the highest and lowest *total* motion energy
motEnergyMat = load(fullfile(saveDir_fm, 'MotionEnergy_Gallant_6555_120.mat'));
ME_total = motEnergyMat.featureMatrix(:, end);
hist(ME_total)

[s si] = sort(abs(ME_total)); % s = values from low to high; use absolute value 
% to get metrics of overal magnitude of motion, without direction.
topIdx = si(end-6:end); % 6 highest
bottomIdx = si(1:6); % 6 lowest

% load the key frames struct
load(fullfile('Video Model', 'V2.mat'))

% display the key frames for videos on the extremes of total motion energy:
figure('Color', [1 1 1], 'Position', [10, 80, 1000, 500])   
displayName_new = strrep(displayName, '-', '_');
assert(all(strcmp(motEnergyMat.itemLabels, displayName_new)), 'key frame paths and data are not in the same order.')

% lowest:
subplot(1, 2, 1)
[low1, low2, low3, low4, low5, low6] = newKeyFramePath{bottomIdx};
montage([{low1}, {low2}, {low3}, {low4}, {low5}, {low6}])
title('Lowest Total Motion Energy')

% highest:
subplot(1, 2, 2)
[hi1, hi2, hi3, hi4, hi5, hi6] = newKeyFramePath{topIdx};
montage([{hi1}, {hi2}, {hi3}, {hi4}, {hi5}, {hi6}])
title('Highest Total Motion Energy')

% save it:
saveFigureHelper(1, saveDir, '6555Model_extremes.png');
close all


% (2) how correlated is total motion energy with MTurk movement amount
% ratings?
turkFMdir = 'C:\Users\Leyla\Dropbox (KonkLab)\Research-Tarhan\Project - ActionMapping - Videos\Experiments - fMRI\Analysis\Analysis2-FeatureModeling\Data\FeatureModels';
turkFM = load(fullfile(turkFMdir, 'StructModel.mat'));

% get the movement ratings:
turkMovement = turkFM.M.movement; % (just a singleton)

% make sure they're in the same order
assert(all(strcmp(turkFM.V.activityActionAndNum, motEnergyMat.itemLabels)), 'WARNING: order mismatch.')

% correlate them:
r_totalME_turkMove = corr(turkMovement, ME_total) % -0.0954. So no, they're not correlated.










