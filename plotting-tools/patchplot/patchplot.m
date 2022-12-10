function [xx,mx,medx,limits,local_mask]=patchplot (x,g,color_schema)
%patchplot Displays patches of multiple data samples.
%   patchplot(X) produces a patch of the data in the matrix X. On
%   each patch, the central thin mark is the median, the edges of the box are the
%   25th and 75th percentiles, the thick line is the mean value
%
%   x and g can be used as in boxplot from matlab
%
%   for its third argument, if provided, it accepts the following colormaps
%   pink
%   green
%   blue
%   black
%   orange
%
% Example 1, x=randn(500,40);patchplot(x)
% Example 2, x=randn(500,40);patchplot(x,[],'green')
% Example 3, n_unique=15;r=500;x=randn(r,1);g=randi(n_unique,r,1);patchplot(x,g,'blue')
%
% Oscar Miranda-Dominguez | Jan 2019

%% Define colormaps

if nargin <3
    color_schema='pink';
end
if isnumeric (color_schema)
    [rc, cc]=size(color_schema);
    if or(rc~=1,cc~=3)
        error('if color_schema provided as numeric, it should be a 1x3 numeric matrix corresponding to the colors to be used')
    end
    if or(min(color_schema(:))<0,max(color_schema(:))>0)
        error('color_schema should be bounded between 0 and 1')
    end
    
else
    switch color_schema
        
        case 'pink'
            my_color=[122,1,119]/255;
            
        case 'green'
            my_color=[0,68,27]/255;
            
        case 'blue'
            my_color=[37,52,148]/255;
            
        case 'black'
            my_color=[0 0 0]/255;
            
        case 'orange'
            my_color=[217,95,2]/255;
            
            
    end
    
end


%%
[r, c]=size(x);
if nargin<2
    g=repmat(1:c,r,1);
end
if isempty(g)
    g=repmat(1:c,r,1);
end

[rg,cg]=size(g);
if or(r~=rg,c~=cg)
    error('when x and r are provided, they should be of the same size')
end
%%
xx=sort(unique(g));
n_xx=size(xx,1);
mx=zeros(1,n_xx);
medx=zeros(1,n_xx);
limits=zeros(2,n_xx);

for i=1:n_xx
    local_g=xx(i);
    local_ix=find(ismember(g,local_g));
    local_data=x(local_ix);
    mx(i)=nanmean(local_data);
    medx(i)=prctile(local_data,50);
    limits(:,i)=prctile(local_data,[25 75]);
    
end
%%


% mx=nanmean(x);
% medx=prctile(x,50);
%
%
% limits=prctile(x,[25 75]);
local_mask=~isnan(mx);
local_mask=and(local_mask,~isnan(limits(1,:)));
local_mask=and(local_mask,~isnan(limits(2,:)));
local_mask=find(local_mask);
%%

lw=3;
FA=.3;
plot(xx(local_mask),medx(local_mask),'color',my_color(1,:),...
    'linewidth',lw)
hold all
patch([xx(local_mask); xx(local_mask(end:-1:1))],[limits(2,local_mask) limits(1,local_mask(end:-1:1))]',my_color(1,:),...
    'FaceColor',my_color(1,:),...
    'FaceAlpha',FA,...
    'EdgeColor',my_color(1,:))


% plot(xx(local_mask),mx(local_mask),'color',my_color(1,:),...
%     'linewidth',1)
hold off

