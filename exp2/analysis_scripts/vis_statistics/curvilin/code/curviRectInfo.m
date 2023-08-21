function [curv,rect] = curviRectInfo(picDir,imgNames)

thetaList=[0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];
SFlist=[1 2 4 8];
bendList = [0.001 0.005 0.01 0.05 0.1];
curv = NaN(length(thetaList),length(SFlist),length(bendList));
rect = NaN(length(thetaList),length(SFlist));
for iImg = 1:length(imgNames)
    % read image
    img = imread([picDir filesep imgNames{iImg}]);
    for iTheta = 1:length(thetaList)
        t = thetaList(iTheta);
        for iSF = 1:length(SFlist)
            s = SFlist(iSF);
            for iBend = 1:length(bendList)
                bend = bendList(iBend);
                curv(iTheta,iSF,iBend)=applyCurveFilters(img,s,t,0,bend);
            end
            rect(iTheta,iSF)=applyAngleFilters_AllRotations(img,s,t,0);
        end
    end
end
