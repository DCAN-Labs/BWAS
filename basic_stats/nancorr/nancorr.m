function R = nancorr(X,Y)

%% Oscar Miranda-Dominguez

% First line of code: Oct 14, 2021
% 
r=size(X,2);
c=size(Y,2);

R=nan(r,c);
for i=1:r
    x=X(:,i);
    ix1=~isnan(x);
    for j=1:c
        y=Y(:,j);
        ix2=~isnan(y);
        ix=and(ix1,ix2);
        x_nonans=x(ix);
        y_nonans=y(ix);
        R(i,j)=corr(x_nonans,y_nonans);
    end
end