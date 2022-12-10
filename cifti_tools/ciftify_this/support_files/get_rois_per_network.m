function parcel = get_rois_per_network(parcellation)
% parcellation=gordon_network;
dummy=char(parcellation);
[unique_network]=unique(dummy(:,3:end),'rows');
n_unique_network=size(unique_network,1);
parcel(n_unique_network).name=[];
parcel(n_unique_network).shortname=[];
parcel(n_unique_network).ix=[];
parcel(n_unique_network).n=[];
for i=1:n_unique_network
    long=strtrim(unique_network(i,:));
    parcel(i).name=long;
    parcel(i).shortname=get_short(long);
    parcel(i).ix=find(ismember(dummy(:,3:end),parcel(i).name,'rows'));
    parcel(i).n=length(parcel(i).ix);
end

function short=get_short(long)
switch long
    case 'auditory'
        short='Aud';
    case 'default mode'
        short='Def';
    case 'dorsal attention'
        short='DoA';
    case 'insular-opercular'
        short='InO';
    case 'limbic'
        short='Lmb';
    case 'somatomotor'
        short='SoM';
    case 'unknown'
        short='Non';
    case 'visual'
        short='Vis';
    otherwise
        short='xxx';
        
end
