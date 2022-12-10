function Mrandom = make_random_copy_model_based(M,rep,iter,bins)
if nargin < 4
    bins=20;
end

if nargin < 3
    iter=1;
end
if nargin < 2
    rep=500;
end


MM=zeros(bins,bins,rep);

for i=1:rep
    dummy = randmio_und(M, iter);
    MM(:,:,i)=complete_sort_sort_matrix(dummy,bins,0);
end
Mrandom=mean(MM,3);