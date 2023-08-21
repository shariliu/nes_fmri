function targets = makeDotTargets(screenInfo, dotInfo)
% makes targets that are coordinated with dot position or fixation. Used in
% keyDots, but not necessary for using dots in experiments in general. For
% a little more info, see createDotInfo

%Caroline says: if you only want one target (i.e. the fixation) to appear during your task, make targets.show = 1
if dotInfo.auto(1) == 1 % 1 set manually, take directly from tarXY
    xpos = dotInfo.tarXY(:,1);
    ypos = dotInfo.tarXY(:,2);
else
    if dotInfo.auto(1) == 2 % fixation is center
        xpos = [dotInfo.fixXY(:,1); dotInfo.tarXY(:,1)];
        ypos = [dotInfo.fixXY(:,2); dotInfo.tarXY(:,2)];
    elseif dotInfo.auto(1) == 3 % aperture is center
        %Caroline changed here:
        %xpos = [dotInfo.apXYD(:,1); dotInfo.tarXY(:,1)];
        %ypos = [dotInfo.apXYD(:,2); dotInfo.tarXY(:,2)];
        xpos = [dotInfo.apXYD(:,1); dotInfo.tarXY(1)];
        ypos = [dotInfo.apXYD(:,2); dotInfo.tarXY(2)];
    end    
    distance = sqrt((xpos(2) - xpos(1)).^2 + (ypos(2) - ypos(1)).^2);
    ypos = (distance.*sind(dotInfo.dirSet) + ypos(1))';
    xpos = (distance.*cosd(dotInfo.dirSet) + xpos(1))';
end

% add fixation to targets
xpos = [dotInfo.fixXY(:,1); xpos]';
ypos = [dotInfo.fixXY(:,2); ypos]';
diam = [dotInfo.fixDiam dotInfo.tarDiam];

% for now assume all targets the same color
colors = repmat(dotInfo.tarColor,length(dotInfo.tarDiam),1);
colors = [dotInfo.fixColor; colors];

% initialize targets
numTargets = length(xpos);

if isempty(numTargets)
	numTargets = 8;
end

targets.rects = zeros(numTargets, 4);
targets.colors = zeros(numTargets, 3);
targets.x = zeros(numTargets, 1);
targets.y = zeros(numTargets, 1);
targets.d = zeros(numTargets, 1);

% make new targets
targets = newTargets(screenInfo, targets, 1:length(xpos), xpos, ypos, diam, colors);

% put the targets into correct coordinates for checking to see if a touch is within the boundaries of the targets.
% translate the coordinates, move the center and invert y, and change from visual degrees to pixels
xy = [xpos' ypos'];
temp = ones(size(xy));
temp = [screenInfo.center(1).*temp(:,1) screenInfo.center(2).*temp(:,2)];
tar_xy = [temp(:,1)+xy(:,1)*screenInfo.ppd/10 temp(:,2)-xy(:,2)*screenInfo.ppd/10];
targets.select = [tar_xy(:,1) tar_xy(:,2) diam'/2*screenInfo.ppd/10];
clear temp tar_xy

% these are different depending on whether using keypresses or touchscreen (mouse)
if isfield(dotInfo,'keyLeft') && ~isempty(dotInfo.keyLeft)
    targs = dotInfo.minTime(1);
    dots = dotInfo.minTime(2);
else
    targs = dotInfo.minTime(2);
    dots = dotInfo.minTime(3);
end

if dotInfo.trialtype(2)==2
    %if dotInfo.minTime(2) > dotInfo.minTime(3)
    % subject not required to hold fixation, so fixation not on during dots
    % if dots come on before targets, don't show targets
    if targs > dots
        targets.show = [];
    else
        targets.show = 2:size(targets.rects,1);
    end
else
    %if dotInfo.minTime(2) > dotInfo.minTime(3)
    % fixation is on as long as dots are on
    % if dots come on before targets, don't show targets, only fixation
    if targs > dots
        targets.show = 1;
    else
        targets.show = 1;
    end
end