function [net_mat, net_num, LUT]=get_net_mat(network)


n=size(network,1);
net_names=unique(network,'stable');
n_net=size(net_names,1);

foo=2;
p=2;
while length(p)<n_net
    foo=foo+1;
    p = primes(foo);
end


net_mat=cell(n);
net_num=zeros(n);

for i=1:n
    for j=1:n
        net_mat(i,j)={[network{i} ' and ' network{j}]};
        f1=ismember(net_names,network{i});
        f2=ismember(net_names,network{j});
        net_num(i,j)=p(f1)*p(f2);
    end
end


n_LUT=n_net*(n_net+1)/2;
LUT(n_LUT).ix=[];
LUT(n_LUT).net1=[];
LUT(n_LUT).net2=[];
LUT(n_LUT).networks=[];

k=0;
for i=1:n_net
    for j=i:n_net
        k=k+1;
        LUT(k).ix=p(i)*p(j);
        LUT(k).net1=net_names{i};
        LUT(k).net2=net_names{j};
        LUT(k).networks=[net_names{i} ' and ' net_names{j}];
    end
end

