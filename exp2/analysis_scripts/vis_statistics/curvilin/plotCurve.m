clear all
close all
clc

load('data/crHands4.mat');
load('data/crFeet4.mat');
load('data/crColl4.mat');
load('data/crShapes4.mat');
load('data/crVehicle4.mat');
load('data/crStill4.mat');
load('data/crEgo4.mat');
load('data/crPan4.mat');
load('data/crFront4.mat');
load('data/crSide4.mat');
load('data/crExp4.mat');
load('data/crBase4.mat');
load('data/crAgent4.mat');

thetaList=[0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];
SFlist=[1 2 4 8];
bendList = [0.001 0.005 0.01 0.05 0.1];
inclThetas = [1 4];
curvSplit = {1:2 3 4:5};

b1r = [];
b2r = [];
o1r = [];
o2r = [];
o3r = [];
f1r = [];
f2r = [];
f3r = [];
s1r = [];
s2r = [];
s3r = [];
ar = [];
br = [];

for i = 1:length(curvSplit)
    
    b1c{i} = [];
    b2c{i} = [];
    o1c{i} = [];
    o2c{i} = [];
    o3c{i} = [];
    f1c{i} = [];
    f2c{i} = [];
    f3c{i} = [];
    s1c{i} = [];
    s2c{i} = [];
    s3c{i} = [];
    ac{i} = [];
    bc{i} = [];
    
end

for i = 1:length(inclThetas) 
    
    iTheta = inclThetas(i);
    
    for iSF = 1:length(SFlist)
        
        b1r = [b1r feetRect(iTheta,iSF) ];
        b2r = [b2r handRect(iTheta,iSF) ];
        o1r = [o1r collRect(iTheta,iSF) ];
        o2r = [o2r shapeRect(iTheta,iSF) ];
        o3r = [o3r vehicleVidRect(iTheta,iSF) ];
        s1r = [s1r egoRect(iTheta,iSF) ];
        s2r = [s2r panRect(iTheta,iSF) ];
        s3r = [s3r stillRect(iTheta,iSF) ];
        f1r = [f1r expRect(iTheta,iSF) ];
        f2r = [f2r frontRect(iTheta,iSF) ];
        f3r = [f3r sideRect(iTheta,iSF) ];
        ar = [ar agentRect(iTheta,iSF) ];
        br = [br baseRect(iTheta,iSF) ];
        
        for j = 1:length(curvSplit)
            
            for b = 1:length(curvSplit{j})
                
                iBend = curvSplit{j}(b);
                
                b1c{j}  = [b1c{j} feetCurve(iTheta,iSF,iBend) ];
                b2c{j}  = [b2c{j} handCurve(iTheta,iSF,iBend) ];
                o1c{j}  = [o1c{j} collCurve(iTheta,iSF,iBend) ];
                o2c{j}  = [o2c{j} shapeCurve(iTheta,iSF,iBend) ];
                o3c{j}  = [o3c{j} vehicleVidCurve(iTheta,iSF,iBend) ];
                s1c{j}  = [s1c{j} egoCurve(iTheta,iSF,iBend) ];
                s2c{j}  = [s2c{j} panCurve(iTheta,iSF,iBend) ];
                s3c{j}  = [s3c{j} stillCurve(iTheta,iSF,iBend) ];
                f1c{j}  = [f1c{j} expCurve(iTheta,iSF,iBend) ];
                f2c{j}  = [f2c{j} frontCurve(iTheta,iSF,iBend) ];
                f3c{j}  = [f3c{j} sideCurve(iTheta,iSF,iBend) ];
                ac{j} = [ac{j} agentCurv(iTheta,iSF,iBend) ];
                bc{j} = [bc{j} baseCurv(iTheta,iSF,iBend) ];
            
            end
        end
    end
end


bodRect = mean([b1r b2r],'omitnan');
bsemRect = std([b1r b2r],'omitnan')/sum(~isnan([b1r b2r]));

objRect = mean([o1r o2r o3r],'omitnan');
osemRect = std([o1r o2r o3r],'omitnan')/sum(~isnan([o1r o2r o3r]));

scnRect = mean([s1r s2r s3r],'omitnan');
ssemRect = std([s1r s2r s3r],'omitnan')/sum(~isnan([s1r s2r s3r]));

facRect = mean([f1r f2r f3r],'omitnan');
fsemRect = std([f1r f2r f3r],'omitnan')/sum(~isnan([f1r f2r f3r]));

baseRect = mean([br br br ar],'omitnan');
basesemRect = std([br br br ar],'omitnan')/sum(~isnan([br br br ar]));

dataRect = [facRect bodRect objRect scnRect baseRect];
r4 = (dataRect-min(dataRect))/(max(dataRect)-min(dataRect));
% semRect = [fsemRect bsemRect osemRect ssemRect basesemRect];
rect4 = dataRect/max(dataRect);
makeCurveRectPlots(rect4,[],4,'rect4',[0 1]);

% convert the 13 conditon index for plotting to the four condition index
% for the analysis
idx411 = [11 12 10 3 1 2 7 8 9 5 4];

%%% curvilinear 4 condition
for iCurve = 1:length(curvSplit)
    
    bodCurve = mean([b1c{iCurve} b2c{iCurve}],'omitnan');
    bsemCurve = std([b1c{iCurve} b2c{iCurve}],'omitnan')/sum(~isnan([b1c{iCurve} b2c{iCurve}]));
    
    objCurve = mean([o1c{iCurve} o2c{iCurve} o3c{iCurve}],'omitnan');
    osemCurve = std([o1c{iCurve} o2c{iCurve} o3c{iCurve}],'omitnan')/sum(~isnan([o1c{iCurve} o2c{iCurve} o3c{iCurve}]));
    
    scnCurve = mean([s1c{iCurve} s2c{iCurve} s3c{iCurve}],'omitnan');
    ssemCurve = std([s1c{iCurve} s2c{iCurve} s3c{iCurve}],'omitnan')/sum(~isnan([s1c{iCurve} s2c{iCurve} s3c{iCurve}]));
    
    facCurve = mean([f1c{iCurve} f2c{iCurve} f3c{iCurve}],'omitnan');
    fsemCurve = std([f1c{iCurve} f2c{iCurve} f3c{iCurve}],'omitnan')/sum(~isnan([f1c{iCurve} f2c{iCurve} f3c{iCurve}]));
    
    baseCurve = mean([bc{iCurve} bc{iCurve} bc{iCurve} ac{iCurve}],'omitnan');
    basesemCurve = std([bc{iCurve} bc{iCurve} bc{iCurve} ac{iCurve}],'omitnan')/sum(~isnan([bc{iCurve} bc{iCurve} bc{iCurve} ac{iCurve}]));
    
    dataCurve = [facCurve bodCurve objCurve scnCurve baseCurve];
    semCurve = [fsemCurve bsemCurve osemCurve ssemCurve basesemCurve];
    c4 = (dataCurve-min(dataCurve))/(max(dataCurve)-min(dataCurve));
    
    curv4{iCurve} = dataCurve/max(dataCurve);
    
    makeCurveRectPlots(curv4{iCurve},[],4,['curve4-' num2str(iCurve)],[0 1]);
    clear('bodCurve','bsemCurve','objCurve','osemCurve','scnCurve','ssemCurve',...
        'faceCurve','fsemCurve','baseCurve','basesemCurve','dataCurve','c4','semCurve');

    %%% curvilinear 12 condition
    
    face1c = mean(f1c{iCurve},'omitnan');
    face2c = mean(f2c{iCurve},'omitnan');
    face3c = mean(f3c{iCurve},'omitnan');
    body1c = mean(b1c{iCurve},'omitnan');
    body2c = mean(b2c{iCurve},'omitnan');
    agtc = mean(ac{iCurve},'omitnan');
    obj1c = mean(o1c{iCurve},'omitnan');
    obj2c = mean(o2c{iCurve},'omitnan');
    obj3c = mean(o3c{iCurve},'omitnan');
    scn1c = mean(s1c{iCurve},'omitnan');
    scn2c = mean(s2c{iCurve},'omitnan');
    scn3c = mean(s3c{iCurve},'omitnan');
    bslc = mean(bc{iCurve},'omitnan');
    
    f1semc = std(f1c{iCurve},'omitnan')/sum(~isnan(f1c{iCurve}));
    f2semc = std(f2c{iCurve},'omitnan')/sum(~isnan(f2c{iCurve}));
    f3semc = std(f3c{iCurve},'omitnan')/sum(~isnan(f3c{iCurve}));
    b1semc = std(b1c{iCurve},'omitnan')/sum(~isnan(b1c{iCurve}));
    b2semc = std(b2c{iCurve},'omitnan')/sum(~isnan(b2c{iCurve}));
    asemc = std(ac{iCurve},'omitnan')/sum(~isnan(ac{iCurve}));
    o1semc = std(o1c{iCurve},'omitnan')/sum(~isnan(o1c{iCurve}));
    o2semc = std(o2c{iCurve},'omitnan')/sum(~isnan(o2c{iCurve}));
    o3semc = std(o3c{iCurve},'omitnan')/sum(~isnan(o3c{iCurve}));
    s1semc = std(s1c{iCurve},'omitnan')/sum(~isnan(s1c{iCurve}));
    s2semc = std(s2c{iCurve},'omitnan')/sum(~isnan(s2c{iCurve}));
    s3semc = std(s3c{iCurve},'omitnan')/sum(~isnan(s3c{iCurve}));
    bslsemc = std(bc{iCurve},'omitnan')/sum(~isnan(bc{iCurve}));
    
    dataCurve12 = [face1c face2c face3c body1c body2c agtc obj1c obj2c obj3c scn1c scn2c scn3c bslc];
    semCurve12 = [f1semc f2semc f3semc b1semc b2semc asemc o1semc o2semc o3semc s1semc s2semc s3semc bslsemc];
    
    makeCurveRectPlots(dataCurve12/max(dataCurve12),[],12,['curve12-' num2str(iCurve)],[]);
    
    d11 = dataCurve12(idx411);
    c11 = (d11-min(d11))/(max(d11)-min(d11));
    curv11{iCurve} = d11/max(d11);
    clear('face1c','face2c','face3c','body1c','body2c','agtc','obj1c',...
        'obj2c','obj3c','scn1c','scn2c','scn3c','bslc','f1semc','f2semc',...
        'f3semc','b1semc','b2semc','asemc','o1semc','o2semc','o3semc',...
        's1semc','s2semc','s3semc','bslsemc','dataCurve12','semCurve12','d11','c11');
end

face1r = mean(f1r,'omitnan');
face2r = mean(f2r,'omitnan');
face3r = mean(f3r,'omitnan');
body1r = mean(b1r,'omitnan');
body2r = mean(b2r,'omitnan');
agtr = mean(ar,'omitnan');
obj1r = mean(o1r,'omitnan');
obj2r = mean(o2r,'omitnan');
obj3r = mean(o3r,'omitnan');
scn1r = mean(s1r,'omitnan');
scn2r = mean(s2r,'omitnan');
scn3r = mean(s3r,'omitnan');
bslr = mean(br,'omitnan');

f1semr = std(f1r,'omitnan')/sum(~isnan(f1r));
f2semr = std(f2r,'omitnan')/sum(~isnan(f2r));
f3semr = std(f3r,'omitnan')/sum(~isnan(f3r));
b1semr = std(b1r,'omitnan')/sum(~isnan(b1r));
b2semr = std(b2r,'omitnan')/sum(~isnan(b2r));
asemr = std(ar,'omitnan')/sum(~isnan(ar));
o1semr = std(o1r,'omitnan')/sum(~isnan(o1r));
o2semr = std(o2r,'omitnan')/sum(~isnan(o2r));
o3semr = std(o3r,'omitnan')/sum(~isnan(o3r));
s1semr = std(s1r,'omitnan')/sum(~isnan(s1r));
s2semr = std(s2r,'omitnan')/sum(~isnan(s2r));
s3semr = std(s3r,'omitnan')/sum(~isnan(s3r));
bslsemr = std(br,'omitnan')/sum(~isnan(bslr));

dataRect12 = [face1r face2r face3r body1r body2r agtr obj1r obj2r obj3r scn1r scn2r scn3r bslr];
semRect12 = [f1semr f2semr f3semr b1semr b2semr asemr o1semr o2semr o3semr s1semr s2semr s3semr bslsemr];
    
d11 = dataRect12(idx411);
r11 = (d11-min(d11))/(max(d11)-min(d11));
rect11 = d11/max(d11);

makeCurveRectPlots(dataRect12/max(dataRect12),[],12,'rect12',[]);

save('curvRect.mat','rect11','curv11','rect4','curv4');
