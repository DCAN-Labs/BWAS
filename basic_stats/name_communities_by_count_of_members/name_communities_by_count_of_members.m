function idx = name_commuinities_by_count_of_members(unsorted_community)

% This function takes as input a vector of communities and assign the name
% of community one to the largest community. Community 2 is the community
% in the second place by members and so on
n=size(unsorted_community);
idx=nan(n);

[u,nu,ix,nix]=find_uniques(unsorted_community);

[ix_sorted, j]=sort(nix,'descend');

for i=1:nu
    k=j(i);
    idx(ix{k})=i;
end