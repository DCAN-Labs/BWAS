function RGB = get_RGB_from_2_networks(parcel,local_network_network_name)

%% split name
delimiter= ' and ';
newStr = split(local_network_network_name,delimiter);
n=numel(newStr);

raw_RGB=zeros(n,3);
N=zeros(n,1);

for i=1:n
    ix=find(ismember(cat(1,parcel.shortname),newStr{i},'rows'));
    raw_RGB(i,:)=parcel(ix).RGB;
    N(i)=parcel(ix).n;
end
% RGB=mean(raw_RGB);
RGB=(raw_RGB(1,:)*N(2)+raw_RGB(2,:)*N(1))/sum(N);
