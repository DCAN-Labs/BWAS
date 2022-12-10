function [P, C] =read_pValues_and_Color(path_pvalue_cifti,path_parcellation_table,options)

%% Read p-Value

pValues_raw = load_imaging_data(path_pvalue_cifti);


%% identify if is pconn
ispconn=contains(path_pvalue_cifti,'pconn.nii');


%% Tabify imaging data

F=pValues_raw;
if ispconn
    F=cat(3,pValues_raw,pValues_raw);
end

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(F,options);

P=Y{:,1};
if ispconn
    P=Y{1,:}';
end
%% Read parcellation scheme and count functionalk network pairs
parcel=loadParcel(path_parcellation_table);
[network_names, row, col]=get_network_names(parcel,imaging_type,ind,options);
within_headers=network_names;
[u,nu,ix,nix]=find_uniques(within_headers);

%% Make colormap if 3D
if ispconn
    parcel = network_network_as_parcel(parcel,imaging_type,ind,options);
end


%% Read indices
[x, ix_cat, C,ix_tick,xlab,networks] = parcel_to_ix_sorted(parcel);