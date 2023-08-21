function screenInfo = openExperiment(monWidth, viewDist, curScreen)
% screenInfo = openExperiment(monWidth, viewDist, curScreen)
% Arguments:
%	monWidth ... viewing width of monitor (cm)
%	viewDist     ... distance from the center of the subject's eyes to
%	the monitor (cm)
%   curScreen         ... screen number for experiment
%                         default is 0.
% Sets the random number generator, opens the screen, gets the refresh
% rate, determines the center and ppd, and stops the update process 
% Used by both my dot code and my touch code.
% MKMK July 2006

v = bitor(2^16, Screen('Preference','ConserveVRAM'));
Screen('Preference','ConserveVRAM', v);
Screen('Preference', 'SkipSyncTests', 1)
Screen('Preference', 'VisualDebugLevel', 0);

% 1. SEED RANDOM NUMBER GENERATOR
screenInfo.rseed = [];
rseed = sum(100*clock);
rand('state',rseed);
%screenInfo.rseed = sum(100*clock);
%rand('state',screenInfo.rseed);

%Must specify monWidth and viewDist according to experiment
monWidth = 35.6;
viewDist = 131;
%viewDist = 50;

% ---------------
% open the screen
% ---------------

% make sure we are using openGL
AssertOpenGL;
curScreen = max(Screen('Screens'));
HideCursor

% Set the background to the background value.
screenInfo.bckgnd = 0;

%% Run in experiment mode or demo mode
%exp
[screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow', curScreen, screenInfo.bckgnd,[],32, 2);
%demo
%[screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow', curScreen, screenInfo.bckgnd,[0 0 800 800],32, 2);

%%
screenInfo.dontclear = 0; % 1 gives incremental drawing (does not clear buffer after flip)

%get the refresh rate of the screen
% need to change this if using crt, would be nice to have an if
% statement...
%screenInfo.monRefresh = Screen(curScreen,'FrameRate');
% 
 spf = Screen('GetFlipInterval', screenInfo.curWindow)      % seconds per frame
 screenInfo.monRefresh = 1/spf;    % frames per second
screenInfo.frameDur = 1000/screenInfo.monRefresh;

screenInfo.center = [screenInfo.screenRect(3) screenInfo.screenRect(4)]/2;   	% coordinates of screen center (pixels)

% determine pixels per degree
% (pix/screen) * ... (screen/rad) * ... rad/deg
screenInfo.ppd = pi * screenInfo.screenRect(3) / atan(monWidth/viewDist/2) / 360;    % pixels per degree

% if reward system is hooked up, rewardOn = 1, otherwise rewardOn = 0;
screenInfo.rewardOn = 0;

% get reward system ready
screenInfo.daq=DaqDeviceIndex;


%%Keys
keys = [79 80 81 82 30 31 32 33];
[id,name] = GetKeyboardIndices;% get a list of all devices connected
id = id(1);
keyList=zeros(1,256);
keyList(keys)=1;
KbQueueCreate(id,keyList);
KbQueueFlush();
KbQueueStart();
pressed = 0;