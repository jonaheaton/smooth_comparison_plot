function [output] = pre_smooth_plot(data1,data2,logscale1,logscale2,options)

if iscell(data1)
else
    data1 = {data1};
end

if iscell(data2)
else
    data2 = {data2};
end

if nargin < 5
    options = [];
end

%% assign the options
if isfield(options,'plotcolor')
    plotcolor = options.plotcolor;
else
    plotcolor = 1:length(data1);
end

if isfield(options,'lnw')
    lnw = options.lnw;
else
    lnw = 2;
end

if isfield(options,'opacity_alpha')
    opacity_alpha = options.opacity_alpha;
else
    opacity_alpha = 0.1;
end

if isfield(options,'num_thresh')
    num_thresh = options.num_thresh;
else
    num_thresh = 3;
end


%% to choose your own colors, list colors in cellarray
if iscell(plotcolor)
    ColorSpec = plotcolor;
else
    [ColorSpec] = get_color_spec(plotcolor);
end

if ~iscell(ColorSpec)
    ColorSpec = {ColorSpec};
end


%% logscale
totdata1 = [];
totdata2 = [];
for ii=1:length(data1)
    subdata1 = data1{ii};
    subdata2 = data2{ii};
    
    if logscale1
        %mydata1 = subdata1(subdata1>0);
        mydata1 = subdata1;
        mydata1(subdata1<=0) = NaN;
        if sum(subdata1<=0) > 0
            display(['amount of data1 le 0: ' num2str(sum(subdata1<=0))]);
        end
        mydata1 = log10(mydata1);
    else
        mydata1 = subdata1;
    end
    totdata1 = [totdata1; mydata1(:)];
    data1{ii} = mydata1;
    
    if logscale2
        %mydata2 = subdata2(subdata2>0);
        mydata2 = subdata2;
        mydata2(subdata2<=0) = NaN;
        if sum(subdata2<=0) > 0
            display(['amount of data2 le 0: ' num2str(sum(subdata2<=0))]);
        end
        mydata2 = log10(mydata2);
    else
        mydata2 = subdata2;
    end
    totdata2 = [totdata2; mydata2(:)];
    data2{ii} = mydata2;
    
end

%% smooth plot
%sigma = std(totdata1)/sqrt(length(totdata1));
%sigma = std(totdata1)/2;
output = {};
plotstruc = [];
for jj=1:length(data2)
    %xlimits = quantile(xdata,[.05,.95]);
    xdata = data1{jj};
    ydata = data2{jj};
    sigma = std(xdata)/2;
    [x_space,y_smooth,y_err,y_num] = smooth_plot(xdata,ydata,sigma);
    output(jj).x_space = x_space;
    output(jj).y_smooth = y_smooth;
    output(jj).y_err = y_err;
    output(jj).y_num = y_num;
    
    xx = x_space(y_num>num_thresh);
    yy = y_smooth(y_num>num_thresh);
    yye = y_err(y_num>num_thresh);
    
    patch = fill([xx,fliplr(xx)], [yy+yye,fliplr(yy-yye)], ColorSpec{jj});
    set(patch, 'edgecolor', 'none');
    set(patch, 'FaceAlpha', opacity_alpha);
    hold on;
    %errorbar(x_space,y_smooth,y_err,'-','Color',ColorSpec{jj},'LineWidth',lnw/2)
    %hold on
end
for jj=1:length(data2)
    xx = output(jj).x_space;
    yy = output(jj).y_smooth;
    nn = output(jj).y_num;
    xx = xx(nn>num_thresh);
    yy = yy(nn>num_thresh);
    if ~isempty(xx)
        %plotstruc(jj) = plot(xx,yy,'-','Color',ColorSpec{jj},'LineWidth',lnw);
        plot(xx,yy,'-','Color',ColorSpec{jj},'LineWidth',lnw);
    else
        plot([],[],'-','Color',ColorSpec{jj},'LineWidth',lnw);
    end
end

%% make Axis
if logscale1
    ticksMajor = [-4,-3,-2,-1,0,1,2,3,4,5,6,7];
    ticksMinor = log10([[2:9]*10^(-4),[2:9]*10^(-3),[2:9]*10^(-2),[2:9]*10^(-1),[2:9]*10^(0),[2:9]*10^(1),[2:9]*10^(2),[2:9]*10^(3),[2:9]*10^(4),[2:9]*10^(5),[2:9]*10^(6)]);
    ticklabels = {'10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}','10^{1}','10^{2}','10^{2}','10^{4}','10^{5}','10^{6}','10^{7}'};
    set(gca,'XTick',ticksMajor,'XTickLabel',ticklabels)
    set(gca,'XMinorTick','on')
    hA=gca;
    hA.XAxis.MinorTickValues = ticksMinor;
end

if logscale2
    ticksMajor = [-4,-3,-2,-1,0,1,2,3,4,5,6,7];
    ticksMinor = log10([[2:9]*10^(-4),[2:9]*10^(-3),[2:9]*10^(-2),[2:9]*10^(-1),[2:9]*10^(0),[2:9]*10^(1),[2:9]*10^(2),[2:9]*10^(3),[2:9]*10^(4),[2:9]*10^(5),[2:9]*10^(6)]);
    ticklabels = {'10^{-4}','10^{-3}','10^{-2}','10^{-1}','10^{0}','10^{1}','10^{2}','10^{2}','10^{4}','10^{5}','10^{6}','10^{7}'};
    set(gca,'YTick',ticksMajor,'YTickLabel',ticklabels)
    set(gca,'YMinorTick','on')
    hA=gca;
    hA.YAxis.MinorTickValues = ticksMinor;
end

box on
hold off
set(gca, 'Layer','top')
%set(gca,'TickDir','out')

set(gca,'TickLength',[0.02 0.05])
set(gca,'linewidth',3)
set(gca,'fontsize',18)
% ylim([ymin-.4*ymid,ymax+.4*ymid])
% xlim([xmin, xmax])
% limX = [xmin, xmax];
% limY = [ymin-.4*ymid,ymax+.4*ymid];

