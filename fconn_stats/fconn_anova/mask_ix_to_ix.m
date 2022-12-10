function mask = mask_ix_to_ix(ix_to_ix,to_use)

mask1=ismember(ix_to_ix',to_use','rows');
mask2=ismember(ix_to_ix',to_use([2 1],:)','rows');
mask=or(mask1,mask2);
mask=find(mask);