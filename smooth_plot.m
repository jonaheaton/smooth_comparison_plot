function [x_space,y_smooth,y_ste,y_num] = smooth_plot(xdata,ydata,sigma,xlimits)
if nargin < 4
    xlimits = [];
end
suppress_warnings = 1;

if isempty(xlimits)
    xmin = prctile(xdata,1);
    xmax = prctile(xdata,99);
else
    xmin = xlimits(1);
    xmax = xlimits(2);
end

    %npoints = 50;
    npoints = round(2*(xmax-xmin)/sigma);
    %npoints = round(4*(xmax-xmin)/sigma);
    x_space = linspace(xmin,xmax,npoints);
 
y_smooth = nan(size(x_space));
y_ste  = nan(size(x_space));
y_num =  nan(size(x_space));
total_w = nan(size(x_space));
if ~isempty(xdata)
notnan1 = ~isnan(ydata);
notnan2 = ~isnan(xdata);
notnan = and(notnan1,notnan2);
xdata = xdata(notnan);
ydata = ydata(notnan);
all_w = nan(size(xdata,1),npoints);
%w_thresh = .0005;
w_thresh = .02/sigma;

for ii=1:length(y_smooth)
    w = internal_gauss(xdata,x_space(ii),sigma);
    w(w < w_thresh) = 0;
    y_smooth(ii) = sum(w.*ydata)/sum(w);
    %y_err(ii) = sqrt(var(ydata,w))/sqrt(sum(w));
    y_std(ii) = sqrt(var(ydata,w));
    total_w(ii) = sum(w);
    all_w(:,ii) = w;
end

% remove the data points that were not given any weight in dataset
all_w(all_w<w_thresh) = NaN;
normalized_w = all_w./nansum(all_w,2);
removed_indx = nansum(all_w,2) < w_thresh;
y_num = nansum(normalized_w,1);
y_ste = y_std./sqrt(y_num);

if ~suppress_warnings
    if sum(removed_indx) > 0
        display('x-points not included')
        display(xdata(removed_indx))
    end
    
    if abs(sum(notnan) - nansum(normalized_w(:))) > .1 + sum(removed_indx)
        warning('ste not computed correctly')
    end
end
end

end



function y = internal_gauss(x,mu,sigma)
    y = (1/(sigma*sqrt(2*pi)))*exp(-0.5*((x-mu)/sigma).^2);
end