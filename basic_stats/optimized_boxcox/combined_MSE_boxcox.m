function MSE=combined_MSE_boxcox(lambda,data)
ng_bc=size(data,1);

MSE=0;
for i=1:ng_bc
    foo=home_made_boxcox(lambda,data{i});
    MSE=MSE+foo;
end