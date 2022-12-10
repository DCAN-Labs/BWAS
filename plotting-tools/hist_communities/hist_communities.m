function [idx, h]=hist_communities(idx,varargin)

%% [idx, h]=hist_communities(idx_raw,varargin)


%% Assign community name based on abundance/rank
% idx = name_communities_by_count_of_members(idx_raw);

%% Count uniques
[u,nu,ix,nix]=find_uniques(idx);

%% Credits
% Oscar Miranda-Dominguez
% First line of code: Oct 13, 2021

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
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
Group_Color_Table_flag=Group_Color_Table_flag==1;


%% recast data for plotting
if ischar(labels)
    labels=recast_as_cell(labels);
end
unique_labels=unique(labels,'stable');
n_labels=size(unique_labels,1);
X=nan(nu,n_labels);
for i=1:nu
    ix1=ismember(idx,u(i));
    for j=1:n_labels
        ix2=ismember(labels,unique_labels(j,:));
        X(i,j)=sum(and(ix1,ix2));
    end
end

%% Read colors

if Group_Color_Table_flag
    Group_Color_Table=readtable(path_Group_Color_Table);
    clr=get_colors(labels,Group_Color_Table);
    
    ix_temp=find(ismember(Group_Color_Table{:,1},unique_labels));
    Group_Color_Table=Group_Color_Table(ix_temp,:);
    
    % sort legends as provided in the group color file
    IX=nan(n_labels,1);
    for i=1:n_labels
        IX(i)=find(ismember(unique_labels,Group_Color_Table{i,1}));
        %         IX(i)=find(ismember(Group_Color_Table{:,1},unique_labels{i}));
    end
    X=X(:,IX);
    unique_labels=unique_labels(IX);
else
    cud % this executes an script to define cmap
    clr=cmap;
    if n_labels<2
        clr=[1 1 1];
    end
end

%%
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);


% hist(idx,nu)
b=bar(X,'stacked',...
    'EdgeColor',[0 0 0]);
xlim([0 nu+1])

%% Apply color
for i=1:n_labels
    b(i).FaceColor=clr(i,:);
end

%% add legend
if n_labels>1
    if isnumeric(unique_labels)
        local_leg=num2str(unique_labels);
    else
        local_leg=unique_labels;
    end
    
    N=sum(X);
    for i=1:n_labels
        local_leg{i}=[local_leg{i} ' \fontsize{8}(' num2str(N(i)) ')'];
    end
    
    legend_object=legend(local_leg);
end



%% add line
ix_up_to_n_members=find(nix<up_to_n_members,1);
if up_to_n_members>0
    yline(up_to_n_members)
    xline(ix_up_to_n_members)
    text(ix_up_to_n_members,up_to_n_members,num2str(up_to_n_members),...
        'fontsize',8,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','bottom')
    legend_object.String(n_labels+1:end)=[];
end


%% add labels and title
xlabel('Communities')
ylabel('Participant count')
tit=[num2str(nu) ' unique communities'];
title(tit)
%% Relocate legend

if n_labels>1
    yp1=get(gca,'position');
    yp2=legend_object.Position;
    yp2(2)=yp1(2)+yp1(4)-yp2(4);
    legend_object.Position=yp2;
    yl=ylim;
    yl(2)=yl(2)*(1+yp2(end)/yp1(end));
    ylim(yl);
end

%% save if requested

if save_flag
    fig_name=title2filename({'hist_' tit '_N_labels_' num2str(n_labels)});
    %     output_folder=quotes_if_space(output_folder);
    save_fig(fig_name,...
        'res',res,...
        'path_to_save',output_folder)
end