path_dlabel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/cifti_tools/templates/label_files/human/Gordon.subcortical.32k_fs_LR.dlabel.nii';
path_parcellation_table='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_gordon/Gordon_parcel.csv';
parcel=dlabel2parcel(path_dlabel,path_parcellation_table);
%%

wd='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_dgordon';
cd (wd)
%%
filename='parcel_dgordon.mat';
save(filename,'parcel')