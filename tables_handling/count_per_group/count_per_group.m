function t=count_per_group(T,header)
%%
% Oscar Miranda-Dominguez
% First line of code: Nov 6, 2019
%%
all=T.Properties.VariableNames;
ix=find(ismember(all,header));


names=T{:,ix};
unique_names=unique(names,'rows');
if ~iscell(unique_names)
    unique_names=cellstr(unique_names);
end
n_unique_names=size(unique_names,1);

N=zeros(n_unique_names,1);
for k=1:n_unique_names
    N(k)=sum(ismember(names,unique_names(k,1)));
end


t=table(unique_names,N);
t(end+1,1)={'all'};
t{end,2}=sum(N);

