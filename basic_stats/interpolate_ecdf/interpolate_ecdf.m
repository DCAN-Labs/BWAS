function [fi, xi]=interpolate_ecdf(X,n_dots)
%% Oscar Miranda-Dominguez
% Use this function to interpolate scores from ecdf

if nargin<2
    n_dots=100;
end

int_method='linear';
[f,x] = ecdf(X);
f(1)=[];
x(1)=[];
xi=linspace(x(1),x(end),n_dots);
fi=interp1(x,f,xi,...
    int_method);