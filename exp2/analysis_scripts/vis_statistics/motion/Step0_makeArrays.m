% Leyla Tarhan
% 3/2017
% MATLAB R2015b

% Step 1 in analyzing motion energy for videos using Gallant lab's code:
% take all frames from a given video (previously split) and make them into
% a 4-d array (x by y by RGB by frames).

% KIRSTEN NOTES -- VIDEOS CURRENTLY DIFF SIZES; 

%% Clean up
clear all
close all
clc

%% Set up paths

% folder with one directory per vid (each directory contains all frames):
framesDir_s1 = '../videos/';
% framesDir_s1 = 'C:\Users\Leyla\Dropbox (KonkLab)\Stimuli-ActionVideos\1 - fMRI\ActionMap\Final 60 actions - frames\Set1';
% framesDir_s2 = 'C:\Users\Leyla\Dropbox (KonkLab)\Stimuli-ActionVideos\1 - fMRI\ActionMap\Final 60 actions - frames\Set2';
% N.B.: these don't all have just 75 frames, though the stimuli shown in
% the experiment did! So, make sure that numFrames is correctly specified
% below.

% folder to save each of the arrays in, once they're constructed:
arraysDir = 'video_arrays/';
if ~exist(arraysDir, 'dir'); mkdir(arraysDir); end

% frame size (in pixels):
frameW = 401;
frameH = 401;

% # frames:
numFrames = 119; %149 for main?? 
%% Loop through the sets and make all videos into arrays


framesDir = framesDir_s1;
clc
%----------------------------------------------------------------------
% Get a list of the videos
%----------------------------------------------------------------------

vidList = dir(fullfile(framesDir));
vidList = {vidList.name}';
vidList(contains(vidList,'.mp4')) = []
% get rid of any null entries:
vidList(strncmp('.', vidList, 1)) = [];

% check it out:
vidList

%----------------------------------------------------------------------
%% Make one array per video
%----------------------------------------------------------------------
% N.B.: could also make one super-array as long as you know where to make
% the cuts (in this case, probably should save a separate .mat file with
% those cut locations).

for v = 1:length(vidList)


    % get the # of frames:
    framesList = dir(fullfile(framesDir, vidList{v}, '*.*'));
    framesList = {framesList.name}';
    framesList(strncmp('.', framesList, 1)) = [];

    disp(length(framesList))

    %reformat so frames are in the correct order
    addpath natsortfiles/
    framesList = natsortfiles(framesList);

    if length(framesList) >= numFrames

        % initialize an array for this video (width x height x 3 (RGB) x #
        % frames):
        array = zeros(frameW, frameH, 3, numFrames, 'uint8');
        % have to initialize type as uint8, otherwise will come out all splotchy

        % loop through the frames and add them to the array:
        for f = 1:numFrames
            % if it's the first frame, quickly check that the frame width/height were right:
            frame = imread(fullfile(framesDir, vidList{v}, framesList{f}));
            if f == 1
                assert(all(size(frame, 1) == frameW, size(frame, 2) == frameH), 'Frame is not the size specified at the beginning of the script!')
            end
            array(:, :, :, f) = frame;
        end
        % save the array:
        save(fullfile(arraysDir, [vidList{v}, '_framesArray.mat']), 'array');
        disp(['Finished making and saving frames array for ', vidList{v} '.']);



    end
end
















