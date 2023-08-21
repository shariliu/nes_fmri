% Leyla Tarhan
% 3/2017
% MATLAB R2015b

% Step 2 in calculating motion energy using the Gallant Lab's code: check
% out and format the outputs for each video. This includes making some
% summary figures to see what the output looks like, and making a feature
% matrix (videos x ME features) from a reduced version of the original
% 6,555 output "features" from Step1.

% Here, I tried two different ways of reducing the output features using
% PCA:
    % - (1) average across all rows (frames) to get a feature vector for
    % each video, then get the first 20 PC's from the resulting matrix
    % - (2) do the PCA on the super-matrix first, then average across all
    % rows (frames) in each video
    
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
saveDir_fm = 'C:\Users\Leyla\Dropbox (KonkLab)\Research-Tarhan\Project - ActionMapping - Videos\Experiments - fMRI\Analysis\Analysis2-FeatureModeling\Data\FeatureModels';
if ~exist(saveDir_fm, 'dir'); mkdir(saveDir_fm); end

% # of frames per video:
numFrames = 75;

% # of videos:
numVids = 120;

% # wavelets in the motion energy function:
numWaves = 6555;

addpath('Helpers');

%% Get the list of data files

dataList = dir(fullfile(dataDir, '*.*'));
dataList = {dataList.name}';
dataList(strncmp('.', dataList, 1)) = [];

dataList

%% Load in the data

% set up a cube to save the data in (frames x waves x vids)
cube = nan(numFrames, numWaves, length(dataList));
% set up a matrix to store collapsed feature vectors (vids x 
vectors = nan(length(dataList), numWaves);
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
   vectors(d, :) = mean(dat.S_fin, 1);  
end

disp('Finished loading data in.')

%% PCA to decompose the feature matrix

% Based on how Talia did this with the gist features (Research-Tarhan\
% Project - ActionMapping - Videos\Experiments - fMRI\AnalysisTK\
% Analysis4-GistFeatures)

% using Talia's custom pc code (very confusing at first, before I renamed
% it!)
numPCs = 20; % just has to be < # features-1 
%--------------------------------------------------------------------------
% Method 1: PCA on averaged feature matrix
%--------------------------------------------------------------------------
% do the PCA on the 120-by-6,555 matrix made above ('vectors'), get the
% first 20 out and try to visualize them.

% input format: wavelet features x videos (so, need to transpose the
% 'vectors' matrix)
[itemsInPCSpace_1, pcScores_1, latent_1] = pca_forGist(vectors', numPCs);

% rotate the matrix, so rows = features and columns = PC's:
featurePCs_1 = itemsInPCSpace_1';

% check it:
size(featurePCs_1)
imagesc(featurePCs_1)
xlabel('20 PCs of 6,555 wavelets')
ylabel('Videos')
title(['First ' num2str(numPCs) ' PCs from averaged feature vectors'])
%--------------------------------------------------------------------------
% Method 2: PCA on raw super-feature matrix
%--------------------------------------------------------------------------
% take the cube built above and make it into a long matrix (vertically
% concatenate each of the layers of the cube so that you have a 120*75 by
% 6555 matrix). Then do PCA on that and get the first 20 PC's. Then average
% across rows within each video to get a 120-by-20 matrix.

% make the super-matrix:
superMat = nan(numVids*numFrames, numWaves);
counter = 1;
for v = 1:size(cube, 3)
    superMat(counter:counter+numFrames-1, :) = cube(:, :, v);
    counter = counter + numFrames;
end
disp('Finished making super-matrix.')

% check it:
size(superMat)
imagesc(superMat)

% Get the first 20 PCs:
[itemsInPCSpace_2, pcScores_2, latent_2] = pca_forGist(superMat', numPCs); % takes awhile...

% rotate the matrix, so rows = features and columns = PC's:
featurePCs_2 = itemsInPCSpace_2';

% average across rows to get a 120-by-20 feature matrix:
avgFeaturePCs_2 = nan(numVids, numPCs);
rowCounter = 1;
for v = 1:numVids
    currPcMat = featurePCs_2(rowCounter:rowCounter+numFrames-1, :);
    avgFeaturePCs_2(v, :) = mean(currPcMat, 1);
    rowCounter = rowCounter + numFrames;
end
disp('Finished averaging over frames: method 2')

% check it:
size(avgFeaturePCs_2)
figure()
imagesc(avgFeaturePCs_2)
xlabel('20 PCs of 6,555 wavelets')
ylabel('Videos')
title(['Across-frames avg. of first ' num2str(numPCs) ' PCs from raw feature matrices'])

close all

%% Make some summary figures

% (1) Matrix of the feature vectors (one feature matrix for all videos):
figure('Position', [10, 60, 1500, 800])
imagesc(vectors)
ylabel('Video')
xlabel('Wavelets')
set(gca, 'YTick', 1:length(dataList))
set(gca, 'YTickLabel', names, 'FontSize', 8)
colorbar()
title('Feature Matrix of averaged feature vectors for 120 videos')
saveFigureHelper(1, saveDir, '120Vids_avgMatrix.png')
close

% (2) Compare the 2 PC'd feature matrices:
figure('Color', [1 1 1], 'Position', [10, 60, 1500, 800])

% (a) Method 1:
subplot(1, 3, 1)
RDM_m1 = squareform(pdist(featurePCs_1, 'correlation'));
imagesc(RDM_m1)
title(['Method 1: avg across frames then PC'])
axis square tight off

% (b) Method 2:
subplot(1, 3, 3)
RDM_m2 = squareform(pdist(avgFeaturePCs_2, 'correlation'));
imagesc(RDM_m2)
title(['Method 2: PC then avg across frames'])
axis square tight off

% (c) correlation between feature matrices using the 2 methods:
subplot(1, 3, 2)
corr_methods = corr(getLowerTri(RDM_m1), getLowerTri(RDM_m2));
h = text(.5, .5, sprintf('<--- r = %2.2f --->', corr_methods), 'FontSize', 12);
set(h, 'HorizontalAlignment', 'center');
axis square tight off

% save it:
saveFigureHelper(1, saveDir, 'comparePCMethods.png');
close

%% Using Method 1 -- check the data

featureMatrix = featurePCs_1;
dimLabels = [];
for d = 1:numPCs
   dimLabels{d} = ['pc-' num2str(d)];
end

% % (1) Check: need to normalize or z-score/0-center the data?
% 
% % what's the distribution on each of the columns?
% figure('Position', [10, 60, 1500, 600]);
% for c = 1:size(featureMatrix, 2)
%     subplot(10, 2, c)
%     hist(featureMatrix(:, c))
%     title(dimLabels{c})
% end
% % looks like they're all on the same scale
% saveFigureHelper(1, saveDir_me, 'MotionEnergy_columnDistrib.png')
% close

% (1) What are the PC's?
% for each PC, show the videos for the 4 lowest and 4 highest videos
saveDir_pc = fullfile(saveDir, 'PCs');
if ~exist(saveDir_pc, 'dir'); mkdir(saveDir_pc); end

% load in the video model, which has paths to each video's key frame:
load(fullfile('Video Model', 'V.mat'));

% check that it's in the same order as the feature matrix:
names_v = [];
for v = 1:numVids
   vn1 = strsplit(V.vidName{v}, '_');
   names_v{v} = [vn1{1}, '_', vn1{2}];
end
assert(all(strcmp(names, names_v)), 'video model and feature matrix are not in the same order.')

% loop through the pc's:
% N.B. The frame paths are out of date (made when folder naming was
% ever-so-slightly different). I made a quick-and-dirty fix by temporarily
% changing the top folder's name, but there are certainly cleaner and more
% annoying ways of accomplishing this.
for pc = 1:numPCs
   figure()
   % sort vids in this PC (lowest to highest values):
   [s si] = sort(featureMatrix(:, pc));
   
   % (a) 4 lowest:
   subplot(1, 2, 1)
   lowVids_idx = si(1:4);
   % get the list of key frames images
   [low1, low2, low3, low4] = V.keyFramePath{lowVids_idx'};
   montage([{low1}, {low2}, {low3}, {low4}])
   title(['4 Lowest Videos on ' dimLabels{pc} ':'])
   
   % (b) 4 highest:
   subplot(1, 2, 2)
   highVids_idx = si(end-4:end);
   % get the list of key frames images
   [hi1, hi2, hi3, hi4] = V.keyFramePath{highVids_idx'};
   montage([{hi1}, {hi2}, {hi3}, {hi4}]);
   title(['4 Highest Videos on ' dimLabels{pc} ':'])
   
   % save it:
   saveFigureHelper(1, saveDir_pc, [dimLabels{pc}, '_hiLow.png']);
   close
end
disp('Finished making and saving PC visualizations.')


% (2) Check which videos are treated as similar/dissimilar based on this
% feature:

% make the RDM again (cleaner code in case I change methods):
rdm = squareform(pdist(featureMatrix, 'correlation'));
imagesc(rdm)
title('Motion Energy feature matrix RDM')

% (a) locate the minimum value (highest similarity, or lowest dissimilarity):
rdm_tri = getLowerTri(rdm);

% So, now we should loop through the matrix and see which value matches the
% minimum from the lower-triangle-vector
answer = [];
for i = 1:120
    for j = 1:120
        if rdm(i, j) == min(rdm_tri)
            answer = [i, j];
        end
    end
end
maxSimItems = {names{answer(1)}, names{answer(2)}};
fprintf('Most similar items based on motion energy: %s and %s \n', maxSimItems{1}, maxSimItems{2});

% (b) locate the maximum value (lowest similarity, or highest dissimilarity):
answer = [];
for i = 1:120
    for j = 1:120
        if rdm(i, j) == max(rdm_tri)
            answer = [i, j];
        end
    end
end
minSimItems = {names{answer(1)}, names{answer(2)}};
fprintf('Least similar items based on motion energy: %s and %s \n', minSimItems{1}, minSimItems{2});

% (3) compare exemplars (out of general curiosity -- not really a data
% check):
% make separate RDM's for each set
s1_idx = [];
s1_baseNames = [];
s2_idx = [];
s2_baseNames = [];
for v = 1:length(names)
   if ~isempty(strfind(names{v}, '1'))
       s1_idx = [s1_idx, v];
       bn1 = strsplit(names{v}, '1');
       s1_baseNames = [s1_baseNames, {bn1{1}}];
   else
       s2_idx = [s2_idx, v];
       bn1 = strsplit(names{v}, '2');
       s2_baseNames = [s2_baseNames, {bn1{1}}];
   end
end
assert(all(length(s1_idx) == 60, length(s2_idx) == 60), 'Didnt catch all items')

% make sure the order matches:
s1_baseNames{49} = 'sleep_sleep';
assert(all(strcmp(s1_baseNames, s2_baseNames)), 'RDMs are not in the same order.')

rdm_s1 = squareform(pdist(featureMatrix(s1_idx, :), 'correlation'));
rdm_s2 = squareform(pdist(featureMatrix(s2_idx, :), 'correlation'));

% correlate them:
r_s1s2 = corr(getLowerTri(rdm_s1), getLowerTri(rdm_s2));

% figure:
figure('Color', [1 1 1], 'Position', [10, 60, 1500, 600]);
subplot(1, 3, 1)
imagesc(rdm_s1);
colormap(jet), axis square tight off, title('Set 1 Motion Energy', 'FontSize', 20);

subplot(1, 3, 2)
axis square tight off, 
h = text(.5, .5, sprintf('<--- r = %2.2f --->', r_s1s2), 'FontSize', 12);
set(h, 'HorizontalAlignment', 'center');

subplot(1, 3, 3)
imagesc(rdm_s2)
colormap(jet), axis square tight off, title('Set 2 Motion Energy', 'FontSize', 20);

%% Save the fields that matter
dimLabels
itemLabels = names

save(fullfile(saveDir_fm, 'MotionEnergy_Gallant_120.mat'), 'featureMatrix', 'itemLabels', 'dimLabels');
disp('Motion Energy - Gallant Style Feature Matrix for 120 actions saved.');

