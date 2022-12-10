function [main_table, within_headers,g] = group_ROIS(fconn,parcel,between_design,within_design,options)

%%
X=fconn;
[n,m]=size(X);
%%
Dx=cell(n,1);
c=zeros(n,3);
for i=1:size(between_design(1).subgroups,1)
    ix=between_design(1).subgroups(i).ix;
    Dx(ix)={between_design(1).subgroups(i).name};
    for j=ix
        c(j,:)=between_design(1).subgroups(i).color;
    end
    
end
Dx=char(Dx);
%%

main_table=[table(Dx) array2table(X)];
g=[main_table(:,1) array2table(c)];


within_headers=cell(m,1);
n_networks=size(parcel,2);
for i=1:n_networks
    local_ix=parcel(i).ix;
    local_name=parcel(i).shortname;
    local_n=parcel(i).n;
    within_headers(local_ix)=repmat({local_name},local_n,1);
end
within_headers=table(within_headers);
% within_headers=table(repmat({'all'},m,1));
