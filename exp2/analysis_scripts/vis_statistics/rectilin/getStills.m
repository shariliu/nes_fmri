
% Function to measure rectilinearity - the prominence of right angles - in
% an image.
%
% imgArray: 2D or 3D image array, e.g. as obtained by imread
%
% Note: filters have 400x400 pixel resolution. If images are particularly
% high- or low-resolution, it might be necessary to change this. When
% comparing rectilinearity across images, a fixed size should be used.



% In this case, I'm analyzing rectilinearity in movies. Thus I will
% first pull out still frames from each movie; analyze rectilinearity of
% each individual image. Rectilinearity for each movie will therefore be
% the average rect of all images in that movie

clear all


% choose stimulus directory to analyze
% there is one directory per movie, full of still images for that movie
% stimSetDir = '~/Documents/Projects/MIT/infantSceneMotionfNIRS/xPresentationScripts/experiment/Stills/dynStat/2final_stills';
stimSetDir = '~/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xSimpitStims/2ImpossMotion/stillframes/matched68';
homedir = cd;
eval(['cd ' num2str(stimSetDir)]);
[zz1 zz2] = unix('ls -d */ | tee dirs.txt');
fileIO = fopen('dirs.txt');
stimDirs = textscan(fileIO, '%s');
numStimSets = size(stimDirs{1},1);
for dirInd = 1:numStimSets
    stimDirs{1}{dirInd} = stimDirs{1}{dirInd}(1:end-1);
end





%% MAIN LOOP

for movie = 1:68  
    disp(movie)
    
    %cd to mov directory full of still image frames for that movie
    eval(['cd ', stimSetDir, '/',stimDirs{1}{movie}])
%     stillDir = cd;
    
    %get list of filenames in dir
    stillImageNames = dir('*.jpg'); 
    
    
    copyfile(stillImageNames(45).name,sprintf('../../stillMiddleFrames68/%s.jpg',stimDirs{1}{movie}))
    
    
    
    
%     
%     
%     %image loop
%     for still = 1:length(stillImageNames)
%         
%         disp(still)
%         
%         
%         
%         
%         
%         %load still image
%         imgArray = imread(stillImageNames(still).name);
%         
%         
%         
%         % run getImageRectilinearity 
%         % recti is key variable
%         
%         eval(['cd ' homedir]); %god forgive me for the way I code
%         rectData(movie,still) = getImageRectilinearity_modified(imgArray);
%         
%         eval(['cd ', stimSetDir, '/',stimDirs{1}{movie}])
%         
%         %save
% %         rectData(movie,still) = recti;
%     end 
%     
%     eval(['cd ' homedir]); %god forgive me for the way I code
%     eval(['save ',stimDirs{1}{movie},'.mat rectData']);
%     eval(['cd ', stimSetDir])
end