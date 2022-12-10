function h=showM(M,varargin)

%% Oscar Miranda-Dominguez
% First line of code: July 5, 2018
% dependancies:
% C:\Users\Oscar\Box Sync\from_dropbox\Postdoc\Oregon\Work\Grants\U_movement_disorders_Fay\prelim_analysis\fconn_anova\debug_code\fconn_anovan\set_axis_label.m
% C:\Users\mirandad\Box Sync\matlab\development\plotting\showM\showM.m
%% THis function can be used to show connectivity matrices.
% It uses different color scales for positive and negative numbers

%% Read internal variables
[n1, n2, n3]=size(M);
if n3>1
    error('This function only works for 2D square arrays');
end
if n1~=n2
    error('This function only works for 2D square arrays');
end
%% Define and assign default options |
% these variables can be used as input using paired arguments
% showM(randn(94))
% showM(randn(94),'clims',[-.2 1])

% default color limits
clims=[min(M(:)) max(M(:))];

% default parcel
parcel=[];

% font size axis
fs_axis=9;

% fig background color
fig_color=[1 1 1];

% fig size wide
fig_wide=6;

% fig size tall
fig_tall=7;

% one_side_labels
one_side_labels=0;

% ticks for axis
ticks=n1;

% line_width to separate parcels
lw=1;

% which half to show
half='both';

% line_color to separate parcels
line_color=[1 1 1];

% define colormap
my_color='RB';

% show dividers
show_dividers=1;

% force diagonal to be zero flag
force_diag_to_be_zero_flag=1;

% parcel pairs to show
mask_parcel_pairs_flag=0;
%% internal variables
% default ix
ix=1:n1;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'parcel'
            parcel=varargin{q+1};
            %enforcing consistent direction of the indices for each
            %functional system
            n=size(parcel,2);
            for i=1:n
                parcel(i).ix=parcel(i).ix(:);
            end
            clear n i
            ix=cat(1,parcel.ix);
            if length(ix)~=n1
                error(['structure parcel has ' num2str(length(ix)) ' unique rois, provided matrix has ' num2str(n1) '. number of ROIs has to be the same'])
            end
            
            ticks=cat(1,parcel.n);
            ticks=cumsum(ticks);
            
            q = q+1;
            
        case 'line_width'
            lw=varargin{q+1};
            q = q+1;
            
        case 'clims'
            clims=varargin{q+1};
            q = q+1;
            
        case 'line_color'
            line_color=varargin{q+1};
            q = q+1;
            
        case 'half'
            half=varargin{q+1};
            q = q+1;
            
        case 'one_side_labels'
            one_side_labels=varargin{q+1};
            q = q+1;
            
        case 'my_color'
            my_color=varargin{q+1};
            q = q+1;
            
        case 'fig_tall'
            fig_tall=varargin{q+1};
            q = q+1;
            
        case 'fig_wide'
            fig_wide=varargin{q+1};
            q = q+1;
            
        case 'fs_axis'
            fs_axis=varargin{q+1};
            q = q+1;
            
        case 'show_dividers'
            show_dividers=varargin{q+1};
            show_dividers=show_dividers==1;
            q = q+1;
            
        case 'fig_color'
            fig_color=varargin{q+1};
            q = q+1;
            
        case 'ix_parcel_pairs_on'
            ix_parcel_pairs_on=varargin{q+1};
            q = q+1;
            [r, c]=size(ix_parcel_pairs_on);
            if c~=2
                error('check ix_parcel_pairs_on. Rows and 2 columns is the expected size')
            end
            mask_parcel_pairs_flag=1;
            
        case 'force_diag_to_be_zero_flag'
            force_diag_to_be_zero_flag=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
force_diag_to_be_zero_flag=force_diag_to_be_zero_flag==1;
%% Start making the figure

h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);
%%

main_pos=[.15 .19 .72 .72];
if ~strcmp(half,'both')
    main_pos=[.15 .25 .72 .72];
end

if strcmp(half,'up')
    main_pos=[.15 .15 .72 .72];
end
s1=subplot('position',main_pos);
% subplot('position',[.05 .105 .9 .9])

% clims=prctile(M(:),[delta 100-delta]);
% clims=([-1 1]);
local_M=M(ix,ix);

I=eye(size(local_M));

if force_diag_to_be_zero_flag==1
    local_M(I==1)=0;
end
% local_mask=ones(size(local_M));
switch half
    case 'both'
    case 'up'
        %         local_mask=local_mask.*triu(local_M);
        local_M=triu(local_M);
    case 'low'
        %         local_mask=local_mask.*tril(local_M);
        local_M=tril(local_M);
end
% local_M=local_M.*local_mask;

% prep mask to hide unwanted systems
if mask_parcel_pairs_flag==1
    mask=local_M*0;
    for i=1:r
        IX1=parcel(ix_parcel_pairs_on(i,1)).ix;
        IX2=parcel(ix_parcel_pairs_on(i,2)).ix;
        mask(IX1,IX2)=1;
        mask(IX2,IX1)=1;
    end
else
    mask=ones(size(local_M));
end
%
imagesc(local_M.*mask,clims);
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);

axis square


pos=[0 ticks'];

for i=1:length(parcel)
    %     offsetx=(-50-ticks(end))*rem(i,2);
    %     offsety=(-50-ticks(end))*rem(i,2);
    %
    offsetx=(-n1/5.5-ticks(end))*rem(i,2);
    offsety=(-n1/5.5-ticks(end))*rem(i,2);
    
    if one_side_labels==1
        offsetx=(-n1/7-ticks(end));
        offsety=(-n1/7-ticks(end));
    end
    if ~strcmp(half,'both')
        offsety=0;
    end
    if strcmp(half,'up')
        offsetx=0;
        offsety=-n1*1.15;
    end
    
    if show_dividers==1
        line([-1 ticks(end)+1],ticks([i i])+.5,'color',line_color,'linewidth',lw)
        line(ticks([i i])+.5,[-1 ticks(end)+1],'color',line_color,'linewidth',lw)
    end
    
    
    
    %     text(offsetx+ticks(end)+4,diff(pos([i i+1]))/2+pos(i),parcel(i).shortname,...
    %         'horizontalAlignment','left',...
    %         'fontsize',fs_axis)
    %     text(diff(pos([i i+1]))/2+pos(i),ticks(end)+25+offsety,parcel(i).shortname,...
    %         'horizontalAlignment','center',...
    %         'VerticalAlignment','middle',...
    %         'rotation',90,...
    %         'fontsize',fs_axis)
    
    text(offsetx+ticks(end)+n1/88,diff(pos([i i+1]))/2+pos(i),parcel(i).shortname,...
        'horizontalAlignment','left',...
        'fontsize',fs_axis)
    text(diff(pos([i i+1]))/2+pos(i),ticks(end)+n1/12+offsety,parcel(i).shortname,...
        'horizontalAlignment','center',...
        'VerticalAlignment','middle',...
        'rotation',90,...
        'fontsize',fs_axis)
end

switch half
    case 'up'
        x=[1 n1 1];
        y=[1 n1 n1];
        patch(x,y,'w',...
            'FaceColor','w')
        %          box off
        
    case 'low'
        
        x=[1-10 n1+10 n1+10];
        y=[1-10 n1+10 1-10];
        patch(x,y,'w',...
            'FaceColor','w')
        box off
        line([n1 n1]+.5,[1 n1 ],'color','w','linewidth',1)
end

%% Show bar
pos=get(gca,'position');


pos(4)=.025;
if one_side_labels==1
    pos(2)=pos(2)-1.5*pos(4);
else
    pos(2)=.075;
end
if ~strcmp(half,'both')
    pos(2)=.075;
end

subplot('position',pos)
y_bar=linspace(min(clims(:)),max(clims(:)),64)';
if sum(M(:)==0)>0
    [foo local_ix]=min(abs(y_bar));
    y_bar(local_ix)=0;
end



imagesc(y_bar,[],y_bar')

set(gca,'ytick',[])
set(gca,'xaxislocation','top')
set(gca,'xaxislocation','bottom')

xl=get(gca,'xtick');
set(gca,'xtick',xl);
try
    axis_label=set_axis_label(xl);
    set(gca,'Xticklabel',axis_label)
end

set(gca,'ydir','normal')
% set(gca,'fontsize',fs_axis)
%% colormap

sum_clims=sum(sign(clims));

if sum_clims<0
    cmap='neg';
end

if sum_clims==0
    cmap='bot';
end

if sum_clims>0
    cmap='pos';
end


nbins=64;
ix=1:nbins;
y_ix=linspace(clims(1),clims(2),nbins);
y_ix=y_bar;% added Jan 31, 2019

switch my_color
    case 'RB'
        
        neg_map=[250 250 250
            247,251,255
            222,235,247
            198,219,239
            158,202,225
            107,174,214
            66,146,198
            33,113,181
            8,81,156
            8,48,107]/255;
        neg_map=neg_map(end:-1:1,:);
        
        pos_map=[250 250 250
            255,245,240
            254,224,210
            252,187,161
            252,146,114
            251,106,74
            239,59,44
            203,24,29
            165,15,21
            103,0,13]/255;
        
    case 'RYB'
        
        neg_map=[254 254 254
            250 250 250
            255,255,217
            237,248,177
            199,233,180
            127,205,187
            65,182,196
            29,145,192
            34,94,168
            37,52,148
            8,29,88]/255;
        neg_map=neg_map(end:-1:1,:);
        
        pos_map=[250 250 250
            255,245,240
            254,224,210
            252,187,161
            252,146,114
            251,106,74
            239,59,44
            203,24,29
            165,15,21
            103,0,13]/255;
        
        
    case 'RG'
        neg_map=[250 250 250
            255,255,191
            217,239,139
            166,217,106
            102,189,99
            26,152,80
            0,104,55]/255;
        neg_map=neg_map(end:-1:1,:);
        
        pos_map=[165,0,38
            215,48,39
            244,109,67
            253,174,97
            254,224,139
            250 250 250]/255;
        pos_map=pos_map(end:-1:1,:);
        
        
        
end






foo=jet(300);
% neg_map=foo(1:120,:);
% pos_map=foo(180:end,:);


n_neg_map=size(neg_map,1);


n_pos_map=size(pos_map,1);

local_colormap=zeros(nbins,3);



switch cmap
    case 'neg'
        temp_map=neg_map;
    case 'pos'
        temp_map=pos_map;
    case 'bot'
        temp_map=[neg_map;pos_map];
        if find(y_ix==0)
            temp_map=[neg_map;1 1 1;pos_map];
        end
end

n_neg=sum(y_ix<0);
n_pos=sum(y_ix>0);
% nbins_temp_map=size(temp_map,1);



for i=1:3
    local_colormap(1:n_neg,i)=interp1(linspace(0,1,n_neg_map),temp_map(1:n_neg_map,i),linspace(0,1,n_neg),'spline');
    local_colormap(end-n_pos+1:1:end,i)=interp1(linspace(0,1,n_pos_map),temp_map(end-n_pos_map+1:end,i),linspace(0,1,n_pos),'spline');
end
if n_neg+n_pos<nbins
    local_colormap(n_neg+1,:)=temp_map(round(end/2),:);
end
local_colormap(local_colormap>1)=sign(local_colormap(local_colormap>1)); % controling for values > 1 or <-1
local_colormap(local_colormap<0)=0;

colormap(local_colormap)

subplot(s1)