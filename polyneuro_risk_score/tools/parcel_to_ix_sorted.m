function [x, ix_cat, C,ix_tick,xlab,networks] = parcel_to_ix_sorted(parcel)
%%
N=numel(parcel);
ix_cat=cat(1,parcel.ix);
n=numel(ix_cat);
x=1:n;
C=zeros(n,3);
xlab=cell(N,1);
networks=cell(n,1);
offset=0;
for i=1:N
    C(parcel(i).ix,:)=repmat(parcel(i).RGB,parcel(i).n,1);
    xlab{i}=parcel(i).shortname;
    networks(parcel(i).ix)=repmat({parcel(i).shortname},parcel(i).n,1);
end

%% Remove empty spaces
to_kill=cellfun(@isempty,networks);
C(to_kill,:)=[];
networks(to_kill)=[];
%%
ix_tick=cat(1,parcel.n);
offset=ix_tick/2;
ix_tick=cumsum(ix_tick)-offset;