function [x_hist, y_hist]=get_hist_data(Xcell,options)

xcat=cat(1,Xcell{:});

n_bins=options.n_bins;
if isempty(n_bins)
    [N,edges] = histcounts(xcat);
    n_bins=length(edges);
else
    [N,edges] = histcounts(xcat,n_bins);
end

m=min(edges);
M=max(edges);
x_hist=linspace(m,M,n_bins)';

if ~isempty(options.xlim)
    m=options.xlim(1);
    M=options.xlim(2);
    delta=mean(diff(x_hist));
    x_hist=m:delta:M;
    n_bins=numel(x_hist);
end


traces=length(Xcell);
y_hist=zeros(n_bins,traces);

for i=1:traces
    y_hist(:,i)=histc(Xcell{i},x_hist);
end