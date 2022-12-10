function [C, V] = T_to_C_V(T)

cat_names=[T{:,1}; T{:,2}];
[u,nu,ix,nix]=find_uniques(cat_names);

C=nan(nu);
V=nan(nu);

n=size(T,1);
for i=1:n
    j=find(ismember(u,T{i,1}));
    k=find(ismember(u,T{i,2}));
    C(j,k)=T{i,3};
    V(j,k)=T{i,4};
    
    C(k,j)=T{i,3};
    V(k,j)=T{i,4};
end

C=array2table(C);
V=array2table(V);

C.Properties.VariableNames=u;
C.Properties.RowNames=u;

V.Properties.VariableNames=u;
V.Properties.RowNames=u;