function clims=get_ptiles_M_from_pairs(newM,delta,newParcel,ix_parcel_pairs_on)

n_trun=size(ix_parcel_pairs_on,1);
temp=cell(n_trun,1);
for k=1:n_trun
    i=ix_parcel_pairs_on(k,1);
    j=ix_parcel_pairs_on(k,2);
    foo=newM(newParcel(i).ix,newParcel(j).ix,:);
    temp{k}=foo(:);
end

temp=cell2mat(temp);
temp(temp==1)=[];
ptiles=[delta 100-delta]; %percentiles to incluide
clims=prctile(temp,ptiles);