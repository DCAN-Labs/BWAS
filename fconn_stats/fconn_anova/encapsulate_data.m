function data=encapsulate_data(x,t1,within)


[r, c]=size(x);

nb=size(t1,2);
nw=size(within,2);
n=nb+nw;

assign=[];

for i=1:nb
    foo=table2array(t1(:,i));
    foo=repmat(foo,1,c);
    foo=reshape(foo,r*c,1);
    assign=[assign foo];
end

for i=1:nw
    foo=table2array(within(:,i));
    if ~iscell(foo)
        foo=cellstr(foo);
    end
    foo=repmat(foo',r,1);
    foo=reshape(foo,r*c,1);
    assign=[assign foo];
end
assign=cell2mat(assign);

[C]=unique(assign,'rows');

n_unique = size(C,1);


data=cell(n_unique,1);

xx=x(:)-min(x(:))+1;% translating before transforming

for i=1:n_unique
    ix=find(ismember(assign,C(i,:),'rows'));
    data{i}=xx(ix);
end