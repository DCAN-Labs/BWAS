function M_transformed=apply_transformations(M,between_groups,within_headers,options)


M_transformed=M;

if options.calculate_Fisher_Z_transform
    M_transformed=atanh(M);
    display('Doing Fisher Z-transformation')
end

if options.boxcox_transform
    
    disp ('Applying boxcox transformation')
    data=group_data(M,between_groups,within_headers);
    
    % MSE=combined_MSE_boxcox(lambda,data);
    lambda=1;
    fitfun=@combined_MSE_boxcox;
    options_fminsearch=[];
    lambda=fminsearch(fitfun,lambda,options_fminsearch,data);
    
    [MSE, x_boxcox]=home_made_boxcox(lambda,M-min(M(:))+1);
    x_backup=M;
    M_transformed=x_boxcox;
    
end