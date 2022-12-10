%% Add paths to the current session
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/external/utilities/gifti-1.6'))
addpath(genpath('/panfs/roc/groups/4/miran045/shared/code/internal/utilities/Matlab_CIFTI'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/cifti_tools'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/biceps'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_stats'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/text_manipulation'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/basic_stats'))
addpath(genpath('/panfs/roc/groups/8/faird/shared/code/internal/utilities/files_handling'))
%% Define working directory

wd='/panfs/roc/groups/4/miran045/shared/projects/messing_with_labels/int_zones';
cd (wd)
fs=filesep;
%% Make as many dtserises as ROIs are in the integhrative zones are
lab1='/home/faird/shared/code/internal/utilities/cifti_tools/templates/label_files/human/ABCD_GRP1_overlap_number_of_nets_avg_number_of_network_2.2_thres_sz60_clusters.dlabel.nii';
L1=cifti2mat(lab1);

[u,nu,ix,nix]=find_uniques(L1);

path_dtseries='/home/faird/shared/code/internal/utilities/cifti_tools/templates/xtseries/Atlas_subcortical.dtseries.nii';
dtseries=cifti2mat(path_dtseries);
dtseries=dtseries*0;
input_file=cell(nu-1,1);
for i=1:nu-1
    j=find(u==i);
    filename=['int_zone_' num2str(i) '.dtseries.nii'];
    local_dtseries=dtseries;
    local_dtseries(ix{j})=1;
    mat2cifti(local_dtseries,filename);
    input_file{i}=filename;
end

%% Read label file per Gordon network
root_path='/panfs/roc/groups/4/miran045/shared/projects/messing_with_labels/making_label_files_per_network/';
depth=0;
string_to_match='*ordon*';

lab_gordon=get_path_to_file(root_path,depth,string_to_match);
n_networks=size(lab_gordon,1);

%% rin cifti parcellate as a double for loop
path_wb_c=validate_path_wb_command();
path_wb_c=path_wb_c.paths.wb_command;

path_parcel='/panfs/roc/groups/8/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/Gordon.csv';
parcel=loadParcel(path_parcel);
n=size(parcel,2);

for i=1:nu-1
    output_folder=[wd fs 'int_zone_' num2str(i)];
    mkdir(output_folder)
    for j=1:n_networks
        
        lab_gordon=['/panfs/roc/groups/4/miran045/shared/projects/messing_with_labels/making_label_files_per_network/Gordon_' parcel(j).shortname '.dlabel.nii'];
        output_file=[output_folder fs 'int_zone_' num2str(i) '_network_' num2str(j) '.ptseries.nii'] ;
        text_to_eval=[path_wb_c ' -cifti-parcellate ' input_file{i} ' ' lab_gordon ' COLUMN ' output_file ' -method SUM'];
        unix(text_to_eval)
    end
end

%% Count and identify the winnner take all



%%

winner=zeros(nu-1,1);
for i=1:nu-1
    output_folder=[wd fs 'int_zone_' num2str(i)];
    depth=0;
    string_to_match='*ptseries*';
    
    count=zeros(n_networks,1);
    for j=1:n_networks
        output_file=[output_folder fs 'int_zone_' num2str(i) '_network_' num2str(j) '.ptseries.nii'];
        local_pt_series=cifti2mat(output_file);
        count(j)=sum(local_pt_series);
    end
    [a, b]=max(count);
    if a>0
    winner(i)=b;
    
    end
end
%% Save label file color coded as in gordon
roi_ix=[1:nu-1]';
shortname=cell(nu-1,1);
name=cell(nu-1,1);
for i=1:nu-1
    if winner(i)==0
        shortname{i}='Sub';
        name{i}='Subcortical';
    else
    shortname{i}=parcel(winner(i)).shortname;
    name{i}=parcel(winner(i)).name;
    end
end
T=table(roi_ix,name,shortname);
writetable(T,'int_zones_in_Gordon.csv');