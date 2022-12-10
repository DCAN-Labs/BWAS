function sym_M=symmetryze_M(M)
%% sym_M=symmetryze_M(M)
% This function calculaye the symmetrizes fconn

[r,c,n]=size(M);
sym_M=M;
for i=1:n
    local_M=squeeze(M(:,:,i));
    sym_M(:,:,i)=(local_M+local_M')/2;
end
