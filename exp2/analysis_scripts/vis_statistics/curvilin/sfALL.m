% clear all
% close all
% clc
% tic
% frameDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/vidFrames';
% imgDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/pics';
% 
% handsVids = dir([frameDir filesep 'bod_h_*.jpg']); handsVids = {handsVids.name};
% [handVidsLow,handVidsHigh] = sfInfo(frameDir,handsVids);
% handPics = dir([imgDir filesep 'bod_h_*.jpg']); handPics = {handPics.name};
% [handPicsLow,handPicsHigh] = sfInfo(imgDir,handPics);
% 
% t(1) = toc;
% save('sfInfo.mat');
% 
% feetVids = dir([frameDir filesep 'bod_f_*.jpg']); feetVids = {feetVids.name};
% [feetVidsLow,feetVidsHigh] = sfInfo(frameDir,feetVids);
% feetPics = dir([imgDir filesep 'bod_f_*.jpg']); feetPics = {feetPics.name};
% [feetPicsLow,feetPicsHigh] = sfInfo(imgDir,feetPics);
% 
% t(2) = toc;
% save('sfInfo.mat');
% 
% agentVids = dir([frameDir filesep 'agt*.jpg']); agentVids = {agentVids.name};
% [agentVidsLow,agentVidsHigh] = sfInfo(frameDir,agentVids);
% agentPics = dir([imgDir filesep 'agt*.jpg']); agentPics = {agentPics.name};
% [agentPicsLow,agentPicsHigh] = sfInfo(imgDir,agentPics);
% 
% t(3) = toc;
% save('sfInfo.mat');
% 
% baseVids = dir([frameDir filesep 'bsl*.jpg']); baseVids = {baseVids.name};
% [baseVidsLow,baseVidsHigh] = sfInfo(frameDir,baseVids);
% basePics = dir([imgDir filesep 'bsl*.jpg']); basePics = {basePics.name};
% [basePicsLow,basePicsHigh] = sfInfo(imgDir,basePics);
% 
% t(4) = toc;
% save('sfInfo.mat');
% 
% frontVids = dir([frameDir filesep 'fac_f_*.jpg']); frontVids = {frontVids.name};
% [frontVidsLow,frontVidsHigh] = sfInfo(frameDir,frontVids);
% frontPics = dir([imgDir filesep 'fac_f_*.jpg']); frontPics = {frontPics.name};
% [frontPicsLow,frontPicsHigh] = sfInfo(imgDir,frontPics);
% 
% t(5) = toc;
% save('sfInfo.mat');
% 
% sideVids = dir([frameDir filesep 'fac_s_*.jpg']); sideVids = {sideVids.name};
% [sideVidsLow,sideVidsHigh] = sfInfo(frameDir,sideVids);
% sidePics = dir([imgDir filesep 'fac_s_*.jpg']); sidePics = {sidePics.name};
% [sidePicsLow,sidePicsHigh] = sfInfo(imgDir,sidePics);
% 
% t(6) = toc;
% save('sfInfo.mat');
% 
% expVids = dir([frameDir filesep 'fac_x_*.jpg']); expVids = {expVids.name};
% [expVidsLow,expVidsHigh] = sfInfo(frameDir,expVids);
% expPics = dir([imgDir filesep 'fac_x_*.jpg']); expPics = {expPics.name};
% [expPicsLow,expPicsHigh] = sfInfo(imgDir,expPics);
% 
% t(7) = toc;
% save('sfInfo.mat');
% 
% collVids = dir([frameDir filesep 'obj_c_*.jpg']); collVids = {collVids.name};
% [collVidsLow,collVidsHigh] = sfInfo(frameDir,collVids);
% collPics = dir([imgDir filesep 'obj_c_*.jpg']); collPics = {collPics.name};
% [collPicsLow,collPicsHigh] = sfInfo(imgDir,collPics);
% 
% t(8) = toc;
% save('sfInfo.mat');
% 
% shapeVids = dir([frameDir filesep 'obj_s_*.jpg']); shapeVids = {shapeVids.name};
% [shapeVidsLow,shapeVidsHigh] = sfInfo(frameDir,shapeVids);
% shapePics = dir([imgDir filesep 'obj_s_*.jpg']); shapePics = {shapePics.name};
% [shapePicsLow,shapePicsHigh] = sfInfo(imgDir,shapePics);
% 
% t(9) = toc;
% save('sfInfo.mat');
% 
% vehicleVids = dir([frameDir filesep 'obj_v_*.jpg']); vehicleVids = {vehicleVids.name};
% [vehicleVidsLow,vehicleVidsHigh] = sfInfo(frameDir,vehicleVids);
% vehiclePics = dir([imgDir filesep 'obj_v_*.jpg']); vehiclePics = {vehiclePics.name};
% [vehiclePicsLow,vehiclePicsHigh] = sfInfo(imgDir,vehiclePics);
% 
% t(10) = toc;
% save('sfInfo.mat');
% 
% egoVids = dir([frameDir filesep 'scn_e_*.jpg']); egoVids = {egoVids.name};
% [egoVidsLow,egoVidsHigh] = sfInfo(frameDir,egoVids);
% egoPics = dir([imgDir filesep 'scn_e_*.jpg']); egoPics = {egoPics.name};
% [egoPicsLow,egoPicsHigh] = sfInfo(imgDir,egoPics);
% 
% t(11) = toc;
% save('sfInfo.mat');
% 
% panVids = dir([frameDir filesep 'scn_p_*.jpg']); panVids = {panVids.name};
% [panVidsLow,panVidsHigh] = sfInfo(frameDir,panVids);
% panPics = dir([imgDir filesep 'scn_p_*.jpg']); panPics = {panPics.name};
% [panPicsLow,panPicsHigh] = sfInfo(imgDir,panPics);
% 
% t(12) = toc;
% save('sfInfo.mat');
% 
% stillVids = dir([frameDir filesep 'scn_s_*.jpg']); stillVids = {stillVids.name};
% [stillVidsLow,stillVidsHigh] = sfInfo(frameDir,stillVids);
% stillPics = dir([imgDir filesep 'scn_s_*.jpg']); stillPics = {stillPics.name};
% [stillPicsLow,stillPicsHigh] = sfInfo(imgDir,stillPics);
% 
% t(13) = toc;
% save('sfInfo.mat');
clear all
close all
clc
load('sfInfo.mat');

facesLow = mean([frontVidsLow frontPicsLow sideVidsLow sidePicsLow expVidsLow expPicsLow],'omitnan');
facesHigh = mean([frontVidsHigh frontPicsHigh sideVidsHigh sidePicsHigh expVidsHigh expPicsHigh],'omitnan');

bodiesLow = mean([handVidsLow handPicsLow feetVidsLow feetVidsLow],'omitnan');
bodiesHigh = mean([handVidsHigh handPicsHigh feetVidsHigh feetVidsHigh],'omitnan');

objectsLow = mean([collVidsLow collPicsLow shapeVidsLow shapePicsLow vehicleVidsLow vehiclePicsLow],'omitnan');
objectsHigh = mean([collVidsHigh collPicsHigh shapeVidsHigh shapePicsHigh vehicleVidsHigh vehiclePicsHigh],'omitnan');

scenesLow = mean([egoVidsLow egoPicsLow panVidsLow panPicsLow stillVidsLow stillPicsLow],'omitnan');
scenesHigh = mean([egoVidsHigh egoPicsHigh panVidsHigh panPicsHigh stillVidsHigh stillPicsHigh],'omitnan');

baselineLow = mean([baseVidsLow basePicsLow agentVidsLow agentPicsLow],'omitnan');
baselineHigh = mean([baseVidsHigh basePicsHigh agentVidsHigh agentPicsHigh],'omitnan');

flsem = std([frontVidsLow frontPicsLow sideVidsLow sidePicsLow expVidsLow expPicsLow],'omitnan')/sqrt(sum(~isnan([frontVidsLow frontPicsLow sideVidsLow sidePicsLow expVidsLow expPicsLow])));
fhsem = std([frontVidsHigh frontPicsHigh sideVidsHigh sidePicsHigh expVidsHigh expPicsHigh],'omitnan')/sqrt(sum(~isnan([frontVidsHigh frontPicsHigh sideVidsHigh sidePicsHigh expVidsHigh expPicsHigh])));

blsem = std([handVidsLow handPicsLow feetVidsLow feetVidsLow],'omitnan')/sqrt(sum(~isnan([handVidsLow handPicsLow feetVidsLow feetVidsLow])));
bhsem = std([handVidsHigh handPicsHigh feetVidsHigh feetVidsHigh],'omitnan')/sqrt(sum(~isnan([handVidsHigh handPicsHigh feetVidsHigh feetVidsHigh])));

olsem = std([collVidsLow collPicsLow shapeVidsLow shapePicsLow vehicleVidsLow vehiclePicsLow],'omitnan')/sqrt(sum(~isnan([collVidsLow collPicsLow shapeVidsLow shapePicsLow vehicleVidsLow vehiclePicsLow])));
ohsem = std([collVidsHigh collPicsHigh shapeVidsHigh shapePicsHigh vehicleVidsHigh vehiclePicsHigh],'omitnan')/sqrt(sum(~isnan([collVidsHigh collPicsHigh shapeVidsHigh shapePicsHigh vehicleVidsHigh vehiclePicsHigh])));

slsem = std([egoVidsLow egoPicsLow panVidsLow panPicsLow stillVidsLow stillPicsLow],'omitnan')/sqrt(sum(~isnan([egoVidsLow egoPicsLow panVidsLow panPicsLow stillVidsLow stillPicsLow])));
shsem = std([egoVidsHigh egoPicsHigh panVidsHigh panPicsHigh stillVidsHigh stillPicsHigh],'omitnan')/sqrt(sum(~isnan([egoVidsHigh egoPicsHigh panVidsHigh panPicsHigh stillVidsHigh stillPicsHigh])));

baselsem = std([baseVidsLow basePicsLow agentVidsLow agentPicsLow],'omitnan')/sqrt(sum(~isnan([baseVidsLow basePicsLow agentVidsLow agentPicsLow])));
basehsem = std([baseVidsHigh basePicsHigh agentVidsHigh agentPicsHigh],'omitnan')/sqrt(sum(~isnan([baseVidsHigh basePicsHigh agentVidsHigh agentPicsHigh])));


faceColor = [0.42 0.13 0.64];
bodyColor = [0.64 0.13 0.44];
objectColor = [0.13 0.53 0.64]; 
sceneColor = [0.36 0.64 0.13];
baselineColor = [247 216 74]./256;

data = [facesLow bodiesLow objectsLow scenesLow baselineLow];
lowSF4 = data/max(data);

% sem = [flsem blsem olsem slsem baselsem];
fig=figure('Units','Inches','Position',[5 5 3 3]);
b=bar(1:5,lowSF4,'FaceColor','flat');
% hold on
% er = errorbar(1:5,data,sem,sem,'.k','CapSize',0);
% hold off
b.CData(1,:) = faceColor;
b.CData(2,:) = bodyColor;
b.CData(3,:) = objectColor;
b.CData(4,:) = sceneColor;
b.CData(5,:) = baselineColor;
b.BaseLine.LineWidth = 1;
b.BaseLine.Color = 'k';
b.EdgeColor = 'none';
xticklabels('');
title(' ');
% title('Low Spatial Frequency Conent');
% ylabel('Power <1 c/deg')
ylim([0 1]);
ax = gca;
ax.FontName = 'Helvetica';
ax.FontSize = 18;
ax.TickLength = [0 0];
ax.Box = 'off';
ax.LineWidth = 1;
ax.XAxis.Visible = 'off';
fig.PaperSize = [7 3];
fig.PaperUnits = 'inches';
print('lowFreq5','-dpng','-r300');

data = [facesHigh bodiesHigh objectsHigh scenesHigh baselineHigh];
highSF4=data/max(data);
% sem = [fhsem bhsem ohsem shsem basehsem];
fig=figure('Units','Inches','Position',[5 5 3 3]);
b=bar(1:5,highSF4,'FaceColor','flat');
% hold on
% er = errorbar(1:5,data,sem,sem,'.k','CapSize',0);
% hold off
b.CData(1,:) = faceColor;
b.CData(2,:) = bodyColor;
b.CData(3,:) = objectColor;
b.CData(4,:) = sceneColor;
b.CData(5,:) = baselineColor;
b.BaseLine.LineWidth = 1;
b.BaseLine.Color = 'k';
b.EdgeColor = 'none';
xticklabels('');
% title('High Spatial Frequency Conent');
title(' ')
% ylabel('Power >5 c/deg');
ax = gca;
ax.FontName = 'Helvetica';
ax.FontSize = 18;
ylim([0 1]);
ax.TickLength = [0 0];
ax.Box = 'off';
ax.LineWidth = 1;
ax.XAxis.Visible = 'off';
fig.PaperSize = [7 3];
fig.PaperUnits = 'inches';
print('highFreq5','-dpng','-r300');

faceColor1 = [70 40 150]./256;
faceColor2 = [163 149 202]./256;
faceColor3 = [211 205 230]./256;
bodyColor1 = [187 70 131]./256;
bodyColor2 = [220 164 193]./256;
bodyColor3 = [237 209 223]./256;
objectColor1 = [67 133 160]./256; 
objectColor2 = [131 175 192]./256; 
objectColor3 = [193 215 224]./256; 
sceneColor1 = [55 106 65]./256;
sceneColor2 = [155 180 159]./256;
sceneColor3 = [206 218 208]./256;
baseline = [247 216 144]./256;

faces1low = mean([expVidsLow expPicsLow],'omitnan');
faces2low = mean([frontVidsLow frontPicsLow],'omitnan');
faces3low = mean([sideVidsLow sidePicsLow],'omitnan');
body1low = mean([feetVidsLow feetVidsLow],'omitnan');
body2low = mean([handVidsLow handPicsLow],'omitnan');
agentlow = mean([agentVidsLow agentPicsLow],'omitnan');
obj1low = mean([collVidsLow collPicsLow],'omitnan');
obj2low = mean([shapeVidsLow shapePicsLow],'omitnan');
obj3low = mean([vehicleVidsLow vehiclePicsLow],'omitnan');
scn1low = mean([egoVidsLow egoPicsLow],'omitnan');
scn2low = mean([panVidsLow panPicsLow],'omitnan');
scn3low = mean([stillVidsLow stillPicsLow],'omitnan');
baseLow = mean([baseVidsLow basePicsLow],'omitnan');

f1l = std([expVidsLow expPicsLow],'omitnan')/sqrt(sum(~isnan([expVidsLow expPicsLow])));
f2l = std([frontVidsLow frontPicsLow],'omitnan')/sqrt(sum(~isnan([frontVidsLow frontPicsLow])));
f3l = std([sideVidsLow sidePicsLow],'omitnan')/sqrt(sum(~isnan([sideVidsLow sidePicsLow])));
b1l = std([feetVidsLow feetVidsLow],'omitnan')/sqrt(sum(~isnan([feetVidsLow feetVidsLow])));
b2l = std([handVidsLow handPicsLow],'omitnan')/sqrt(sum(~isnan([handVidsLow handPicsLow])));
al = std([agentVidsLow agentPicsLow],'omitnan')/sqrt(sum(~isnan([agentVidsLow agentPicsLow])));
o1l = std([collVidsLow collPicsLow],'omitnan')/sqrt(sum(~isnan([collVidsLow collPicsLow])));
o2l = std([shapeVidsLow shapePicsLow],'omitnan')/sqrt(sum(~isnan([shapeVidsLow shapePicsLow])));
o3l = std([vehicleVidsLow vehiclePicsLow],'omitnan')/sqrt(sum(~isnan([vehicleVidsLow vehiclePicsLow])));
s1l = std([egoVidsLow egoPicsLow],'omitnan')/sqrt(sum(~isnan([egoVidsLow egoPicsLow])));
s2l = std([panVidsLow panPicsLow],'omitnan')/sqrt(sum(~isnan([panVidsLow panPicsLow])));
s3l = std([stillVidsLow stillPicsLow],'omitnan')/sqrt(sum(~isnan([stillVidsLow stillPicsLow])));
baseL = std([baseVidsLow basePicsLow],'omitnan')/sqrt(sum(~isnan([baseVidsLow basePicsLow])));

data = [faces1low faces2low faces3low body1low body2low agentlow ...
    obj1low obj2low obj3low scn1low scn2low scn3low baseLow];
% sem = [f1l f2l f3l b1l b2l al o1l o2l o3l s1l s2l s3l baseL];
idx4c11 = [10:12 1:3 7:9 4:5];
lowSF11=data(idx4c11)/max(data(idx4c11));
fig=figure('Units','Inches','Position',[5 5 7 3]);
b=bar(1:length(data),data/max(data),'FaceColor','flat');
% hold on
% er = errorbar(1:length(data),data,sem,sem,'.k','CapSize',0);
% hold off
b.CData(1,:) = faceColor1;
b.CData(2,:) = faceColor2;
b.CData(3,:) = faceColor3;
b.CData(4,:) = bodyColor1;
b.CData(5,:) = bodyColor2;
b.CData(6,:) = bodyColor3;
b.CData(7,:) = objectColor1;
b.CData(8,:) = objectColor2;
b.CData(9,:) = objectColor3;
b.CData(10,:) = sceneColor1;
b.CData(11,:) = sceneColor2;
b.CData(12,:) = sceneColor3;
b.CData(13,:) = baseline;
b.BaseLine.LineWidth = 1;
b.BaseLine.Color = 'k';
b.EdgeColor = 'none';
xticklabels('');
%title('Low Spatial Frequency Conent');
title(' ');
%ylabel('Power <1 c/deg');
ylim([0 1]);
ax = gca;
ax.FontName = 'Helvetica';
ax.FontSize = 18;
ax.TickLength = [0 0];
ax.Box = 'off';
ax.LineWidth = 1;
ax.XAxis.Visible = 'off';
set(gca,'yticklabel',num2str(get(gca,'ytick')','%.1f'));
fig.PaperSize = [7 3];
fig.PaperUnits = 'inches';
print('lowFreq13','-dpng','-r300');

faces1high = mean([expVidsHigh expPicsHigh],'omitnan');
faces2high = mean([frontVidsHigh frontPicsHigh],'omitnan');
faces3high = mean([sideVidsHigh sidePicsLow],'omitnan');
body1high = mean([feetVidsHigh feetVidsLow],'omitnan');
body2high = mean([handVidsHigh handPicsHigh],'omitnan');
agenthigh = mean([agentVidsHigh agentPicsHigh],'omitnan');
obj1high = mean([collVidsHigh collPicsHigh],'omitnan');
obj2high = mean([shapeVidsHigh shapePicsHigh],'omitnan');
obj3high = mean([vehicleVidsHigh vehiclePicsHigh],'omitnan');
scn1high = mean([egoVidsHigh egoPicsHigh],'omitnan');
scn2high = mean([panVidsHigh panPicsHigh],'omitnan');
scn3high = mean([stillVidsHigh stillPicsHigh],'omitnan');
baseHigh = mean([baseVidsHigh basePicsHigh],'omitnan');

f1h = mean([expVidsHigh expPicsHigh],'omitnan')/sqrt(sum(~isnan([expVidsHigh expPicsHigh])));
f2h = mean([frontVidsHigh frontPicsHigh],'omitnan')/sqrt(sum(~isnan([frontVidsHigh frontPicsHigh])));
f3h = mean([sideVidsHigh sidePicsLow],'omitnan')/sqrt(sum(~isnan([sideVidsHigh sidePicsLow])));
b1h = mean([feetVidsHigh feetVidsLow],'omitnan')/sqrt(sum(~isnan([feetVidsHigh feetVidsLow])));
b2h = mean([handVidsHigh handPicsHigh],'omitnan')/sqrt(sum(~isnan([handVidsHigh handPicsHigh])));
ah = mean([agentVidsHigh agentPicsHigh],'omitnan')/sqrt(sum(~isnan([agentVidsHigh agentPicsHigh])));
o1h = mean([collVidsHigh collPicsHigh],'omitnan')/sqrt(sum(~isnan([collVidsHigh collPicsHigh])));
o2h = mean([shapeVidsHigh shapePicsHigh],'omitnan')/sqrt(sum(~isnan([shapeVidsHigh shapePicsHigh])));
o3h = mean([vehicleVidsHigh vehiclePicsHigh],'omitnan')/sqrt(sum(~isnan([vehicleVidsHigh vehiclePicsHigh])));
s1h = mean([egoVidsHigh egoPicsHigh],'omitnan')/sqrt(sum(~isnan([egoVidsHigh egoPicsHigh])));
s2h = mean([panVidsHigh panPicsHigh],'omitnan')/sqrt(sum(~isnan([panVidsHigh panPicsHigh])));
s3h = mean([stillVidsHigh stillPicsHigh],'omitnan')/sqrt(sum(~isnan([stillVidsHigh stillPicsHigh])));
baseH = mean([baseVidsHigh basePicsHigh],'omitnan')/sqrt(sum(~isnan([baseVidsHigh basePicsHigh])));

data = [faces1high faces2high faces3high body1high body2high agenthigh ...
    obj1high obj2high obj3high scn1high scn2high scn3high baseHigh];
highSF11 = data(idx4c11)/max(data(idx4c11));
save('sf4mods.mat','highSF11','lowSF11','highSF4','lowSF4');
sem = [f1h f2h f3h b1h b2h ah o1h o2h o3h s1h s2h s3h baseH];
fig=figure('Units','Inches','Position',[5 5 7 3]);
b=bar(1:length(data),data/max(data),'FaceColor','flat');
% hold on
% er = errorbar(1:length(data),data,sem,sem,'.k','CapSize',0);
% hold off
b.CData(1,:) = faceColor1;
b.CData(2,:) = faceColor2;
b.CData(3,:) = faceColor3;
b.CData(4,:) = bodyColor1;
b.CData(5,:) = bodyColor2;
b.CData(6,:) = bodyColor3;
b.CData(7,:) = objectColor1;
b.CData(8,:) = objectColor2;
b.CData(9,:) = objectColor3;
b.CData(10,:) = sceneColor1;
b.CData(11,:) = sceneColor2;
b.CData(12,:) = sceneColor3;
b.CData(13,:) = baseline;
b.BaseLine.LineWidth = 1;
b.BaseLine.Color = 'k';
b.EdgeColor = 'none';
xticklabels('');
%title('High Spatial Frequency Content');
title('');
%ylabel('Power >5 c/deg');
ylim([0 1]);
ax = gca;
ax.FontName = 'Helvetica';
ax.FontSize = 18;
ax.TickLength = [0 0];
ax.Box = 'off';
ax.LineWidth = 1;
ax.XAxis.Visible = 'off';
set(gca,'yticklabel',num2str(get(gca,'ytick')','%.1f'));
fig.PaperSize = [7 3];
fig.PaperUnits = 'inches';
print('highFreq13','-dpng','-r300');