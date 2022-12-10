function parcel = parcel_table2str(T)

name=unique(T.name,'rows');

n_parcels=size(name,1);
parcel(n_parcels).name=[];
parcel(n_parcels).shortname=[];
parcel(n_parcels).ix=[];
parcel(n_parcels).n=[];
parcel(n_parcels).RGB=[];

%%
for i=1:n_parcels
    local_name=name(i,:);
    ix=find(ismember(T.name,local_name,'rows'));
    parcel(i).name=T.name(ix(1),:);
    parcel(i).shortname=T.shortname(ix(1),:);
    
    parcel(i).ix=T.ix(ix);
    parcel(i).n=numel(ix);
    
    parcel(i).RGB=[T.R(ix(1)) T.G(ix(1)) T.B(ix(1))];
end