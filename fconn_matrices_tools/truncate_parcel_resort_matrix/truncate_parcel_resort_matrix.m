function [newM, newParcel]=truncate_parcel_resort_matrix(M,parcel,ix_networks_to_remove)

%% function [newM, newParcel]=truncate_parcel_resort_matrix(M,parcel,ix_networks_to_remove)
%
% This function removes unwanted systems and resort connectivity matrices
% accordingly.
%
% *Inputs* (all are mandatory):
%
% * M, original connectivity matrix
% * parcel, original parcellation schema
% * ix_networks_to_remove, which parcels' indices to remove
%
% * Outputs*
% * newM, resorted connectivity matrix containing only the required
% networks
% * newParcel, new parcelation schema with the reassigned indices
%% Credit
%
% Oscar Miranda-Dominguez
% First line of code: May 24, 2019
%% making sure direction of roi indices are ok
% First enforcing consistent direction of the indices for each functional
% system
n=size(parcel,2);
for i=1:n
    parcel(i).ix=parcel(i).ix(:);
end

%% Get the networks to keep
ix_networks_to_keep=1:n;
ix_networks_to_keep=find(~ismember(ix_networks_to_keep,ix_networks_to_remove));
%% Get ROIs to keep

ix=cat(1,parcel(ix_networks_to_keep).ix);
%% Get truncated matrix
newM=M(ix,ix,:);

%% Get truncated parcel
truncated_parcel=parcel(ix_networks_to_keep);
offset=0;

for i=1:length(truncated_parcel)
    truncated_parcel(i).ix=[1:truncated_parcel(i).n]'+offset;
    offset=truncated_parcel(i).ix(end);   
end
newParcel=truncated_parcel;
%%
