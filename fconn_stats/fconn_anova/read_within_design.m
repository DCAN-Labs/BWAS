function [X, unique_within_subgroups]=read_within_design(within_design,x)

ng=size(within_design,2);
if ng==1 % to preserve compatibility
    % Check errors in indexing
    for i=1:ng
        nsg=size(within_design(i).subgroups,2);
        X=cell(nsg,1);
        
        for j=1:nsg
            X{j}=x(within_design(i).subgroups(j).ix,:);
        end
        
    end
end

if nargout>1
    [r,c]=size(x);
    
    if ng>1
        R=zeros(ng,r);
        for i=1:ng
            nsg=size(within_design(i).subgroups,2);
            for j=1:nsg
                R(i,within_design(i).subgroups(j).ix)=j;
            end
        end
    end
    unique_within_subgroups=unique(R','rows')';
    n_unique_within_subgroups=length(unique_within_subgroups);
    X=cell(n_unique_within_subgroups,1);
    
    for j=1:n_unique_within_subgroups
        local_ix=find(ismember(R',unique_within_subgroups(:,j)','rows')');
        X{j}=x(local_ix,:);
        
    end
end