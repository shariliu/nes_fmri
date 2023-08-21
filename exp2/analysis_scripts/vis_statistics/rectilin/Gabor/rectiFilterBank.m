function rectiArray = rectiFilterBank

% RECTIFILTERBANK generates a custum rectlinear feature band.
% It creates an 4x16 array, whose elements are 401x401 matries; 
% each matrix being a 2-D rectilinear filter.

%%% Create rectilinear filters

% Angle of filter
theta = pi/2;

% Parameters controlling size of filter in pixels.
mA=4;
xLength=200;
yLength=200;

% Wavelengths (corresponds to 5, 9, 15, 27 pixels/cycle)
waveLengths = 1./[1 2 4 8];

% Rotations in x-y plane
rotVals = (22.5:22.5:360)*pi/180;

u = length(waveLengths);
v = length(rotVals);

% Create u*v filters each being an m*n matrix
rectiArray = cell(u,v);

plotResults = 0;

for i = 1:u
    for j = 1:v
        rectiArray{i,j} = AngleFilter(waveLengths(i),rotVals(j),pi/2,mA,xLength,yLength);
    end
end


%%% Show rectlinear filters

if plotResults
    % Show magnitudes of filters:
    figure('NumberTitle','Off','Name','Magnitudes of filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j);        
            imshow(abs(rectiArray{i,j}),[]);
        end
    end
    
    % Show real parts of filters:
    figure('NumberTitle','Off','Name','Real parts of filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j);        
            imshow(real(rectiArray{i,j}),[]);
        end
    end
end
