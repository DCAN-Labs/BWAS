function g=read_between_design(between_design,sN)

ng=size(between_design,2);
g=cell(ng,1);

% Check errors in indexing
for i=1:ng
    local_ix=cat(1,[between_design(i).subgroups.ix]);
    n=size(local_ix,2);
    nsg=size(between_design(i).subgroups,2);
    subgroups=cell(n,1);
    for j=1:nsg
        try
            subgroups(between_design(i).subgroups(j).ix)=cellstr(repmat(between_design(i).subgroups(j).name,length(between_design(i).subgroups(j).ix),1));
        catch
            subgroups(between_design(i).subgroups(j).ix)=mat2cell(repmat(between_design(i).subgroups(j).name,length(between_design(i).subgroups(j).ix),1),ones(n,1));
        end
    end
    g{i}=subgroups;
end
