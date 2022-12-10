function f = spaghetti_plot(T,varargin)

%% Mute warnings
warning ('off','all');
%% Read headers
headers=T.Properties.VariableNames;
n_headers=size(headers,2);
%% Define defaults

% fig size wide
fig_wide=14;

% fig size tall
fig_tall=6.5;

X_column=n_headers-1;
Y_column=n_headers;
id_column=1;
group_column=n_headers-2;

legend_location='northeastoutside';


user_provided_colormap_flag=0;

resort_groups_flag=0;
%% Read optional arguments
v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'my_color'
            my_color=varargin{q+1};
            user_provided_colormap_flag=1;
            q = q+1;
            
        case 'resort_groups'
            resort_groups=varargin{q+1};
            if iscell(resort_groups)
                resort_groups=char(resort_groups);
            end
            resort_groups_flag=1;
            q = q+1;
            
        case 'fig_tall'
            fig_tall=varargin{q+1};
            q = q+1;
            
        case 'fig_wide'
            fig_wide=varargin{q+1};
            q = q+1;
            
        case 'legend_location'
            legend_location=varargin{q+1};
            q = q+1;
            
        case 'x_column'
            X_column=varargin{q+1};
            q = q+1;
            
        case 'y_column'
            Y_column=varargin{q+1};
            q = q+1;
            
        case 'id_column'
            id_column=varargin{q+1};
            q = q+1;
            
        case 'group_column'
            group_column=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_colormap_flag=user_provided_colormap_flag==1;
resort_groups_flag=resort_groups_flag==1;

%% Read values for plotting
X=T{:,X_column};
Y=T{:,Y_column};
id=T{:,id_column};
group=T{:,group_column};
if iscell(group)
    group=char(group);
end

if iscell(id)
    id=char(id);
end

X_label=headers{X_column};

Y_label=headers{Y_column};
id_label=headers{id_column};
group_label=headers{group_column};


old='_';
new=' ';
X_label = strrep(X_label,old,new);
Y_label = strrep(Y_label,old,new);
id_label = strrep(id_label,old,new);
group_label = strrep(group_label,old,new);
%% Read groups

groups=unique(group,'rows');
n_groups=size(groups,1);

% n_per_group=
%% Resort groups, if asked

if resort_groups_flag==1
    groups=validate_resort_groups(groups,resort_groups);
end
%% Assign colors for plotting

if user_provided_colormap_flag==0
    RGB=get_RGBs(n_groups);
    try
    my_color=table(groups,RGB);
    catch
        my_color=cell2table({groups,RGB});
        my_color.Properties.VariableNames{1}='groups';
        my_color.Properties.VariableNames{2}='RGB';
    end
end
%% Wrap by id

ids=unique(id,'rows');
n_ids=size(ids,1);

cat_data(n_ids).id=[];
cat_data(n_ids).X=[];
cat_data(n_ids).Y=[];
cat_data(n_ids).color=[];
cat_data(n_ids).group=[];
cat_data(n_ids).marker=[];
cat_data(n_ids).marker_size=[];
cat_data(n_ids).linewidth=[];

for i=1:n_ids
    local_id=ids(i,:);
    local_ix=find(ismember(id,local_id,'rows'));
    local_X=X(local_ix);
    local_Y=Y(local_ix);
    local_group=group(local_ix,:);
    local_color=read_color(local_group(1,:),my_color);
    
    cat_data(i).id=local_id;
    cat_data(i).X=local_X;
    cat_data(i).Y=local_Y;
    cat_data(i).color=local_color;
    cat_data(i).group=local_group(1,:);
    cat_data(i).marker='.';
    cat_data(i).linewidth=1;
    cat_data(i).marker_size=20;
end
%% Define plot size
fig_color=[1 1 1];
f = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);
%% Make initial run to be able to use legend
groups_by_id=cat(1,cat_data.group);

if ~iscell(groups_by_id)
    groups_by_id=cellstr(groups_by_id);
end
try
    leg_n=count_from_categorical(groups_by_id,groups);
catch
    error('Need to clone https://gitlab.com/Fair_lab/text_manipulation to load the function "count_from_categorical"')
end

%
for i=1:n_groups
    local_ix=find(ismember(groups_by_id,groups(i,:),'rows'));
    
    X=cat_data(local_ix).X;
    Y=cat_data(local_ix).Y;
    local_marker=cat_data(local_ix).marker;
    local_marker_size=cat_data(local_ix).marker_size;
    local_color=cat_data(local_ix).color;
    
    plot(X,Y,...
        'marker',local_marker,...
        'markersize',local_marker_size,...
        'color',local_color)
    if i==1
        hold all
    end
    
end
%% Plot data
for local_ix=1:n_ids
    
    X=cat_data(local_ix).X;
    Y=cat_data(local_ix).Y;
    local_marker=cat_data(local_ix).marker;
    local_marker_size=cat_data(local_ix).marker_size;
    local_color=cat_data(local_ix).color;
    
    plot(X,Y,...
        'marker',local_marker,...
        'markersize',local_marker_size,...
        'color',local_color)
end
hold off
xlabel(X_label)
ylabel(Y_label)



%% add legend
legend(leg_n,...
    'Location',legend_location)
%% Beautify numbers in the axis
try
    % Leave room% space on left and right, top and bottom
    room=5;
    axis_room(room)
catch
    display('Tried to change visualization margins. It was not possible')
    display('It needs function axis_room from https://gitlab.com/ascario/plotting-tools')
end

try
    yticks=get(gca,'ytick');
    set(gca,'ytick',yticks);
    axis_label=set_axis_label(yticks);
    set(gca,'yticklabel',axis_label);
catch
    display('Tried to change number formatting on y label')
    display(' To do it clone https://gitlab.com/ascario/plotting-tools')
end

ax=get(gca);
ax.ActivePositionProperty = 'position';

%%
warning ('on','all');
function my_color=get_RGBs(n_groups)

try
    cud
    my_color=cmap;
catch
    display('Using default color order instead of colors from the Color Universal Design (CUD)pallete')
    display('To use CUD, clone the repo: ')
    my_color=get(gca,'colororder');
end
n_my_color=size(my_color,1);
if n_my_color<n_groups
    my_color=repmat(my_color,ceil(n_groups/n_my_color),1);
else
    my_color=my_color(1:n_groups,:);
end

RGB=my_color;
% RGB=table(my_color);
% RGB.Properties.VariableNames{1}='RGB';

function groups=validate_resort_groups(groups,resort_groups)

if iscell(resort_groups)
    resort_groups=char(resort_groups);
end

validating_match=ismember(groups,resort_groups);
validating_match=prod(validating_match)==1;
if prod(validating_match)
    groups=resort_groups;
else
    error('Validate provided resort_groups values')
end

function local_color=read_color(local_group,my_color)

all_groups=my_color{:,1};
local_ix=find(ismember(all_groups,local_group,'rows'));
local_color=my_color{local_ix,2:end};