function C=get_C_from_g(x,g,color)
n=size(x,1);

if isempty(g)
    g=repmat({'all'},n,1);
end

unique_g=unique(g);

if isempty(color)
    color=[0 0 0];
end
n_unique_g=size(unique_g,1);

C=zeros(n,3);
for k=1:n_unique_g
    ix=(ismember(g,unique_g{k}));
    C(ix,:)=repmat(color(k,:),sum(ix),1);
end

C=[C;C;C];