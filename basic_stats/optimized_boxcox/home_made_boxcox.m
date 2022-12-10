function [MSE, transdat] = home_made_boxcox(lambda,data)

ix=~isnan(data(:));
if lambda==0
    transdat=log(data)*geomean(data(ix));
else
    transdat=(data.^lambda-1)/(lambda*geomean(data(ix)).^(lambda-1)); 
end
MSE=sum((transdat(ix)-mean(transdat(ix))).^2)/numel(transdat);