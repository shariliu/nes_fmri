function printAngleFilters(SF,theta,saveDir,fn)

%constant filter parameters
mA=4;%control sigma
xLength=300;
yLength=300;

%parameters for invariace
rotationList=0:pi/8:(2*pi)-pi/8;
waveLength=1/SF;

for rot=1%:length(rotationList)
    alpha=rotationList(rot);
    [SpaceKernel, ~, ~] = AngleFilter(waveLength,...
        alpha, theta, mA, xLength, yLength);
    filter=real(SpaceKernel);
    fn2 = [fn '-rot' num2str(round(rad2deg(alpha)))];
    figName = [saveDir filesep fn2];
    fig=figure('Units','Inches','Position',[5 5 3 3]);
    %imagesc(filter)
    imshow(filter,[min(min(filter)) max(max(filter))]);
    ax.TickLength = [0 0];
    ax.Box = 'off';
    ax.LineWidth = 1;
    ax.XAxis.Visible = 'off';
    xticklabels('');
    yticklabels('');
    fig.PaperSize = [3 3];
    fig.PaperUnits = 'inches';
    print(figName,'-dpng','-r300');
end



