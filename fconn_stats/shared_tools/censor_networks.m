function ix=censor_networks(network_names,parcel,imaging_type,options)
if isfield(options,'resort_parcel_order')
    temp_ix=options.resort_parcel_order;
else
    temp_ix=1:size(parcel,2);
end
if isempty (temp_ix)
    temp_ix=1:size(parcel,2);
end

%%
to_include=cellstr(cat(1,parcel(temp_ix).shortname));
m=size(to_include,1);
if strcmp(imaging_type,'3D')
    G=cell(m);
    for i=1:m
        for j=1:m
            G{i,j}=[to_include{i} ' and ' to_include{j}];
        end
    end
    network_names_to_include=G;
else
    network_names_to_include=to_include;
end

if options.symmetrize==1
    network_names_to_include=table(network_names_to_include(:));
    network_names_to_include = sort_network_network_names(network_names_to_include);
    network_names_to_include=unique(network_names_to_include);
    network_names_to_include=table2cell(network_names_to_include);
end
%%
ix = contains(network_names{:,1},network_names_to_include(:));

