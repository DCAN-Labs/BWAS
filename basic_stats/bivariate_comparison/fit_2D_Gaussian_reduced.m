function [cost, fit_data]=fit_2D_Gaussian_reduced(x,M,mu)
% x is the vector of parameters to be optimized in fminsearch
% M is the matrix having the raw data
m1=mu(1);
m2=mu(2);
s1=x(1);
s2=x(2);
r=x(3);

[n1, n2]=size(M);
fit_data=zeros(n1,n2);

x1=linspace(0,1,2*n1+1);
x2=linspace(0,1,2*n2+1);
x1=x1(2:2:end);
x2=x2(2:2:end);

sr=sqrt(1-r^2);
d=2*pi*s1*s2*sr;
c=-1/(2*sr^2);

for i=1:n1
    for j=1:n2
        Q=((x1(i)-m1)/s1)^2+((x2(j)-m2)/s2)^2-2*r*((x1(i)-m1)/s1)*((x2(j)-m2)/s2);
        fit_data(i,j)=exp(c*Q);
    end
end
fit_data=fit_data/d;
fit_data=fit_data/sum(fit_data(:));
%     imagesc(fit_data)

% cost=sum(sum(abs(M-fit_data)));

% cost=norm(M-fit_data);

% cost=abs(M-fit_data).*M;
% cost(isnan(cost))=0;
% cost=sum(cost(:));
% pause()

% cost=(M-fit_data)./M;
cost=(M-fit_data).*M.^1;
cost=sum(cost(:).^2);
% cost=sum(sum(abs(cost)));