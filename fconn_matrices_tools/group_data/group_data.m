function data=group_data(M,t1,within_headers)

%% Oscar Miranda Dominguez
% x: input matrix
% t1: x axis grouping
% within: y axis grouping

%% Find uniques

[xu,xnu,xix]=find_uniques(t1);
[yu,ynu,yix]=find_uniques(within_headers);
n=xnu*ynu;
data=cell(n,1);
k=0;

%% offset
xx=M;
xx=xx-min(M(:))+1;% translating before transforming

%% encapsulate
for i=1:xnu
    for j=i:ynu
        k=k+1;
        local_data=xx(xix{i},yix{j});
        data{k}=local_data(:);
    end
end
