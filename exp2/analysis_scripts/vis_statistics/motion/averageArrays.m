clear all
close all
tic

% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_simpleTest/horizontal'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_simpleTest/vertical'; %which stim folder to process
% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_egoMotion/lowest52scores'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_egoStatic'; %which stim folder to process
% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_motionSenseTest/vertical'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_motionSenseTest/horizontal'; %which stim folder to process
% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_egoMotion/all'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_impossMotion/all'; %which stim folder to process
% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_egoMotion_per'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_impossMotion_per'; %which stim folder to process
% folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_egoMotion_per/lowest45scores'; %which stim folder to process
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_impossMotion_per/lowest45scores'; %which stim folder to process
folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_1EgoMotion/matched69'; %which stim folder to process
folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xStimulusCreation/xScripts/MotionEnergyMatchingGallant/Data_2ImpossMotion/matched69'; %which stim folder to process


stimNames1 = dir(fullfile(folder1)); %get filenames for each stim
stimNames2 = dir(fullfile(folder2)); %get filenames for each stim

count = 1; %counts across both sets
figure; figcount = 1; %counts separately for each set

for stim = 1:length(stimNames1)
    if ~contains(stimNames1(stim).name,'.mat') == 0 %make sure its a mat file
        if exist(sprintf('Data_1EgoMotion/matched69/%s',stimNames1(stim).name))
            load(sprintf('Data_1EgoMotion/matched69/%s',stimNames1(stim).name))
    %         mtx(:,count) = mean(S_fin,1)'; %collapse across time to get mean ME for each filter
            
            S_fin = S_fin(1:89,:);
            mtx(:,count) = reshape(S_fin,1,size(S_fin,1)*size(S_fin,2))';
            stimSetKey(count) = 1;

            %for overall ME 
            MEoverall1(figcount) = mean(mean(S_fin(50:150)));

            S_fins(count,:,:) = S_fin;

            if figcount < 10
                subplot(2,5,figcount); 
                imagesc(reshape(S_fins(count,:,:),size(S_fins,2),size(S_fins,3)),[-5 5]); title('fast')
            end

            MEfast(figcount) = mean(mean(S_fins(count,:,:)));

            figcount = figcount+1;
            count = count + 1;
        end
    end
end

% load('cutoffs.mat')

figure; figcount = 1; %reset count for this set
% worstimagecount = 1; %for looping through only bad images

for stim = 1:length(stimNames2)
    if ~contains(stimNames2(stim).name,'.mat') == 0 %make sure its a mat file
        if exist(sprintf('Data_2ImpossMotion/matched69/%s',stimNames2(stim).name))
    %         if worstPerformIndx(worstimagecount) == 1
                load(sprintf('Data_2ImpossMotion/matched69/%s',stimNames2(stim).name))
    %             mtx(:,count) = mean(S_fin,1)'; %collapse across time to get mean ME for each filter
                
                S_fin = S_fin(1:89,:);
                mtx(:,count) = reshape(S_fin,1,size(S_fin,1)*size(S_fin,2))';
                stimSetKey(count) = 0;

                %for overall ME 
                MEoverall2(figcount) = mean(mean(S_fin(50:150)));

                S_fins(count,:,:) = S_fin;

                if figcount < 10
                    subplot(2,5,figcount);
                    imagesc(reshape(S_fins(count,:,:),size(S_fins,2),size(S_fins,3)),[-5 5]);title('slow')
                end

                MEslow(figcount) = mean(mean(S_fins(count,:,:)));

                figcount = figcount+1;
                count = count + 1;
    %         end
    %         worstimagecount = worstimagecount + 1;
        end
    end
end
% 
% %correlate ME from each stim with every other stim
% stimSimMatrix = corr(mtx);
% stimSimMatrix(stimSimMatrix==1) = NaN;
% within1 = nanmean(nanmean(stimSimMatrix(1:length(stimNames1),1:length(stimNames1))));
% within2 = nanmean(nanmean(stimSimMatrix(length(stimNames1)+1:end,length(stimNames1)+1:end)));
% between = nanmean(nanmean(stimSimMatrix(1:length(stimNames1),length(stimNames1)+1:end)));
% % figure; bar([within1 between within2]); title('within versus betweeen correlations')
% 
% %visualize
% figure;
% imagesc(stimSimMatrix) %[-.15 .15]
% 

% get overall motion energy from each set
overalMEmeans = [mean(MEoverall1) mean(MEoverall2)];
overalMEerrs = [std(MEoverall1)/sqrt(length(MEoverall1)) std(MEoverall2)/sqrt(length(MEoverall2))];
figure; bar(overalMEmeans); hold on; errorbar(overalMEmeans,overalMEerrs,'.k'); title('overall ME')
[h,p,CI,stats] = ttest2(MEoverall1,MEoverall2);




%% svm - try to distinguish sets

N = 500; %number of leave-one-out iterations to try
Xraw = mtx'; %data with predictors(i.e.,filters) as columns, observations(i.e., each image) as rows
Yraw = stimSetKey'; %data with class (i.e., egoMotion v imposs) as rows

%choose random number from each set to create pairs for the
%leave-one-pair-out procedure
%ensures one from each set, always
% sample1 = datasample(1:length(MEoverall1),N);
% sample2 = datasample(1:length(MEoverall2),N)+length(MEoverall1); %adjusted by lenght of other sample for indexing purposes below
% answers = [ones(N,1);zeros(N,1)];


%true random (each can be from either set)
sample1 = datasample(1:(length(MEoverall1)+length(MEoverall2)),N);
sample2 = datasample(1:(length(MEoverall1)+length(MEoverall2)),N);
for i = 1:length(sample1)
    if sample1(i) == 1 || sample2(i) == 1
        if sample1(i) == sample2(i) 
            sample1(i) = sample1(i)+1; 
        end
    else
        if sample1(i) == sample2(i) 
            sample1(i) = sample1(i)-1 ;
        end
    end
end
answers = [sample1<50,sample2<50];


% %for getting rankings from every image, for matching
% sample1 = [1:length(MEoverall1),ones(1,(length(MEoverall2)-length(MEoverall1)))];
% sample2 = (1:length(MEoverall2))+length(MEoverall1); %adjusted by lenght of other sample for indexing purposes below
% answers = [ones(N,1);zeros(N,1)];


%leave one out procedure
for i = 1:N 
    disp(['working on iteration ', int2str(i), ' of ', int2str(N)]);
    
    %remove left out observations from training data
    if sample1(i) < sample2(i)
        X = Xraw; 
        X(sample1(i),:) = []; 
        X((sample2(i)-1),:) = [];  %adjusted by 1 after removing first observation
        Y = Yraw; 
        Y(sample1(i),:) = [];
        Y((sample2(i)-1),:) = []; %adjusted by 1 after removing first observation
    else
        X = Xraw; 
        X(sample2(i),:) = []; 
        X((sample1(i)-1),:) = [];  %adjusted by 1 after removing first observation
        Y = Yraw; 
        Y(sample2(i),:) = [];
        Y((sample1(i)-1),:) = []; %adjusted by 1 after removing first observation
    end
    
    %make data array to predict ORIGINAL
    newX = Xraw([sample1(i) sample2(i)],:);

    %train classifier
    SVMModel = fitcsvm(X,Y,'KernelFunction','linear',...
        'Standardize',true,'ClassNames',[1,0]);
    
    %predict left out data
    [label,score] = predict(SVMModel,newX);
    
    %save labels and scores
    results_labels(i,:) = label';
    results_scores(i,:) = [score(1) score(2)];
    results_stimIDs(i,:) = [sample1(i) sample2(i)];
end


%compute accuracy across iterations
accuracy = sum(sum(results_labels == reshape(answers,N,2)))/(N*2);
disp(['SVM accuracy = ' sprintf('%0.2f',accuracy)])

%perm test of classification signficance
perms = 1000;
for i = 1:perms
    idx = randperm(N*2);
    xperm = reshape(results_labels(idx),N,2);
    perm_accuracy(i) = sum(sum(xperm == reshape(answers,N,2)))/(N*2);
end
p_svm = sum(perm_accuracy>accuracy)/perms;

%make svm p value two tailed
if p_svm > .5
    p_svm = (1 - p_svm)*2;
else
    p_svm = p_svm*2;
end

disp(['svm p = ' sprintf('%0.2f',p_svm)])
disp(['overall me p = ' sprintf('%0.2f',p)])
figure; hist(perm_accuracy); hold on; xline(accuracy,':r','LineWidth',2)




% 
% %% svm - try to distinguish sets
% %% USE THIS VERSION TO MATCH SETS: THIS VERSION GETS SCORE FOR EACH INDIVIDUAL VIDEO
% 
% N = size(mtx,2); %set num of leave-one-out iterations to be equal to num of videos
% Xraw = mtx'; %data with predictors(i.e.,filters) as columns, observations(i.e., each image) as rows
% Yraw = stimSetKey'; %data with class (i.e., egoMotion v imposs) as rows
% 
% % %choose random number from set for the leave-one-pair-out procedure
% % sample1 = datasample(1:length(MEoverall1),N);
% % sample2 = datasample(1:length(MEoverall2),N)+length(MEoverall1); %adjusted by lenght of other sample for indexing purposes below
% % 
% % %correct labels variable
% % answers = [ones(N,1);zeros(N,1)];
% 
% %leave one out procedure
% for i = 1:N 
%     disp(['working on iteration ', int2str(i), ' of ', int2str(N)]);
%     
%     %remove left out observations from training data
%     X = Xraw; 
%     X(i,:) = []; 
% %     X((sample2(i)-1),:) = [];  %adjusted by 1 after removing first observation
%     Y = Yraw; 
%     Y(i,:) = [];
% %     Y((sample2(i)-1),:) = []; %adjusted by 1 after removing first observation
%     
%     %make data array to predict
%     newX = Xraw(i,:);
%     
%     %train classifier
%     SVMModel = fitcsvm(X,Y,'KernelFunction','linear',...
%         'Standardize',true,'ClassNames',[1,0]);
%     
%     %predict left out data
%     [label,score] = predict(SVMModel,newX);
%     
%     %save labels and scores
%     results_labels(i,:) = label';
%     results_scores(i,:) = [score(1)];
% end
% 
% 
% %compute accuracy across iterations
% accuracy = sum(results_labels == reshape(answers,N,1))/(N);
% disp(['SVM accuracy = ' sprintf('%0.2f',accuracy)])
% 
% 
toc
disp(toc)