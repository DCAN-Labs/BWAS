function parcel=dlabel2parcel(path_dlabel,path_parcellation_table)

%% dlabel2parcel

% Oscar Miranda Dominguez
% First line of code: Nov 28, 2021
%% dlabel2parcel
%
% Use this function to assign each grayordinate in a label file to a
% network using a reference parcellation table

%% Example 1
% path_dlabel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/cifti_tools/templates/label_files/human/Gordon.subcortical.32k_fs_LR.dlabel.nii';
% path_parcellation_table='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_gordon/Gordon_parcel.csv';
% parcel=dlabel2parcel(path_dlabel,path_parcellation_table);
%% Import reference table
parcel=loadParcel(path_parcellation_table);
T = parcel_str2table(parcel);
n_parcels=size(parcel,2);
%% Read dlabel
X=cifti2mat(path_dlabel);

%% Removing zeros
X(X==0)=[];

% whos X
% [min(X) max(X)]
%% Assign grayordinates to network
new_parcel=parcel;
for i=1:n_parcels
    n_rois=parcel(i).n;
    IX=cell(n_rois,1);
    local_ix=parcel(i).ix;
    for j=1:n_rois
        IX{j}=find(X==local_ix(j));
    end
    ix=cat(1,IX{:});
    n=numel(ix);
    new_parcel(i).ix=ix;
    new_parcel(i).n=n;
end
%% Rename parcel
parcel=new_parcel;
%%
summarize_parcel(parcel)