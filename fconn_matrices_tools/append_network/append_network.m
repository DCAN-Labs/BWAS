function newParcel = append_network(parent_parcel,roi_names,roi_network_assignment,network_name_to_delete)

%% Oscar Miranda-Dominguez
% First line of code: July 22, 2020

%% This function append networks to an existing parcel


%% 
if nargin>4
    network_name_to_delete='nothing here';
end
%% List network names
% names=cat(1,parent_parcel.name);
names=cellfun(@cellstr,{parent_parcel.name});

% find ix to kill
ix=contains(cellstr(names),network_name_to_delete);
newParcel=parent_parcel;
newParcel(ix)=[];
%%
%%
[new_networks IX]=unique(roi_network_assignment.Network,'rows');
n_new_networks=size(new_networks,1);
shortnames=roi_network_assignment.shortname(IX,:);
for i=1:n_new_networks
    ix_roi_names=ismember(roi_network_assignment{:,2},new_networks(i,:),'rows');
    local_roi_names=roi_network_assignment{ix_roi_names,1};
    n_local_roi_names=size(local_roi_names,1);
    IX=nan(n_local_roi_names,1);
    for j=1:n_local_roi_names
        IX(j)=find(ismember(roi_names{:,1},local_roi_names(j,:),'rows'));
    end
    newParcel(end+1).name=new_networks(i,:);
    newParcel(end).shortname=shortnames(i,:);
    newParcel(end).ix=IX;
    newParcel(end).n=numel(IX);
    newParcel(end).RGB=[0 0 0];
end
