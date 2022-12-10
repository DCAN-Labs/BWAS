function p=get_P_core(x_alt,x_null)

% switch options.comparison_method
%     case 'kolmogorov'
%         [h, p]=kstest2(x_alt,x_null);
%     case 'cumulative'
%         nsamples=length(x_alt);
%         alpha = 0.05;
%         conf = 1-alpha;
%         cutoff=quantile(x_null,conf);
%         p=1-binofit(sum(x_alt>cutoff),nsamples);
% end

%% Do Kolmokorov
[h, p.k]=kstest2(x_alt,x_null);

%% Do cummulative
nsamples=length(x_alt);
alpha = 0.05;
conf = 1-alpha;
cutoff=quantile(x_null,conf);
p.c=1-binofit(sum(x_alt>cutoff),nsamples);