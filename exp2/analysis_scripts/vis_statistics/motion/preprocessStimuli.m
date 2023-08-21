% Demo to extract frames from a input video, resize them, and save frames out, in prep for 
% Gallant motion energy model scripts
% Illustrates the use of the VideoReader and VideoWriter classes.
% A Mathworks demo (different than mine) is located here http://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 22;


% First get the folder that it lives in.
% folder = fileparts(which('rhinos.avi')); % Determine where demo folder is (works with all versions).
% folder = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimuli/8SimpleTest/final'; %which stim folder to process
folder = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xSimpitStims/2ImpossMotion/preproc_cropped'; %which stim folder to process
stimNames = dir(fullfile(folder)); %get filenames for each stim

% Set outdir
% outDir = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimuli/8SimpleTest/stillframes'; % folder to process
outDir = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xSimpitStims/2ImpossMotion/stillframes_cropped'; % folder to process
mkdir(outDir);


%% loop through stims in stimNames
for stim = 1:length(stimNames)

    % Pick one of the two demo movies shipped with the Image Processing Toolbox.
    % Comment out the other one.
    inputFullFileName = [stimNames(stim).folder,'/', stimNames(stim).name];
    % inputFullFileName = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimuli/2ImpossMotion/preproc/a7.mov';
    % inputFullFileName = fullfile(folder, 'rhinos.avi');
    % movieFullFileName = fullfile(folder, 'traffic.avi');
    % Check to see that it exists + make sure it is actually a movie file.

    if ~exist(inputFullFileName, 'file')
        strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', inputFullFileName);
        response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
        if strcmpi(response, 'OK - choose a new movie.')
            [baseFileName, folderName, FilterIndex] = uigetfile('*.avi');
            if ~isequal(baseFileName, 0)
                inputFullFileName = fullfile(folderName, baseFileName);
            else
                return;
            end
        else
            return;
        end   
    end

    if ~contains(inputFullFileName,'.mp4') == 0 %make sure its a movie file

        % Open up the VideoReader for reading an input video file.
        inputVideoReaderObject = VideoReader(inputFullFileName)
        % Determine how many frames there are.
        numberOfFrames = inputVideoReaderObject.NumberOfFrames;
        inputVideoRows = inputVideoReaderObject.Height
        inputVideoColumns = inputVideoReaderObject.Width

        % Create a VideoWriter object to write the video out to a new, different file.
        outputFullFileName = fullfile(pwd, 'NewRhinos.avi');
%         outputFullFileName = [stimNames(stim).folder,'/', stimNames(stim).name,'_new.mov'];
        outputVideoWriterObject = VideoWriter(outputFullFileName);
        
        %change video settings and save the new video
%         outputVideoWriterObject.FrameRate = 60.3333;
        
        
        open(outputVideoWriterObject);
        % Specify the output video size.
        shrinkFactor = 4; % Shrink by a factor of 4 in both directions.
        outputVideoRows = 512; %round(inputVideoRows / shrinkFactor)
        outputVideoColumns = 512; %round(inputVideoColumns / shrinkFactor)
        

%         mkdir('stimuli/video3');
        videoOutDir = sprintf('%s/%s',outDir,stimNames(stim).name);
        mkdir(videoOutDir);
        
        
        
        
        

        numberOfFramesWritten = 0;
        % Prepare a figure to show the images in the upper half of the screen.
        % figure;
        % 	screenSize = get(0, 'ScreenSize');
        % Enlarge figure to full screen.
        % set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

        % Loop through the movie, writing all frames out.
        for frame = 1 : numberOfFrames
            % Extract the frame from the movie structure.
            thisInputFrame = read(inputVideoReaderObject, frame);

            % Resize the frame.
            outputFrame = imresize(thisInputFrame, [outputVideoRows, outputVideoColumns]);
%             outputFrameStruct(frame,:,:,:) = imresize(thisInputFrame, [outputVideoRows, outputVideoColumns]);
            
            % Save the frame.
            imwrite(outputFrame, sprintf('%s/%02d.jpg',videoOutDir,frame));
%             writeVideo(outputVideoWriterObject,outputFrame);
        end
        
    end
end






