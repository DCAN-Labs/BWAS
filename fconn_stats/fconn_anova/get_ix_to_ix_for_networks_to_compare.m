function to_use = get_ix_to_ix_for_networks_to_compare(parcel,paired_networks)
%% Oscar Miranda Dominguez
% First line of code, Feb 23, 2018

% paired networks needs to be a nx2 matrix where each column indicates the
% networks you will compare
%%
% paired_networks=[2 7;2 2; 7 7];
% paired_networks=[2 7];

paired_networks=paired_networks';

[r,c]=size(paired_networks);
n=zeros(c,1);
to_use=cell(c,1);
for i=1:c
    n1=parcel(paired_networks(1,i)).n;
    n2=parcel(paired_networks(2,i)).n;
    n(i)=n1*n2;
    
    ix1=parcel(paired_networks(1,i)).ix;
    ix2=parcel(paired_networks(2,i)).ix;
    
    local_to_use=zeros(2,n(i));
    m=0;
    for j=1:n1
        for k=1:n2
            m=m+1;
            local_to_use(:,m)=[ix1(j);ix2(k)];
        end
    end
    to_use{i}=local_to_use;
end
to_use=cat(2,to_use{:});
%% 