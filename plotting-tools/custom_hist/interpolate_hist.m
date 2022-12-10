function [xi,yi]=interpolate_hist(h,xl,n_points)

%% Given a histogram, get the outline given n_points

if nargin<3
    n_points=1e4;
end


method='nearest';
NumBins=h.NumBins;

xh=zeros(NumBins,1);
for i=1:NumBins
    xh(i)=mean(h.BinEdges([i i+1]));
    
end
delta=mean(diff(xh));
xh=[xh(1)-delta xh' xh(end)+delta];

yh=[0 h.Values 0];
xi=linspace(xl(1),xl(2),n_points);
yi=interp1(xh(:),yh(:),xi,method);
yi(isnan(yi))=0;