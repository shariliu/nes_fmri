% load rect data from folders, average across images within a video, and
% compare the two sets (ttest)

clear all; close all;


% choose dirs to compare
stimSetDir1 = '1EgoMotion';
stimSetDir2 = '2ImpossMotion';
homedir = cd;


% load dir 1
eval(['cd ' num2str(stimSetDir1)]);
files = dir('*.mat');
numStimSets = size(files,1);
for dirInd = 1:numStimSets
    load(files(dirInd).name)
    rect(1,dirInd) = mean(rectData(size(rectData,1),:)); % mean(rectData(dirInd,:));
    checker{dirInd,1} = files(dirInd).name;
    checker{dirInd,2} = mean(rectData(dirInd,:));
    checker{dirInd,3} = dirInd;
end
eval(['cd ' num2str(homedir)]);


% load dir 2
eval(['cd ' num2str(stimSetDir2)]);
files = dir('*.mat');
numStimSets = size(files,1);
for dirInd = 1:numStimSets
    load(files(dirInd).name)
    rect(2,dirInd) = mean(rectData(size(rectData,1),:)); %mean(rectData(dirInd,:));
    checker{dirInd,4} = files(dirInd).name;
    checker{dirInd,5} = mean(rectData(dirInd,:));
    checker{dirInd,6} = dirInd;
end
eval(['cd ' num2str(homedir)]);




%stats
mean(rect')

[h,p,ci,stats] = ttest2(rect(1,:),rect(2,:),'Vartype','unequal');

figure
bar(mean(rect')); hold on;
plot(rect,'ok')
xlim([0,3])
xticklabels({'Egomotion','Deconstructed'})
ylabel('Rectilinearity')