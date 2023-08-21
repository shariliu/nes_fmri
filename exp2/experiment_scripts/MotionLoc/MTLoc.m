function [] = MTLoc(parName,runNum)

if ~exist('parName')
    parName = input('What is your study ID? ', 's');
end
% To undo demo mode, uncomment line 45 and comment out line 47 of openExperiment
% dotroutine for keypresses
% cases used:
% fixon - turn on fixation
% wait - waits for a key press.
% targson - turns on targets
% dotson - turns on dots
% fixoff - turns off fixation 
% correct - rewards correct trial
% incorrect - does not reward
% endtrial - keeps track of errorcount, saves data at certain intervals,
% and determines if there was an abort
% pause - stops the experiment and waits for user input (resume or end)

clearvars -except parName runNum
close all;
done = 0;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set up experiment
%%%%%%%%%%%%%%%%%%%%%%%%%

%% Participant info
if nargin < 1
    runNum = 1;
elseif nargin == 1
    runNum = 1;
end

%% setup
%try
    %% Localizer Info
    initPause = 10; %seconds of pause after trigger (12s)
    blockLength = 12 - 0.20; %seconds subtract a little time for more precise start-times
    flipNumber = 22; %number of total blocks (half coherent, half random motion)

    cohRandIndex = ones(flipNumber,1); 
    cohRandIndex(1 : 2 : flipNumber) = 2; %alternate between coherent and random motion
    
    %trials start at 0s, change every "blockLength" seconds
    trialtimes = [0:round(blockLength):500]';
  
    %% Screen Info
    screenInfo = openExperiment;
    
    % initialize dotInfo structure if no file present
    if ~exist('KeydotInfoMatrix.mat','file')
        createDotInfo(1);
    end
    
    %% Display Instructions
    openInstructions(screenInfo.curWindow,screenInfo.screenRect)

    %% Load Parameters
    %[keyIsDown, secs, keyCode] = KbCheck;
    abort = 0;
    load keyDotInfoMatrix
    
    % Fixation is green while we wait for trigger, then red during the experiment
    dotInfo.fixColor = [0 255 0];
    targets = makeDotTargets(screenInfo, dotInfo); %Make fixation dot
    showTargets(screenInfo, targets, 1); %Put up fixation dot
    dotInfo.maxDotTime2 = blockLength; 
    save keyDotInfoMatrix dotInfo

    %% Wait for trigger
    disp('Waiting for first trigger.\n');

    while 1
        [~, ~, keyCode] = KbCheck(-1);
        if  keyCode(KbName('=+')) || keyCode(KbName('+'))
            dotInfo.fixColor = [155 0 0];
            targets = makeDotTargets(screenInfo, dotInfo); %Make fixation dot
            showTargets(screenInfo, targets, 1); %Put up fixation dot
            break
        end
    end

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%% run experiment
    %%%%%%%%%%%%%%%%%%%%%%%%%

    %% Start Experiment, including a 10 second pause
    tic
    pause(initPause) %Fixation of 10 s at the beginning of localizer.
    experimentstart = GetSecs; %counts from beginning of fixation
    count = 0; % keep track of trial number
    nextstep = 'fixon'; % start with fixation
    
    blockCount=0;
    %% Start localizer blocks
    while ~done
        switch nextstep
            case 'fixon'
		
                abort = 0;
                count = count + 1;
                % determine dot direction, coherence, etc. for this run
                load keyDotInfoMatrix
				
				while((GetSecs-experimentstart)) < trialtimes(count), end
				trialstart = GetSecs;
                blockCount = blockCount+1
				trialData(count).trialstart = trialstart;

                errorcnt = [zeros(size(dotInfo.dirSet))]; % need this for error correction mode
                keys = [dotInfo.keyLeft dotInfo.keyRight];
		
                % set up trial
                dotInfo.coh = dotInfo.cohSet(cohRandIndex(count))*1000;
                save keyDotInfoMatrix dotInfo
                trialData(count).ariel = dotInfo.coh;
                trialData(count).count = count;
                trialData(count).cormode = 0;
                trialData(count).coh = dotInfo.coh;
                
                if any(errorcnt == 3)
                    Screen('FillOval', screenInfo.curWindow, [100 100 100], [10 12 40 42]);
                    Screen('DrawingFinished',screenInfo.curWindow, screenInfo.dontclear);
                    Screen('Flip', screenInfo.curWindow, 0, screenInfo.dontclear);
                    Screen('DrawingFinished',screenInfo.curWindow, screenInfo.dontclear);
                    Screen('Flip', screenInfo.curWindow, 0, screenInfo.dontclear);
                end

                % keep track of trials that are due to correction mode
                if any(errorcnt > 2)
                    trialData(count).cormode = find(errorcnt>2);
                end
                
                % initialize targets
                targets = makeDotTargets(screenInfo, dotInfo);
                % figure out which target will be the correct one
                trialData(count).corTar = find(dotInfo.dirSet==dotInfo.dir);
                trialData(count).dotDir = dotInfo.dir;
                % goodtrial is zero, unless makes it to end of trial
                trialData(count).goodtrial = 0;
                % if good trial, this will be filled in with a rxtime
                if dotInfo.trialtype == 2
                    trialData(count).rxtime = nan;
                end
                
                % make sure that the wrong targets(s) is (are) colored if suppose to be
                if ~isempty(dotInfo.wrongColor)
                    colIndex = zeros(1,length(dotInfo.tarDiam) + 1);
                    colIndex(1) = 1; % don't want fixation color changed
                    colIndex(trialData(count).corTar + 1) = 1; % don't want correct target color changed
                    % change the incorrect targets color
                    targets = newTargets(screenInfo, targets, [find(colIndex==0)], [], [], [], [dotInfo.wrongColor]);
                end
                
                starttime = GetSecs; %closer to trial start	

                if dotInfo.minTime2(1) == 0
                    nextstep = 'targson';
                else
                    nextstep = 'dotson';
                    % if minTime2 1 is greater than minTime2 2 then we
                    % are doing dots before targets; waiting is fix to dots on
                    if dotInfo.minTime2(1) > dotInfo.minTime2(2)
                        afterwait = 'dotson';
                        waittime = dotInfo.minTime2(2);
                    %elseif dotInfo.minTime2(2) >= dotInfo.minTime2(1)
                        % if minTime2 2 is greater than minTime2 1 then
                        % we need to put up the targets before we do
                        % the dots. waiting is fix to targson
                        %afterwait = 'targson';
                        %waittime = dotInfo.minTime2(1);
                    end
                end

            case 'wait'
                nextstep = afterwait;

            case 'targson'
                % draw
                %%showTargets(screenInfo, targets, [1:length(targets.d)]);
                % if time from fixation until targets on (minTime2(2))
                % is greater than time from fixation until dots on,
                % then we show dots first, and then targets, otherwise
                % targets and then dots.
                if dotInfo.minTime2(1) > dotInfo.minTime2(2)
                    % dots have already been on, use delay from dots off to fix
                    % on measured from time of dots off (already set
                    % starttime at dotson), for reaction time, targets
                    % should always be up before dots - assume user is
                    % smart enough to figure that out.
                    %Caroline added: minTime2(4) to dotInfo and set it equal to 0
					afterwait = 'endtrial';
                    waittime = dotInfo.minTime2(4);
                elseif dotInfo.minTime2(2) >= dotInfo.minTime2(1)
                    afterwait = 'dotson';
                    % wait however much longer to turn on dots as time from
                    % dots on minus targets on. (fix to dots on - fix
                    % to targets on)
                    starttime = GetSecs;
                    waittime = dotInfo.minTime2(2) - dotInfo.minTime2(1);
                end
                nextstep = 'wait';

            case 'dotson'
                dotstime=GetSecs;
                
                % dots on; fixation cross now red
                dotInfo.fixColor = [255 0 0];
                targets = makeDotTargets(screenInfo, dotInfo); %Make fixation dot
                showTargets(screenInfo, targets, 1); %Put up fixation dot
                save keyDotInfoMatrix dotInfo

                Metatimes=GetSecs-trialstart;
                [frames, rseed, start_time, end_time, response, response_time] = dotsX(screenInfo, dotInfo, targets,blockLength,trialstart,count);
                trialData(count).rseed = rseed;
                tcnt = trialData(count).corTar;
                
                if ~isnan(response{3})
                    %disp('isnan')
                    % if pressed a key during dots, and it was fixed
                    % duration, incorrect.
                    if dotInfo.trialtype(1) == 1
                        nextstep = 'incorrect';
                        % for rt, need to figure out if response was
                        % appropriate. Right now we are assuming a
                        % right/left paradigm. Have to figure out what to
                        % do if not.
                    else
                        % reaction time
                        % since we made it far enough to see if touching
                        % correct target, its a good trial
                        trialData(count).goodtrial = 1;
                        trialData(count).rxtime = response_time - start_time;
                        if response{3} == tcnt
                            nextstep = 'correct';
                        else
                            nextstep = 'incorrect';
                        end
                    end
                elseif dotInfo.trialtype(1) == 2
                    % if reaction time and didn't hit a key during the dots, then an error
                    nextstep = 'incorrect';
                elseif dotInfo.trialtype(1) == 1
                    % fixed duration - hasn't pressed yet
                    nextstep = 'wait';
                    % once dots have finished, all timing should be with
                    % reference to when the dots went off. (starttime is always
                    % the time we judge the wait time with, and end_time is
                    % when the dots went off)
                    starttime = end_time;
                    % if time from fixation until targets on (minTime2(1))
                    % is greater than time from fixation until dots on,
                    % then we show dots first, and then targets, otherwise
                    % targets and then dots.
                    if dotInfo.minTime2(1) > dotInfo.minTime2(2)
                        afterwait = 'targson';
                        % all wait times are from dots off. If screwed up and
                        % have targets coming on after fixation goes off, just
                        % turn targets on at same time as fixation goes off,
                        % and use time from dots off to fixation for waittime
                        % otherwise have to figure out time to wait as time
                        % from fix to targets on minus fix to dots off (minTime2 2 + 3)
                        % if fix to targets > (fix to dots + dot dur + dots off to fix off) use fix off for both
                        if dotInfo.minTime2(1) > sum(dotInfo.minTime2(2:4))
                            waittime = dotInfo.minTime2(4);
                        else
                            waittime = dotInfo.minTime2(1) - sum(dotInfo.minTime2(2:3));
                        end
                    elseif dotInfo.minTime2(2) >= dotInfo.minTime2(1)
                        %Caroline edited script here to make fixation point stay on during fixed duration task.  Change afterwait = fixoff to afterwait = fixon and the following case.
                        afterwait = 'fixoff';
                        % can just use dots off to fix off for waittime here
                        %Insert waittime of 0 for fixed duration task, CER.
                        waittime = 0;
                    end
                end
                
            case 'fixoff'
                drawtime = GetSecs;

                hold = 1;
                while hold
                    [keyIsDown,secs,keyCode] = KbCheck;
                    % loop ends when time delay is met
                    %%Caroline changed dotInfo.minTime2(5) here to "2" could be anything.  Basically, dotInfo.minTime2 doesn't have enough variables in it (only three, when 5 are called for)
                    if GetSecs - drawtime >= 1
                        %disp('waited long enough')
                        response{1} = 0;
                        hold = 0;
                    end
                    if keyIsDown,
                        if keyCode(dotInfo.keySpace)
                            %disp('abort');
                            abort = 1;
                        end
                        if any(keyCode(keys)),
                            response{1} = find(keyCode(keys));
                            hold = 0;
                        end;
                    end;
                end
                trialData(count).goodtrial = 1;
                if response{1} == tcnt
                    nextstep = 'correct';
                else
                    nextstep = 'incorrect';
                end


            case 'correct'
                screenInfo.rewardOn
                if screenInfo.rewardOn == 1
                    err=DaqAOut(screenInfo.daq(1),0,1); % D/A 0
                    WaitSecs(0.5)
                    err=DaqAOut(screenInfo.daq(1),0,0); % D/A 1
                end
                WaitSecs(0.5)
                trialData(count).correct = 1;
                nextstep = 'endtrial';

            case 'incorrect'
                
                WaitSecs(0.5)
                trialData(count).correct = 0;
                nextstep = 'endtrial';

            case 'endtrial'
                if dotInfo.auto(3) == 3
                    % if was an error where the monkey chose the wrong
                    % target (rather than broke fixation), then keep count of error
                    if trialData(count).correct == 0 && trialData(count).goodtrial
                        % if error, add 1 to the counter for that direction
                        errorcnt(trialData(count).corTar) = errorcnt(trialData(count).corTar) + 1;
                    elseif trialData(count).correct == 1
                        errorcnt(trialData(count).corTar) = 0;
                    end

                    if any(errorcnt > 2)
                        find(errorcnt < 3);
                        errorcnt(find(errorcnt < 3)) = 0;
                    end
                end

        trialend = GetSecs;
		trialData(count).trialdur = trialend-trialstart;
		trialData(count).trialstart = trialstart-experimentstart;
        
     
		if count == flipNumber %maximum trials
					%pause(16) %Last pause
                    done = 1;
					runtime=trialend-experimentstart;
					%trialData.runtime=runtime;
                end
                if abort == 1
                    nextstep = 'pause';
                else
                    nextstep = 'fixon';
                end

            case 'pause'

                WaitSecs(0.5);
                % Wait to see what user does. 
                %secs = KbWait();
                [keyIsDown, secs, keyCode] = KbCheck;
                if keyCode(dotInfo.keyEscape)
                    done = 1;
                    abort = 0;
                    % continue experiment
                elseif any(keyCode(dotInfo.keyReturn))
                    [keyIsDown, secs, keyCode] = KbCheck;
                    abort = 0;
                    nextstep = 'fixon';
                end
        end
    

    end
	
    closeExperiment;
% catch
%     disp('caught')
%     lasterr
%     closeExperiment;
% end


%% Save data
filename = ['Results/' parName num2str(runNum)];
% for i = 1:size(run,2)
%     data = [run(:,i), true(:,i), press(:,i), rxt(:,i) keepBlock(:,i) timeStart(:,i)];
%     dlmwrite(filename,data,'-append','delimiter','\t')
% end
% trialData.count 
% trialData.trialstart 
% trialData.coh

data = [trialData.count; trialData.trialstart; trialData.coh]';
dlmwrite(filename,data,'-append','delimiter','\t')

%% Print some timing information to screen
toc
trialRunTimes=[trialData.trialdur] %outputs the block durations
trialStartTimes=[trialData.trialstart] %outputs the block start times
count %how many blocks?
