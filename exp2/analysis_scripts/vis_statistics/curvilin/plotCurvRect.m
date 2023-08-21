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

b1r = reshape(feetRect,   [1 numel(feetRect)])   ;
b2r = reshape(handRect,   [1 numel(handRect)])   ;
o1r = reshape(collRect,   [1 numel(collRect)])   ;
o2r = reshape(shapeRect,  [1 numel(shapeRect)])  ;
o3r = reshape(vehicleVidRect,[1 numel(vehicleVidRect)]);
s1r = reshape(egoRect,    [1 numel(egoRect)])    ;
s2r = reshape(panRect,    [1 numel(panRect)])    ;
s3r = reshape(stillRect,  [1 numel(stillRect)])  ;
f1r = reshape(expRect,    [1 numel(expRect)])    ;
f2r = reshape(frontRect,  [1 numel(frontRect)])  ;
f3r = reshape(sideRect,   [1 numel(sideRect)])   ;
ar  = reshape(agentRect,  [1 numel(agentRect)])  ;
br  = reshape(baseRect,   [1 numel(baseRect)])   ;

b1c = reshape(feetCurve,   [1 numel(feetCurve)]);
b2c = reshape(handCurve,   [1 numel(handCurve)]);
o1c = reshape(collCurve,   [1 numel(collCurve)]);
o2c = reshape(shapeCurve,  [1 numel(shapeCurve)]);
o3c = reshape(vehicleVidCurve,[1 numel(vehicleVidCurve)]);
s1c = reshape(egoCurve,    [1 numel(egoCurve)]);
s2c = reshape(panCurve,    [1 numel(panCurve)]);
s3c = reshape(stillCurve,  [1 numel(stillCurve)]);
f1c = reshape(expCurve,    [1 numel(expCurve)]);
f2c = reshape(frontCurve,  [1 numel(frontCurve)]);
f3c = reshape(sideCurve,   [1 numel(sideCurve)]);
ac  = reshape(agentCurv,   [1 numel(agentCurv)]);
bc  = reshape(baseCurv,    [1 numel(baseCurv)]);

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

% dataRect5 = [facRect bodRect objRect scnRect baseRect];
% r4 = (dataRect5-min(dataRect5))/(max(dataRect5)-min(dataRect5));
% semRect5 = [fsemRect bsemRect osemRect ssemRect basesemRect];
% rect4 = dataRect5/max(dataRect5);
% makeCurveRectPlots(dataRect5,semRect5,4,'rect5',[]);

%%% curvilinear 4 condition

bodCurve = mean([b1c b2c],'omitnan');
bsemCurve = std([b1c b2c],'omitnan')/sum(~isnan([b1c b2c]));

objCurve = mean([o1c o2c o3c],'omitnan');
osemCurve = std([o1c o2c o3c],'omitnan')/sum(~isnan([o1c o2c o3c]));

scnCurve = mean([s1c s2c s3c],'omitnan');
ssemCurve = std([s1c s2c s3c],'omitnan')/sum(~isnan([s1c s2c s3c]));

facCurve = mean([f1c f2c f3c],'omitnan');
fsemCurve = std([f1c f2c f3c],'omitnan')/sum(~isnan([f1c f2c f3c]));

baseCurve = mean([bc bc bc ac],'omitnan');
basesemCurve = std([bc bc bc ac],'omitnan')/sum(~isnan([bc bc bc ac]));

dataCurve5 = [facCurve bodCurve objCurve scnCurve baseCurve];
semCurve5 = [fsemCurve bsemCurve osemCurve ssemCurve basesemCurve];
c4 = (dataCurve5-min(dataCurve5))/(max(dataCurve5)-min(dataCurve5));

curv4 = dataCurve5/max(dataCurve5);

makeCurveRectPlots(curv4,[],4,'curve5',[0 1]);

% convert the 13 conditon index for plotting to the four condition index
% for the analysis
idx411 = [11 12 10 3 1 2 7 8 9 5 4];

% %%% curvilinear 12 condition
% 
% face1c = mean(f1c,'omitnan');
% face2c = mean(f2c,'omitnan');
% face3c = mean(f3c,'omitnan');
% body1c = mean(b1c,'omitnan');
% body2c = mean(b2c,'omitnan');
% agtc   = mean(ac,'omitnan');
% obj1c  = mean(o1c,'omitnan');
% obj2c  = mean(o2c,'omitnan');
% obj3c  = mean(o3c,'omitnan');
% scn1c  = mean(s1c,'omitnan');
% scn2c  = mean(s2c,'omitnan');
% scn3c  = mean(s3c,'omitnan');
% bslc   = mean(bc,'omitnan');
% 
% f1semc = std(f1c,'omitnan')/sum(~isnan(f1c));
% f2semc = std(f2c,'omitnan')/sum(~isnan(f2c));
% f3semc = std(f3c,'omitnan')/sum(~isnan(f3c));
% b1semc = std(b1c,'omitnan')/sum(~isnan(b1c));
% b2semc = std(b2c,'omitnan')/sum(~isnan(b2c));
% asemc = std(ac,'omitnan')/sum(~isnan(ac));
% o1semc = std(o1c,'omitnan')/sum(~isnan(o1c));
% o2semc = std(o2c,'omitnan')/sum(~isnan(o2c));
% o3semc = std(o3c,'omitnan')/sum(~isnan(o3c));
% s1semc = std(s1c,'omitnan')/sum(~isnan(s1c));
% s2semc = std(s2c,'omitnan')/sum(~isnan(s2c));
% s3semc = std(s3c,'omitnan')/sum(~isnan(s3c));
% bslsemc = std(bc,'omitnan')/sum(~isnan(bc));
% 
% dataCurve13 = [face1c face2c face3c body1c body2c agtc obj1c obj2c obj3c scn1c scn2c scn3c bslc];
% semCurve13 = [f1semc f2semc f3semc b1semc b2semc asemc o1semc o2semc o3semc s1semc s2semc s3semc bslsemc];
% 
% makeCurveRectPlots(dataCurve13,semCurve13,12,'curve13',[]);
% 
% d11 = dataCurve13(idx411);
% c11 = (d11-min(d11))/(max(d11)-min(d11));
% curv11 = d11/max(d11);
% 
% face1r = mean(f1r,'omitnan');
% face2r = mean(f2r,'omitnan');
% face3r = mean(f3r,'omitnan');
% body1r = mean(b1r,'omitnan');
% body2r = mean(b2r,'omitnan');
% agtr = mean(ar,'omitnan');
% obj1r = mean(o1r,'omitnan');
% obj2r = mean(o2r,'omitnan');
% obj3r = mean(o3r,'omitnan');
% scn1r = mean(s1r,'omitnan');
% scn2r = mean(s2r,'omitnan');
% scn3r = mean(s3r,'omitnan');
% bslr = mean(br,'omitnan');
% 
% f1semr = std(f1r,'omitnan')/sum(~isnan(f1r));
% f2semr = std(f2r,'omitnan')/sum(~isnan(f2r));
% f3semr = std(f3r,'omitnan')/sum(~isnan(f3r));
% b1semr = std(b1r,'omitnan')/sum(~isnan(b1r));
% b2semr = std(b2r,'omitnan')/sum(~isnan(b2r));
% asemr = std(ar,'omitnan')/sum(~isnan(ar));
% o1semr = std(o1r,'omitnan')/sum(~isnan(o1r));
% o2semr = std(o2r,'omitnan')/sum(~isnan(o2r));
% o3semr = std(o3r,'omitnan')/sum(~isnan(o3r));
% s1semr = std(s1r,'omitnan')/sum(~isnan(s1r));
% s2semr = std(s2r,'omitnan')/sum(~isnan(s2r));
% s3semr = std(s3r,'omitnan')/sum(~isnan(s3r));
% bslsemr = std(br,'omitnan')/sum(~isnan(bslr));
% 
% dataRect13 = [face1r face2r face3r body1r body2r agtr obj1r obj2r obj3r scn1r scn2r scn3r bslr];
% semRect13 = [f1semr f2semr f3semr b1semr b2semr asemr o1semr o2semr o3semr s1semr s2semr s3semr bslsemr];
% 
% d11 = dataRect13(idx411);
% r11 = (d11-min(d11))/(max(d11)-min(d11));
% rect11 = d11/max(d11);
% 
% makeCurveRectPlots(dataRect13,semRect13,12,'rect13',[]);
% 
% save('curvRect.mat','dataRect13','dataCurve13','dataRect5','dataCurve5');
