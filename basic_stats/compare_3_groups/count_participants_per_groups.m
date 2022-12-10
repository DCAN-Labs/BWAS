function [n, group_names]=count_participants_per_groups(T,ix)

[r,c]=size(T);
if nargin<2
    ix=c-1;
end


all=T{:,ix};
group_names=unique(all,'rows');
n_groups=size(group_names,1);

n=zeros(n_groups,1);

for i=1:n_groups
    n(i)=sum(ismember(all,group_names(i,:),'rows'));
end