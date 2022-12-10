function label_by_network(path_label,path_parcel,parcellation,varargin)

%% Example 1

% path_label='/panfs/roc/groups/8/faird/shared/code/internal/utilities/cifti_tools/templates/label_files/human/Gordon.networks.32k_fs_LR.dlabel.nii';
% path_parcel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/Gordon.csv';
% parcellation='Gordon';
% label_by_network(path_label,path_parcel,parcellation)
%% Example 2

% path_label='/home/faird/shared/code/external/ROIS/ColeAnticevicNetPartition/CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_parcels_LR.dlabel.nii';
% path_parcel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/HCP_ColeAnticevic.csv';
% parcellation='HCP_ColeAnticevic';
% output_folder='/panfs/roc/groups/4/miran045/shared/projects/messing_with_labels/making_label_files_per_network';
% label_by_network(path_label,path_parcel,parcellation,'output_folder',output_folder);
%%


% Define defaults
output_folder=pwd;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'output_folder'
            output_folder=varargin{q+1}; 
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Make outputfolder if it doesnot exist
if ~isfolder(output_folder)
    mkdir(output_folder)
end

%% load parcel
parcel=loadParcel(path_parcel);
n=size(parcel,2);

%% get path wb_command
path_wb_c=validate_path_wb_command();
path_wb_c=path_wb_c.paths.wb_command;

%% Do it


cii_paint=ciftiopen(path_label,path_wb_c);
paintcii=cii_paint;
n=size(parcel,2);
N_larger_ROI=double(max(unique(paintcii.cdata)));

for i=1:n
    ix=unique(cat(1,parcel(i).ix));
    temp_paint=cii_paint.cdata;
    temp=nan(N_larger_ROI,1);
    
    part=[parcellation '_' parcel(i).shortname];
    
    foo_paint=temp_paint;
    foo=temp;
%     foo(ix(1:pot_up_to(ii)))=1;
    
    foo(ix)=1;
    for jj=1:max(foo_paint)
        
        if isnan(foo(jj))
            foo_paint(foo_paint==jj)=nan;
        end
    end
    paintcii.cdata=foo_paint;
    paint_file=[output_folder filesep part '.dlabel.nii'];
    ciftisave(paintcii,paint_file,path_wb_c);
end