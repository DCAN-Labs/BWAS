function [network_names, row , col]=get_network_names(parcel,imaging_type,ind,options)

m=sum(cat(1,parcel.n));
sz=m;
within_headers=cell(m,1);
n_networks=size(parcel,2);
for i=1:n_networks
    local_ix=parcel(i).ix;
    local_name=parcel(i).shortname;
    local_n=parcel(i).n;
    within_headers(local_ix)=repmat({local_name},local_n,1);
    network_names=within_headers;
end

if strcmp(imaging_type,'3D')
    G=cell(m);
    for i=1:m
        for j=1:m
            G{i,j}=[within_headers{i} ' and ' within_headers{j}];
        end
    end
    
    network_names=G(ind);
    sz=[m m];
    
end


network_names=table(network_names);

%% Removing numerical entries
network_names(cellfun(@isnumeric,network_names{:,1}),:)=[];
%%

if options.symmetrize==1
    network_names = sort_network_network_names(network_names);
end

%% Messing with ROIs

[ row , col ] = ind2sub( sz , ind );

if strcmp(imaging_type,'2D')
    col(:)=nan;
end
end

