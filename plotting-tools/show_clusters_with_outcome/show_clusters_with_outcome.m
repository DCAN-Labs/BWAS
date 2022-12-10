function Tnorm=show_clusters_with_outcome(T,idx,...
    varargin)

%% Credits
% Oscar Miranda-Dominguez
% First line of code: Sep, 2021

%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=pwd;

% fig size wide
fig_wide=6;

% fig size tall
fig_tall=6;

% Default resolution for figure saving
res=300;

% save_flag
save_flag=1;

% title
tit='hist_communities';

% up_to_n_members
up_to_n_members=0;

% labels
labels=repmat('all',numel(idx),1);

% outcome
ix=0;
ix=ix+1;outcome{ix}='General Ability';
ix=ix+1;outcome{ix}='Executive Function';
ix=ix+1;outcome{ix}='Learning and Memory';
ix=ix+1;outcome{ix}='Emotion Dysregulation';

% preffix_name
preffix_name=[];

% flag_combined_small_communities
flag_combined_small_communities=0;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'path_Group_Color_Table'
            path_Group_Color_Table=varargin{q+1};
            Group_Color_Table_flag=1;
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'fig_wide'
            fig_wide=varargin{q+1};
            q = q+1;
            
        case 'fig_tall'
            fig_tall=varargin{q+1};
            q = q+1;
            
        case 'res'
            res=varargin{q+1};
            q = q+1;
            
        case 'save_flag'
            save_flag=varargin{q+1};
            q = q+1;
            
        case 'labels'
            labels=varargin{q+1};
            q = q+1;
            
        case 'up_to_n_members'
            up_to_n_members=varargin{q+1};
            q = q+1;
            
        case 'outcome'
            outcome=varargin{q+1};
            q = q+1;
            
        case 'preffix_name'
            preffix_name=varargin{q+1};
            q = q+1;
            
        case 'glabs'
            glabs=varargin{q+1};
            q = q+1;
            
        case 'glabs_to_show'
            glabs_to_show=varargin{q+1};
            q = q+1;
            
        case 'glab_reference'
            glab_reference=varargin{q+1};
            q = q+1;
            
        case 'normalization_method'
            normalization_method=varargin{q+1};
            q = q+1;
            
        case 'flag_combined_small_communities'
            flag_combined_small_communities=varargin{q+1};
            q = q+1;
            
        case 'behav_to_show'
            behav_to_show=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
Group_Color_Table_flag=Group_Color_Table_flag==1;

%% Rename Dx

Diagnosis=glabs;
Diagnosis=table(Diagnosis);
%% Prepare clusters
if isnumeric(idx)
    idx=cellstr(num2str(idx));
end
cluster=table(idx);
cluster.Properties.VariableNames{1}='cluster';
clusters=unique(cluster{:,1});
n_clusters=numel(clusters);
%% Define outcomes

IX=find_ix_in_header(T,outcome);

%% Concatenate data

localT=[Diagnosis cluster T(:,IX)];
%% Find indices to include

ix_to_include=ismember(glabs,glabs_to_show);
n_dx_to_include=numel(glabs_to_show);
%% Truncate data

Tt=localT(ix_to_include,:);

%% normalize scores

unique_glabs=unique(glabs);
if sum(contains( unique_glabs,glab_reference))
    reference=glab_reference;
else
    reference=unique_glabs{1};
end
Tnorm=local_normalize_scores(Tt,...
    outcome,...
    reference,...
    normalization_method);
%% Convert to tall table

Ttall_raw=wide2tall(Tt,outcome);
Ttall_norm=wide2tall(Tnorm,outcome);
%skinny_limits=get_skinny_limits(Ttall_norm);
skinny_limits=get_skinny_limits(Tnorm);
%% Find observed_behavior

observed_behavior=behav_to_show;
n_observed_behavior=numel(observed_behavior);

% format text to be used in correlations
xlabs=strrep(observed_behavior,'_',' ');
xlabs=lower(xlabs);
xlabs=strrep(xlabs,'composite','comp.');
IX_observed_behavior=find_ix_in_header(T,observed_behavior);
localT2=[Diagnosis cluster T(:,IX_observed_behavior)];
Tobserved_behavior=localT2(ix_to_include,:);
%% make my_color
Group_Color_Table=readtable(path_Group_Color_Table);
my_color=local_get_my_color(table(glabs_to_show'),Group_Color_Table);
% ix_temp=find(ismember(Group_Color_Table{:,1},glabs_to_show));
% Group_Color_Table=Group_Color_Table(ix_temp,:);
%
% Group_Color_Table=sortrows(Group_Color_Table,1);
% my_color=Group_Color_Table{:,2:end};


%%
Tplot=Ttall_norm;

%%
%%
N=ceil(sqrt(n_clusters));
xy=4*N;
fig_size=[1 1 xy xy];
vis_flag='on';
fig_name='clusters';

%% This section concatenate figures
local_count=nan(n_clusters,1);
DX=unique(Tplot{:,1});
n_up_to=min(n_dx_to_include,numel(unique(Diagnosis.Diagnosis)))+1;
for j=1:n_up_to
    local_fig_name=[fig_name '_all' ];
    T_dx=Tplot;
    if j>1
        ix_dx=ismember(T_dx{:,1},DX{j-1});
        T_dx=T_dx(ix_dx,:);
        local_fig_name=[fig_name '_' DX{j-1}];
    end
    
    
    f = figure('Visible',vis_flag,...
        'Units','centimeters',...
        'PaperUnits','centimeters',...
        'name',local_fig_name,...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'color',[1 1 1]);
    
    for i=2:n_clusters+1
        subplot(N,N,i-1)
        local_ix=ismember(T_dx.cluster,clusters(i-1));
        my_color=local_get_my_color(T_dx(local_ix,:),Group_Color_Table);
        try
            skinny_by_diagnosis(T_dx(local_ix,:),my_color,skinny_limits);
        catch
            plot(0,0,'w')
        end
        %     if i<n_clusters+1
        set(gca,'xticklabel',[])
        %     end
        grid on
        title({['Subgroup ' clusters{i-1}],['\fontsize{1}']})
        if i==n_clusters+1
            if flag_combined_small_communities %local_count(end)>local_count(end-1)
                title({['All others'],['\fontsize{1}']})
            end
        end
    end
    set(gcf,'color','w')
    if save_flag
        save_fig([local_fig_name preffix_name],...
            'res',res,...
            'path_to_save',output_folder)
    end
    
end

%%
yt=get(gca,'ytick');
ytl=get(gca,'yticklabel');

set(gca,'units','centimeters')
pos=get(gca,'position');
x=pos(3);
y=pos(4);

fig_size=[1 1 3*x 3*y];
pos=[.25 .4 .5 .5];
pos=[.35 .5 1/3 1/3];
vis_flag='on';
fig_name='all_data';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
set(gca,'units','centimeters')
subplot('position',pos)
my_color=local_get_my_color(Tplot,Group_Color_Table);
skinny_by_diagnosis(Tplot,my_color,skinny_limits)
% set(gca,'xticklabel',[])
title({'All',''})
set(gcf,'color','w')
set(gca,'ytick',yt);
set(gca,'yticklabel',ytl);
grid on
if save_flag
    
    save_fig([fig_name preffix_name],...
        'res',res,...
        'path_to_save',output_folder)
end

%% Do individual panels

DX=unique(Tplot{:,1});

for j=1:n_up_to
    
    root_fig_name=[fig_name '_all' ];
    T_dx=Tplot;
    if j>1
        ix_dx=ismember(T_dx{:,1},DX{j-1});
        T_dx=T_dx(ix_dx,:);
        root_fig_name=[fig_name '_' DX{j-1}];
        ix1=ismember(Tnorm{:,1},DX{j-1});
    end
    
    for i=2:n_clusters+1
        f = figure('Visible',vis_flag,...
            'Units','centimeters',...
            'PaperUnits','centimeters',...
            'PaperPosition',fig_size,...
            'Position',fig_size,...
            'color',[1 1 1]);
        local_fig_name=[root_fig_name '_Subgroup_' num2str(i-1)];
        set(gcf,'Name',local_fig_name)
        local_ix=ismember(T_dx.cluster,clusters(i-1));
        subplot('Position',pos)
        my_color=local_get_my_color(T_dx(local_ix,:),Group_Color_Table);
        try
            skinny_by_diagnosis(T_dx(local_ix,:),my_color,skinny_limits);
        catch
            plot(0,0,'w')
        end
        %     if i<n_clusters+1
        set(gca,'xticklabel',[])
        %     end
        grid on
        title({['Subgroup ' clusters{i-1}],['\fontsize{1}']})
        if i==n_clusters+1
            if flag_combined_small_communities %local_count(end)>local_count(end-1)
                title({['All others'],['\fontsize{1}']})
            end
        end
        
        if j>1
            % Add correlations with observed behavior
            ix2=ismember(Tnorm.cluster,clusters(i-1));
            ix=and(ix1,ix2);
            X=Tnorm{ix,3:end};
            Y=Tobserved_behavior{ix,3:end};
            try
                R = nancorr(Y,X);
                [rr cc]=size(R);
                pos2=[pos(1) 0.05 pos(3) pos(2)-.07];
                subplot('Position',pos2)
                imagesc(R,[-1 1])
                for i=1:rr
                    yline(i-.5)
                end
                for i=1:cc
                    xline(i-.5)
                end
                set(gca,'ytick',1:rr)
                set(gca,'yticklabel',xlabs)
                pos3=get(gca,'position');
                pos4=pos3;
                pos4(3)=.04;
                pos4(1)=sum(pos3([1 3]))+.05;
                cbar=colorbar('position',pos4,...
                    'Fontsize',7);
                cbar.Ticks=[-1 0 1];
                set(gca,'xticklabel',[])
                %             set(gca,'ytick',[-1 0 1])
                colormap jet
                pos_color=[247,251,255
                    222,235,247
                    198,219,239
                    158,202,225
                    107,174,214
                    66,146,198
                    33,113,181
                    8,81,156
                    8,48,107]/255;
                neg_pos_cmap('pos_color',pos_color);
            end
            1;
        end
        
        if save_flag
            save_fig([local_fig_name preffix_name],...
                'res',res,...
                'path_to_save',output_folder)
        end
        
    end
    
end
%%
% for i=1:n
%     j=2+i;
%     subplot 211
%     gscatter(Tt{:,j},Tnorm{:,j},Tnorm{:,1})
%
%     subplot 212
%     gscatter(Tt{:,j},Tnorm{:,j},Tnorm{:,2})
%     pause
% end
%%
% IX_status=find_ix_in_header(T,'SCAN_ADHD_STATUS');
%
% localT=[cluster T(:,[IX_status; IX])];
%
%
%
% [r,c]=size(localT);
% Dx=cell(r,1);
% Dx(localT.SCAN_ADHD_STATUS==1)={'Control'};
% Dx(localT.SCAN_ADHD_STATUS==3)={'ADHD'};
%
%
% %%
% n=numel(IX);
% for i=1:n
%     subplot(n,1,i)
% skinny_plot(localT(:,[1 2+i]),[],'include_count',1,'use_median_instead_of_mean_flag',1)
% end
%
% %%
% r=size(localT,1);
% O=(repmat(localT.Properties.VariableNames(3:end),r,1));
% X=localT{:,3:end}
% tt=table(O(:),X(:))
%
%
% skinny_plot(tt,[],'use_median_instead_of_mean_flag',1)