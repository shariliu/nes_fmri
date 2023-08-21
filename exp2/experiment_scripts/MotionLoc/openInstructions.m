function openInstructions(win,screenrect)


%% setup
centerscreen = [screenrect(3) screenrect(4)]/2;   	% coordinates of screen center (pixels)

%% format text
Screen('TextFont',win, 'Calabri');
Screen('TextSize',win, 40 );
Screen('TextStyle', win, 1);

text1 = 'Hello! In this experiment, you will see a red dot at the bottom of your screen, set beneath a field of moving white dots. Please look at the red dot at all times. \n \n Your task: Press the left button on the box in your hand whenever the color of the red dot dims. \n \n Please press a button to move on to a sample display.';  
text2 = 'While you are doing your task, please pay attention to the direction in which the white dots are moving. But do not look at them: keep looking at the red dot at all times. \n \n  This scan will last 5-6 minutes.  \n \n Please press a button to begin.';

%Read first part of instructions
DrawFormattedText(win, text1,'center','center',[50,0,230],40);
Screen('Flip',win);
pause(1)

KbQueueWait()

%% load instructions page
imname = 'keydotsScreenshot.jpg';
img=imread(imname, 'JPG');
textureIndex=Screen('MakeTexture', win, double(img));
Screen('DrawTexture', win, textureIndex,[],screenrect);

Screen('Flip',win);
pause(3)

%Read second part of instructions
DrawFormattedText(win, text2, 'center','center',[50,0,230],40);
Screen('Flip',win);
pause(1)

KbQueueWait()

Screen('Flip',win);
pause(1)
