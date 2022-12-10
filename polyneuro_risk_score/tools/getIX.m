function IX = getIX(parcel_set_provided_flag,...
    n_th,...
    n_features,...
    R_Adjusted,...
    options,...
    ix)

IX=zeros(n_th,n_features);

%% Select the top features
if parcel_set_provided_flag==1
    for i=1:n_th
        IX(i,ix{i})=1;
    end
else
    [f1 ix_in]=max(R_Adjusted);
    IX(1,ix_in(1))=1;
    ptiles=prctile(R_Adjusted,100-options.percentile);
    for i=2:n_th
        ix_in=R_Adjusted>=ptiles(i-1);
        IX(i,:)=ix_in;
    end
end
