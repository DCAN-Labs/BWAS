function [meanM,IX,unique_names]=wrapper_showM_given_between_within(M,parcel,between_design,within_design,varargin)

%% Define defauilts

%symmetrize flag
sym_flag=1;
%% Read extra options
v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'environment'
            environment=varargin{q+1};
            q = q+1;
            
        case 'sym_flag'
            sym_flag=varargin{q+1};
            q = q+1;
    end
    q = q+1;
end
sym_flag=sym_flag==1;
%% symmetrize, if asked
if sym_flag
    M=symmetryze_M(M);
end
%% Get groups and indices
T1=tablify_design(between_design);
T2=tablify_design(within_design);
T=fuse_tablified_designs(T1,T2);
[IX,unique_names]=grupify_T(T);
%% Calculate mean fconn
r=size(M,1);
n=size(IX,1);
meanM=zeros(r,r,n+1);
unique_names{n+1}='all';
for i=1:n
    meanM(:,:,i)=get_mean_M(M(:,:,IX{i}),environment);
end
meanM(:,:,end)=get_mean_M(M,environment);
1
%% Read
%%
close all
delta=.01;
delta=2.5;
clims=get_ptiles_M(meanM(:,:,end),delta);
clims=get_ptiles_M(M,delta)
% clims=get_ptiles_M(meanM,delta);
clims=min(abs(clims))*sign(clims);
% clims=[-1 1]*.12;
clims=[-.09 .095];

fig_wide=6.9;
fig_tall=6.5;

for i=1:n+1
    showM(meanM(:,:,i),'parcel',parcel,...
        'one_side_labels',1,...
        'my_color','RG',...
        'line_width',0.5,...
        'line_color',[1 1 1]*0,...
        'clims',clims,...
        'fig_wide',fig_wide);
    cmap=colormap;
    colormap(cmap(end:-1:1,:))
    tit=unique_names{i};
    tit=strrep( tit , '_' , ' ' );
    
    fig_name=[unique_names{i}];
    saveas(gcf,fig_name)
    img = getframe(gcf);
    imwrite(img.cdata, [fig_name, '.png']);
    %     colormap parula
    
    %     title(tit)
end