function [y_transformed, params]=boxcox_transform(y,params)

y_transformed=nan(size(y));
ix_nan=isnan(y);
data2=cell(1,1);
data2{1}=y(~ix_nan);

pos_data=offset_data(data2);

if nargin<2
    lambda=1;
    fitfun=@combined_MSE_boxcox;
    options_fminsearch=[];
    lambda=fminsearch(fitfun,lambda,options_fminsearch,pos_data);
    [MSE, x_boxcox]=home_made_boxcox(lambda,pos_data{1});
    foo=zscore(x_boxcox);
    y_transformed(~ix_nan)=zscore(x_boxcox);
else
    lambda=params.lambda;
    m=params.m;
    s=params.s;
    
    [MSE, x_boxcox]=home_made_boxcox(lambda,pos_data{1});
    
    foo=(x_boxcox-m)/s;
    y_transformed(~ix_nan)=(x_boxcox-m)/s;
end

if nargout==2
    
    params.lambda=lambda;
    params.m=mean(x_boxcox);
    params.s=std(x_boxcox);
end