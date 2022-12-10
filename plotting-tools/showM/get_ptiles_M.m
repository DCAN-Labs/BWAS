function clims=get_ptiles_M(M,delta)
%% function clims=get_ptiles_M(M,delta)

% This function takes as input cat matrices and get the limits for
% coloring. delta indicates the % to be removed from each edge. If provided
% as scalar, it removes the same fraction from each edge. If proveded as a
% 2-elements vector, it removes edges from the negative and positive sides
%%

[n_rois,n_rois,n]=size(M);
%% get the indices from only one half
mask=tril(M(:,:,1));
mask=mask.*(~eye(n_rois));
mask=mask~=0;
n_surv=sum(mask(:));

%% 
unique_fconn=zeros(n_surv,n);
for i=1:n
    tempM=squeeze(M(:,:,i));
    unique_fconn(:,i)=tempM(mask);
end
%% 

n_edges=numel(delta);
if n_edges==1
   delta=delta([1 1]);
end

clims=prctile(unique_fconn(:),[delta(1) 100-delta(2)]);
