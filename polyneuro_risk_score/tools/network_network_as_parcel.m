function parcel_network_network = network_network_as_parcel(parcel,imaging_type,ind,options)

network_names=get_network_names(parcel,imaging_type,ind,options);
within_headers=network_names;
[u,nu,ix,nix]=find_uniques(within_headers);

if strcmp(imaging_type,'3D')
    
    % original color assignment
    %     RGB=[166,206,227
    %         31,120,180
    %         178,223,138
    %         51,160,44
    %         251,154,153
    %         227,26,28
    %         253,191,111
    %         255,127,0
    %         202,178,214
    %         106,61,154
    %         255,255,153
    %         177,89,40]/255;
    %     RGB=repmat(RGB,ceil(nu/size(RGB,1)),1);
    %     RGB(nu+1:end,:)=[];
    
    n=size(u,1);
    RGB=zeros(n,3);
    for i=1:n
        local_network_network_name=u{i,:};
        RGB(i,:) = get_RGB_from_2_networks(parcel,local_network_network_name);
    end
    
    shortname=u;
    
    
    
    
    parcel_network_network=[shortname table(RGB) table(ix) table(nix)];
    parcel_network_network.Properties.VariableNames{1}='shortname';
    parcel_network_network.Properties.VariableNames{end}='n';
    parcel_network_network=[shortname parcel_network_network];
    parcel_network_network.Properties.VariableNames{1}='name';
    parcel_network_network=table2struct(parcel_network_network);
end
parcel_network_network=parcel_network_network';