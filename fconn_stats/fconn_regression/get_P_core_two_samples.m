function p=get_P_core_two_samples(x_alt,x_null,outcome)

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
p.k=nan;


%% Do cummulative

[f,x] = ecdf(x_null);


switch outcome
    case 'R'
        ix=find(x>=x_alt,1);
        if isempty(ix)
            if x_alt>x(end)
                p.c=0;
            else
                p.c=1;
            end
        else
            p.c=1-f(ix);
        end
        
        
    otherwise
        
        ix=find(x>=x_alt,1);
        if isempty(ix)
            if x_alt<x(1)
                p.c=0;
            else
                p.c=1;
            end
        else
            p.c=f(ix);
        end
        
end
% nsamples=length(x_alt);
% alpha = 0.05;
% conf = 1-alpha;
% cutoff=quantile(x_null,conf);
% p.c=1-binofit(sum(x_alt>cutoff),nsamples);