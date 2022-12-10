function visualize_PLSR(X,y,n_components,varargin)

%% visualize_PLSR(X,y,n_components,varargin)
% Oscar Miranda-Dominguez
% First line of code: Aug 10, 2020
%% Define and assign default options |
% these variables can be used as input using paired arguments
% showM(randn(94))
% showM(randn(94),'clims',[-.2 1])

[Xloadings,Yloadings,Xscores,YS,BETA,PCTVAR] = plsregress(X,y,n_components);

explained_variance=PCTVAR(end,:);
[h,T]=explained_variance_plot(explained_variance);

%%
r=corr(
scatter(