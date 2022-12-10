function mask=make_mask_parcel_paired_networks(parcel,mask_ix)
%%

n_rois=sum(cat(1,parcel.n));
n_pairs=size(mask_ix,1);

mask=zeros(n_rois,n_rois);

for i=1:n_pairs
    I=parcel(mask_ix(i,1)).ix;
    J=parcel(mask_ix(i,2)).ix;
    
    mask(I,J)=1;
    mask(J,I)=1;
end

