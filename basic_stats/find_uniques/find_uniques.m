function [u,nu,ix,nix]=find_uniques(data)


%% Oscar Miranda-Dominguez
% First line of code Nov 6,2020

%%
[u,ia,ic] =unique(data,'rows');
nu=size(u,1);
ix=cell(nu,1);
nix=nan(nu,1);
for i=1:nu
%     
    ix{i}=find(ic==i);
    nix(i)=numel(ix{i});
end