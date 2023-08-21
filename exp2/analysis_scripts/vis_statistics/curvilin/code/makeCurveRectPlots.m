function makeCurveRectPlots(data,sem,cond,figName,yLim)
if cond == 4
    faceColor = [0.42 0.13 0.64];
    bodyColor = [0.64 0.13 0.44];
    objectColor = [0.13 0.53 0.64];
    sceneColor = [0.36 0.64 0.13];
    baselineColor = [247 216 74]./256;
    fig=figure('Units','Inches','Position',[5 5 3 3]);
    b=bar(1:length(data),data,'FaceColor','flat');
    if ~isempty(sem)
    hold on
    er = errorbar(1:length(data),data,sem,sem,'.k','CapSize',0);
    hold off
    end
    b.CData(1,:) = faceColor;
    b.CData(2,:) = bodyColor;
    b.CData(3,:) = objectColor;
    b.CData(4,:) = sceneColor;
    if length(data)>4
    b.CData(5,:) = baselineColor;
    end
    b.BaseLine.LineWidth = 1;
    b.BaseLine.Color = 'k';
    b.EdgeColor = 'none';
    xticklabels('');
%     title(figName);
    title('  ');
    if ~isempty(yLim)
    ylim(yLim);
    end
    ax = gca;
    ax.FontName = 'Helvetica';
    ax.FontSize = 18;
    ax.TickLength = [0 0];
    ax.Box = 'off';
    ax.LineWidth = 1;
    ax.XAxis.Visible = 'off';
    set(gca,'yticklabel',num2str(get(gca,'ytick')','%.1f'));
    fig.PaperSize = [3 3];
    fig.PaperUnits = 'inches';
    print(figName,'-dpng','-r300');
    
elseif cond == 12
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
    
    fig=figure('Units','Inches','Position',[5 5 7 3]);
    b=bar(1:length(data),data,'FaceColor','flat');
    if ~isempty(sem)
    hold on
    er = errorbar(1:length(data),data,sem,sem,'.k','CapSize',0);
    hold off
    end
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
    if length(data)>12
    b.CData(13,:) = baseline;
    end
    b.BaseLine.LineWidth = 1;
    b.BaseLine.Color = 'k';
    b.EdgeColor = 'none';
    xticklabels('');
%     title(figName);
    title('  ');
    if ~isempty(yLim)
    ylim(yLim);
    end
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
    print(figName,'-dpng','-r200');
end