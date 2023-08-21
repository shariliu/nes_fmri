clear all
close all
clc
saveDir = '/mindhive/nklab5/users/hlk/projects/visual/stimuli/curvRect4/filterSubset';
thetaList=[0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];
SFlist=[1 2 4 8];
bendList = [0.001 0.005 0.01 0.05 0.1];
for iTheta = 1:length(thetaList)
    t = thetaList(iTheta);
    for iSF = 1:length(SFlist)
        s = SFlist(iSF);
        fn2 = ['agl-theta' num2str(rad2deg(t),0) '-SF' num2str(s)];
        printAngleFilters(s,t,saveDir,fn2);
        for iBend = 1:length(bendList)
            bend = bendList(iBend);
            fn2 = ['crv-theta' num2str(rad2deg(t)) '-SF' num2str(s) '-bend' num2str(iBend)];
            printCurveFilters(s,t,bend,saveDir,fn2)
        end
    end
end

% figure
% idx = 1;
% for iSF = 1:length(SFlist)
%     w=1/SFlist(iSF);
%     for iTheta = 1:length(thetaList)
%         t = thetaList(iTheta);
%         [SpaceKernel, ~, ~] = AngleFilter(w,0,t,4,300,300);
%         filter=real(SpaceKernel);
%         subplot(4,6,idx);
%         imagesc(filter)
%         ax.TickLength = [0 0];
%         ax.Box = 'off';
%         ax.LineWidth = 1;
%         ax.XAxis.Visible = 'off';
%         xticklabels('');
%         yticklabels('');
%         idx = idx + 1;
%     end
% end
% 
% figure
% idx = 1;
% for iSF = 1:length(SFlist)
%     w=1/SFlist(iSF);
%     for iTheta = 1:length(thetaList)
%         t = thetaList(iTheta);
%         for iBend = 1:length(bendList)
%             b = bendList(iBend);
%             [SpaceKernel, ~, ~] = CurveFilter(w,0,b,t,4,300,300);
%             subplot(8,15,idx)
%             filter=real(SpaceKernel);
%             imagesc(filter)
%             ax.TickLength = [0 0];
%             ax.Box = 'off';
%             ax.LineWidth = 1;
%             ax.XAxis.Visible = 'off';
%             xticklabels('');
%             yticklabels('');
%             idx = idx + 1;
%         end
%     end
% end