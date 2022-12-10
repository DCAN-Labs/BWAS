function [test, stat, p]=compare_2_groups(x1,x2,test_2_samples)
%%
try
    x1=cell2mat(x1);
end
try
    x2=cell2mat(x2);
end
%% combine data to determine data type

x=[x1(:);x2(:)];
ix=~isnan(x);
x=x(ix);

if isnumeric(x)
    
    if strcmp(test_2_samples,'t')
        test='t test2';
    end
    
    if strcmp(test_2_samples,'k')
        test='KS test2';
    end
end

%% perform the test
ix1=~isnan(x1);
ix2=~isnan(x2);
X1=x1(ix1);
X2=x2(ix2);

switch test
    case 't test2'
        [h,p,ci,stats] = ttest2(X1,X2);
        stat=['t = ' num2format_text(stats.tstat), ', p = ' num2format_text(p)];
    case 'KS test2'
        [h,p,stats] = kstest2(X1,X2);
        stat=['kstest2 = ' num2format_text(stats), ', p = ' num2format_text(p)];
end