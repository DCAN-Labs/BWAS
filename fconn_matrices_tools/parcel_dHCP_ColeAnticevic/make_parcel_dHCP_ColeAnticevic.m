path_dlabel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/cifti_tools/templates/label_files/human/HCP.subcortical.32k_fs_LR.dlabel.nii';
path_parcellation_table='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/HCP_ColeAnticevic_subcortical.mat';
parcel=dlabel2parcel(path_dlabel,path_parcellation_table);
%%

wd='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_dHCP_ColeAnticevic';
cd (wd)
%%
filename='parcel_dHCP_ColeAnticevic.mat';
save(filename,'parcel')