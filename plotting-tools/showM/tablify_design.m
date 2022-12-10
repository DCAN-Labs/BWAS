function T=tablify_design(between_design)
N=size(between_design,1);

n_subgroups=size(between_design(1).subgroups,2);
ix=cell(n_subgroups,1);
name=cell(n_subgroups,1);
n=zeros(n_subgroups,1);
for i=1:n_subgroups
    ix{i}=between_design(1).subgroups(i).ix;
    n(i)=numel(ix{i});
    name{i}=repmat(between_design(1).subgroups(i).name,n(i),1);
end
ix=cat(2,ix{:})';
name=cat(1,name{:});
T=table(name,ix);