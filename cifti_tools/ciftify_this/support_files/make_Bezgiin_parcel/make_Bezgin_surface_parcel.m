
addpath(genpath('P:\code\internal\utilities\OSCAR_WIP\'))
%%
clc
Dictionary_filename='dictionary_Bezgin_labels_ix.csv';
tidyData_filename='Bezgin_surface_labels_ix.csv';
[tidyData, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);
%% 

n=size(tidyData,1);

bezgiin_surface_network=cell(n,1);
bezgiin_surface_roi=cell(n,1);
%%
run('P:\code\internal\utilities\OSCAR_WIP\cifti_tools\ciftify_this\support_files\bezgiin_rois.m')

% bezgiin_rois
parcel = get_rois_per_network(bezgiin_network);
parcel = get_bezgiin_colors(parcel);
network=short_name_bezgiin(bezgiin_network);
[net_mat, net_num, LUT]=get_net_mat(network);
%%
for i=1:n
    key=table2array(tidyData(i,end));
    key=strtrim(key);
    for j=1:n
        if contains(bezgiin_roi{j},key)
            break
        end
    end
    bezgiin_surface_network{i}=bezgiin_network{j};
    bezgiin_surface_roi{i}=bezgiin_roi{j};
end

parcel = get_rois_per_network(bezgiin_surface_network);
parcel = get_bezgiin_colors(parcel);
network=short_name_bezgiin(bezgiin_surface_network);
[net_mat, net_num, LUT]=get_net_mat(bezgiin_surface_network);

save('parcels_bezgiin_surface.mat','parcel','bezgiin_surface_roi','bezgiin_surface_roi')