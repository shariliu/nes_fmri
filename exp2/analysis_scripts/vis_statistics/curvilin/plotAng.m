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
inclThetas = [2 3 5 6];
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
rect4 = dataRect/max(dataRect);
makeCurveRectPlots(rect4,[],4,'ang4',[0 1]);

% convert the 13 conditon index for plotting to the four condition index
% for the analysis
idx411 = [11 12 10 3 1 2 7 8 9 5 4];

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

makeCurveRectPlots(dataRect12/max(dataRect12),[],12,'ang12',[]);


