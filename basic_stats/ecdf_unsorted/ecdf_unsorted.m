function F_unsorted=ecdf_unsorted(Y)
%% Oscar Miranda-Domimguez
% First line of code: Dec 26, 2020
% ecdf reports sorted results. THis function reports scores as X is
% presented

%%
X=Y(:);
sz=size(Y);
F_unsorted=nan(sz);
%% sort data
[b, ix]=sort(X);
[~,j] = sort(ix);

%%
[f2,x2] = ecdf(b);
f2(1)=[];
x2(1)=[];
f_unsorted=f2(j);
F_unsorted(:)=f_unsorted;
% x_unsorted=x2(j);
%% To validate same result
% [f1,x1] = ecdf(X)