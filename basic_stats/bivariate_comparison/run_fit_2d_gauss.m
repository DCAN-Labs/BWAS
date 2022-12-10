function x = run_fit_2d_gauss(M)
%% 
M=M/sum(M(:)); % Matrix normalization
%% Finding the means 
ix=find(M==max(M(:))); 
[n1, n2]=size(M);
[i, j]=ind2sub([n1 n2], ix);
x1=linspace(0,1,2*n1+1);
x2=linspace(0,1,2*n2+1);
x1=x1(2:2:end);
x2=x2(2:2:end);

%% Brute force parameter exploration to find IF for fminsearch
m1=mean(x1(i));
m2=mean(x2(j));
% x=[m1 m2 s1 s2 r];
n=31;
cost=zeros([n n n]);
s1c=linspace(0,1,n);
s2c=linspace(0,1,n);
rc=linspace(-1,1,n);

for i=1:n
    for j=1:n
        for k=1:n
            x=[m1 m2 s1c(i) s2c(j) rc(k)];
            cost(i,j,k)=fit_2D_Gaussian(x,M);
        end
    end
end
%
ix=find(cost==min(cost(:)),1);
[i, j, k]=ind2sub([n n n],ix);
x=[m1 m2 s1c(i) s2c(j) rc(k)];
% [cost, fit_data]=fit_2D_Gaussian(x,M);

% subplot 121
% imagesc(M)
% 
% subplot 122
% imagesc(fit_data)
%% Run fminsearch to improve the estimations
% options=[];
options=optimset('MaxFunEvals',9e16,'MaxIter',9e16);
% fitfun=@fit_2D_Gaussian;
fitfun=@fit_2D_Gaussian_reduced;
% tic
% for k=1:50
mu=[m1 m2];
y=[s1c(i) s2c(j) rc(k)];
% y=fminsearch(fitfun,y,options,M,mu);
% Here checks that fminsearch provide values with std between 0 1nd 1, and
% correlations between -1 1 1. If not, then use the brut force estimation
ym=[0 0 -1];
yM=[1 1 1];
y=fminsearchbnd(fitfun,y,ym,yM,options,M,mu);
% if sum([y>=ym  y<=yM])==6
    x=[m1 m2 y];
% end
% end
% toc

% [cost, fit_data]=fit_2D_Gaussian_reduced(x,M,mu);
% x
% subplot 121
% imagesc(M)
% 
% subplot 122
% imagesc(fit_data)
% x