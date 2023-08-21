%%%%%%%%%%%
%% START %%
%%%%%%%%%%%
% LT *slightly* adapted from the demo provided by the Gallant lab
% 3/2017

% Loops through a list of videos and calculates motion energy for
% each (starting with simple test cases, moving on to more complex ones
% later). 

% input: 4-d (frame width x frame height x RGB x # frames) array for each
% video (saved in stacksDir)

% Main output: S_fin (feature matrix of frames x 6,555 wavelets), saved in
% a separate .mat file (in saveDir) for each video. This matrix will
% eventually be reduced into a feature vector for each video in a later
% script ('Step2_makeFeatureMatrix.m').

%% Clean up
clear all
close all
clc
%% Setup

% add path to the code that does all the work:
addpath(genpath('/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Helpers-MotionEnergy')); 

% visualizations of the feature matrix and sample wavelets pop up for each
% video?
do_followup_viz = false;

% Directory with these frame-stacks for each video:
stacksDir = 'xSimpit/Input Arrays_1EgoMotion_cropped';

% Directory to save the output for each video in:
saveDir = 'Data_1EgoMotion_cropped/all';
if ~exist(saveDir, 'dir'); mkdir(saveDir); end

%% Get the list of inputs
%1 array per video
vidList = dir(fullfile(stacksDir));
vidList = {vidList.name}';
vidList(strncmp('.', vidList, 1)) = [];
vidList

%% Get the input parameters

gparams_init = preprocWavelets_grid_GetMetaParams(1);

% Process with Gabor wavelets
% The numerical argument here specifies a set of parameters for the
% preprocWavelets_grid function, that dictate the locations, spatial
% frequencies, phases, and orientations of Gabors to use. 2 specifies Gabor
% wavelets with three different temporal frequencies (0, 2, and 4 hz),
% suitable for computing motion energy in movies.

% LT: tried doing this with argument = 1 (comments indicate this is closer
% for modeling fMRI data, though their fMRI parameters/concerns differ from
% ours (they want TR-by-TR data while subjects watch a minutes-long video);

% Only difference is it uses fewer channels/wavelets, so you get fewer
% outputs. For now, just stick with 2 (which was the default in the demo)

% [] 3/2017: moved this outside of the loop since it takes a long time
% (actually, it's quite quick but may as well cut down on time if possible)
% and won't change depending upon the stimulus.

%% Loop through the videos
for v = 1:length(vidList)
   
       

    clc
    sn1 = strsplit(vidList{v}, '.');
    sn2 = strsplit(sn1{1}, '_');
%     disp(sprintf('Starting on video %d of %d: %s...', v, length(vidList), [sn2{1} '_' sn2{2}]));
    disp(sprintf('Starting on video %d of %d: %s...', v, length(vidList), sn2{1}));
    fname = fullfile(stacksDir, vidList{v});
    
    if ~exist(fullfile(saveDir, [sn1{1} '_MEoutput.mat']))

        %% Load images
        try
            d = load(fname);
        catch err_msg
            fprintf('You may need to modify the "fname" variable in ComputeMotionEnergy.m\nto point to a .mat file with movie frames in it!\n')
            throw(err_msg);
        end
        
        % % Check the size:
    %     size(d.array)
        %
        % % look at a frame (choose a later one so not just all white):
    %     imshow(d.array(:, :, :, 5))
        
    %     for i = 1:170
    %     subplot(13,14,i); imshow(d.array(:, :, :, i))
    %     end
        % close
        
        % the field d.array is an array that is (361 x 361 x 3 x 12); (X x Y x Color x
        % Images).  The images are stored as 8-bit integer arrays (no decimal
        % places, with pixel values from 0-255). These should be converted to
        % floating point decimals from 0-1:
        S  = single(d.array)/255;
        
        %% Preprocessing
        % Convert to grayscale (luminance only)
        % The argument 1 here indicates a pre-specified set of parameters to feed
        % to the preprocColorSpace function to convert from RGB images to
        % luminance values by converting from RGB to L*A*B colorspace and then
        % keeping only the luminance channel. (You could also use matlab's
        % rgb2gray.m function, but this is more principled.) Inspect cparams to see
        % what those parameters are.
        cparams = preprocColorSpace_GetMetaParams(1);
        [S_lum, cparams] = preprocColorSpace(S, cparams);
        
        % % look at the same frame:
    %     imshow(S_lum(:, :, 5)) % hm, definitely looks a bit blocky but we won't worry about that for now.
        % close
        
        %% Gabor wavelet processing
        % The actual motion energy-calculating step.
        
        % Process with Gabor wavelets
        % The numerical argument here specifies a set of parameters for the
        % preprocWavelets_grid function, that dictate the locations, spatial
        % frequencies, phases, and orientations of Gabors to use. 2 specifies Gabor
        % wavelets with three different temporal frequencies (0, 2, and 4 hz),
        % suitable for computing motion energy in movies.
        % gparams = preprocWavelets_grid_GetMetaParams(2);
        % [] 3/2017: moved this outside of the loop since it takes a long time
        % (I think) and won't change depending upon the stimulus.
        
        % % LT: tried doing this with argument = 1 (comments indicate this is closer
        % % for modeling fMRI data, though their fMRI parameters/concerns differ from
        % % ours (they want TR-by-TR data while subjects watch a minutes-long video);
        % gparams = preprocWavelets_grid_GetMetaParams(1);
        % % Only difference is it uses fewer channels/wavelets, so you get fewer
        % outputs. For now, just stick with 2 (which was the default in the demo)
        [S_gab, gparams] = preprocWavelets_grid(S_lum, gparams_init);
        
        %% Optional additions
        % Compute log of each channel to scale down very large values
        nlparams = preprocNonLinearOut_GetMetaParams(1);
        [S_nl, nlparams] = preprocNonLinearOut(S_gab, nlparams);
        
        % Downsample data to the sampling rate of your fMRI data (the TR)
        % LT: this shouldn't be necessary for my project, so I've commented it out.
        % dsparams = preprocDownsample_GetMetaParams(1); % for TR=1; use (2) for TR=2
        % [S_ds, dsparams] = preprocDownsample(S_nl, dsparams);
        
        % Z-score each channel
        nrmparams = preprocNormalize_GetMetaParams(1);
        % [S_fin, nrmparams] = preprocNormalize(S_ds, nrmparams);
        [S_fin, nrmparams] = preprocNormalize(S_nl, nrmparams); % LT changed this bc skipping the downsampling step
        
        %% Save output
    % %     save(fullfile(saveDir, [sn2{1} '_' sn2{2} '_MEoutput.mat']), 'S_fin', 'nrmparams');
    %     save(fullfile(saveDir, [sn2{1} '_MEoutput.mat']), 'S_fin', 'nrmparams');
    %     disp(['Saved output for ' sn2{1} '!']);
        save(fullfile(saveDir, [sn1{1} '_MEoutput.mat']), 'S_fin', 'nrmparams');
        disp(['Saved output for ' sn1{1} '!']);
    end
end

disp('Finished making and saving outputs for all videos!')
%% Display output

% I'm making a separate script to display the feature matrices and save
% those figures -- this is just a quick visualization and won't save anything.

if do_followup_viz
    % Simple feature size
    disp('Final matrix size (images x features):')
    disp(size(S_fin));
    % show image of feature matrix
    imagesc(S_fin);
    % ylabel('Time (TR)')
    ylabel('Time (Frame)') % LT changed: time is only measured in TR's if 
    % you downsampled it above (which I decided wasn't the right thing for 
    % our data)
    xlabel('Gabor wavelet feature')
    caxis([-3,3]);
    colorbar();
    title('Un-Reduced Feature Matrix')
    % Create examples of Gabor wavelets used for each feature
    gparams.show_or_preprocess = 0;
    [gab, pp] = preprocWavelets_grid(zeros(96,96), gparams);
    fig = figure();
    % 150th Gabor wavelet (corresponds to 150th column on x axis in plot above)
    subplot(121);
    imagesc(gab(:,:,1,150));
    caxis([-1,1])
    axis image off
    title('150th Gabor filter')
    % 1220th Gabor wavelet
    subplot(122);
    imagesc(gab(:,:,1,1219));
    caxis([-1,1])
    axis image off
    title('1221th Gabor filter')
    colormap(gray)
end































%%%%%%%%%%%
%% START %%
%%%%%%%%%%%
% LT *slightly* adapted from the demo provided by the Gallant lab
% 3/2017

% Loops through a list of videos and calculates motion energy for
% each (starting with simple test cases, moving on to more complex ones
% later).

% input: 4-d (frame width x frame height x RGB x # frames) array for each
% video (saved in stacksDir)

% Main output: S_fin (feature matrix of frames x 6,555 wavelets), saved in
% a separate .mat file (in saveDir) for each video. This matrix will
% eventually be reduced into a feature vector for each video in a later
% script ('Step2_makeFeatureMatrix.m').

%% Clean up
clear all
close all
clc
%% Setup

% add path to the code that does all the work:
addpath(genpath('/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimuli/xScripts/MotionEnergyMatchingGallant/Helpers-MotionEnergy'));

% visualizations of the feature matrix and sample wavelets pop up for each
% video?
do_followup_viz = false;

% Directory with these frame-stacks for each video:
stacksDir = 'xSimpit/Input Arrays_2ImpossMotion_cropped';

% Directory to save the output for each video in:
saveDir = 'Data_2ImpossMotion_cropped/all';
if ~exist(saveDir, 'dir'); mkdir(saveDir); end

%% Get the list of inputs
% 1 array per video
vidList = dir(fullfile(stacksDir));
vidList = {vidList.name}';
vidList(strncmp('.', vidList, 1)) = [];
vidList

%% Get the input parameters

gparams_init = preprocWavelets_grid_GetMetaParams(1);

% Process with Gabor wavelets
% The numerical argument here specifies a set of parameters for the
% preprocWavelets_grid function, that dictate the locations, spatial
% frequencies, phases, and orientations of Gabors to use. 2 specifies Gabor
% wavelets with three different temporal frequencies (0, 2, and 4 hz),
% suitable for computing motion energy in movies.

% LT: tried doing this with argument = 1 (comments indicate this is closer
% for modeling fMRI data, though their fMRI parameters/concerns differ from
% ours (they want TR-by-TR data while subjects watch a minutes-long video);

% Only difference is it uses fewer channels/wavelets, so you get fewer
% outputs. For now, just stick with 2 (which was the default in the demo)

% [] 3/2017: moved this outside of the loop since it takes a long time
% (actually, it's quite quick but may as well cut down on time if possible)
% and won't change depending upon the stimulus.

%% Loop through the videos
for v = 1:length(vidList)
   
    clc
    sn1 = strsplit(vidList{v}, '.');
    sn2 = strsplit(sn1{1}, '_');
%     disp(sprintf('Starting on video %d of %d: %s...', v, length(vidList), [sn2{1} '_' sn2{2}]));
    disp(sprintf('Starting on video %d of %d: %s...', v, length(vidList), sn2{1}));
    fname = fullfile(stacksDir, vidList{v});

    if ~exist(fullfile(saveDir, [sn1{1} '_MEoutput.mat']))
        
        %% Load images
        try
            d = load(fname);
        catch err_msg
            fprintf('You may need to modify the "fname" variable in ComputeMotionEnergy.m\nto point to a .mat file with movie frames in it!\n')
            throw(err_msg);
        end
        
        % % Check the size:
    %     size(d.array)
        %
        % % look at a frame (choose a later one so not just all white):
    %     imshow(d.array(:, :, :, 5))
        
    %     for i = 1:170
    %     subplot(13,14,i); imshow(d.array(:, :, :, i))
    %     end
        % close
        
        % the field d.array is an array that is (361 x 361 x 3 x 12); (X x Y x Color x
        % Images).  The images are stored as 8-bit integer arrays (no decimal
        % places, with pixel values from 0-255). These should be converted to
        % floating point decimals from 0-1:
        S  = single(d.array)/255;
        
        %% Preprocessing
        % Convert to grayscale (luminance only)
        % The argument 1 here indicates a pre-specified set of parameters to feed
        % to the preprocColorSpace function to convert from RGB images to
        % luminance values by converting from RGB to L*A*B colorspace and then
        % keeping only the luminance channel. (You could also use matlab's
        % rgb2gray.m function, but this is more principled.) Inspect cparams to see
        % what those parameters are.
        cparams = preprocColorSpace_GetMetaParams(1);
        [S_lum, cparams] = preprocColorSpace(S, cparams);
        
        % % look at the same frame:
    %     imshow(S_lum(:, :, 5)) % hm, definitely looks a bit blocky but we won't worry about that for now.
        % close
        
        %% Gabor wavelet processing
        % The actual motion energy-calculating step.
        
        % Process with Gabor wavelets
        % The numerical argument here specifies a set of parameters for the
        % preprocWavelets_grid function, that dictate the locations, spatial
        % frequencies, phases, and orientations of Gabors to use. 2 specifies Gabor
        % wavelets with three different temporal frequencies (0, 2, and 4 hz),
        % suitable for computing motion energy in movies.
        % gparams = preprocWavelets_grid_GetMetaParams(2);
        % [] 3/2017: moved this outside of the loop since it takes a long time
        % (I think) and won't change depending upon the stimulus.
        
        % % LT: tried doing this with argument = 1 (comments indicate this is closer
        % % for modeling fMRI data, though their fMRI parameters/concerns differ from
        % % ours (they want TR-by-TR data while subjects watch a minutes-long video);
        % gparams = preprocWavelets_grid_GetMetaParams(1);
        % % Only difference is it uses fewer channels/wavelets, so you get fewer
        % outputs. For now, just stick with 2 (which was the default in the demo)
        [S_gab, gparams] = preprocWavelets_grid(S_lum, gparams_init);
        
        %% Optional additions
        % Compute log of each channel to scale down very large values
        nlparams = preprocNonLinearOut_GetMetaParams(1);
        [S_nl, nlparams] = preprocNonLinearOut(S_gab, nlparams);
        
        % Downsample data to the sampling rate of your fMRI data (the TR)
        % LT: this shouldn't be necessary for my project, so I've commented it out.
        % dsparams = preprocDownsample_GetMetaParams(1); % for TR=1; use (2) for TR=2
        % [S_ds, dsparams] = preprocDownsample(S_nl, dsparams);
        
        % Z-score each channel
        nrmparams = preprocNormalize_GetMetaParams(1);
        % [S_fin, nrmparams] = preprocNormalize(S_ds, nrmparams);
        [S_fin, nrmparams] = preprocNormalize(S_nl, nrmparams); % LT changed this bc skipping the downsampling step
        
        %% Save output
    %     save(fullfile(saveDir, [sn2{1} '_' sn2{2} '_MEoutput.mat']), 'S_fin', 'nrmparams');
        save(fullfile(saveDir, [sn1{1} '_MEoutput.mat']), 'S_fin', 'nrmparams');
        disp(['Saved output for ' sn1{1} '!']);
    end
end

disp('Finished making and saving outputs for all videos!')
%% Display output

% I'm making a separate script to display the feature matrices and save
% those figures -- this is just a quick visualization and won't save anything.

if do_followup_viz
    % Simple feature size
    disp('Final matrix size (images x features):')
    disp(size(S_fin));
    % show image of feature matrix
    imagesc(S_fin);
    % ylabel('Time (TR)')
    ylabel('Time (Frame)') % LT changed: time is only measured in TR's if
    % you downsampled it above (which I decided wasn't the right thing for
    % our data)
    xlabel('Gabor wavelet feature')
    caxis([-3,3]);
    colorbar();
    title('Un-Reduced Feature Matrix')
    % Create examples of Gabor wavelets used for each feature
    gparams.show_or_preprocess = 0;
    [gab, pp] = preprocWavelets_grid(zeros(96,96), gparams);
    fig = figure();
    % 150th Gabor wavelet (corresponds to 150th column on x axis in plot above)
    subplot(121);
    imagesc(gab(:,:,1,150));
    caxis([-1,1])
    axis image off
    title('150th Gabor filter')
    % 1220th Gabor wavelet
    subplot(122);
    imagesc(gab(:,:,1,1219));
    caxis([-1,1])
    axis image off
    title('1221th Gabor filter')
    colormap(gray)
end
























































