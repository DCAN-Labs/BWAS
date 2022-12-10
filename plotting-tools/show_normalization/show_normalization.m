function [f, f2]=show_normalization(x,normalization,group_color_assignment_table)
%% Oscar Miranda-Dominguez
%
% First line of code: Dec 19, 2019
%% show_normalization(x,normalization,group_color_assignment_table)
%
% This function display an scatterplot of original and transformed data
%
%% Mandatory inputs:
%
% 1) x. Original data
% 2) normalization:
% - if text, is the transformation to use
% - if numeric, transformed data. It should be the same size as x

%% Optional inputs:
%
% group_color_assignment_table
% A table with as many rows as length of x and 4 columns.
% - column 1: group name for each rok
% - column 2: value for red color (0 to 1)
% - column 3: value for green color (0 to 1)
% - column 4: value for blue color (0 to 1)

%% normalize the data
if isnumeric (normalization)
    Z=normalization;
    Transform='Normalized';
else
    Z=local_normalization(x,normalization);
    Transform=normalization;
end

%% get colors
if nargin<3
    group_color_assignment_table=get_local_table(x);
end

%% cat for sorting

T=[array2table(x) array2table(Z) group_color_assignment_table];
T=sortrows(T,3);

X=T{:,1};
Y=T{:,2};

species=table2array(T(:,3));
my_color=table2array(T(:,4:end));
my_color=unique(my_color,'rows','stable');

n_species=size(my_color,1);
leg_n = count_per_group(species);
%% make the figure

fig_size=[8 8 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

LineWidth=3;
Marker='.';
MarkerSize=16;
LineStyle='-';
scatterhist(Y,X,'Kernel','on',...
    'color',[0 0 0],...
    'LineStyle',LineStyle,...
    'LineWidth',LineWidth,...
    'Marker',Marker,...
    'MarkerSize',MarkerSize);

%%
if n_species>1
    
    hold all
    gscatter(Y,X,species,my_color,Marker,MarkerSize)
%     legend('location','southeast','box','off')
    legend('location','northwest','box','off')
    hold off
end
ylabel('Original')
xlabel(Transform)


%%
f2=[];
if n_species>1
f2 = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
MarkerSize=[12 12 12];
scatterhist(Y,X,'Group',species,'Kernel','on',...
    'color',my_color,...
    'LineStyle',{'-','-','-'},...
    'LineWidth',[2,2,2],...
    'Marker','...',...
    'MarkerSize',MarkerSize);
ylabel('Original')
xlabel(Transform)
leg=legend('location','northwest','box','off');

try
    add_count_to_legend(leg_n)
end
leg.Units='centimeters';%normalized
pos=leg.Position;
pos(1)=-.45;
pos(2)=pos(2)+.2;
leg.Position=pos;
end
%%



%%

function Z=local_normalization(x,normalization)

ix=~isnan(x);
switch normalization
    case 'Z'
        
        m=mean(x(ix));
        s=std(x(ix));
        
        
        z=(x-m)/s;
        params.m=m;
        params.s=s;
        
        preffix='Z_';
        
    case 'boxcox'
        [z, params]=boxcox_transform(x);
        
        preffix='boxcox_';
end

Z=nan(size(x));
Z(ix)=z;

function group_color_assignment_table=get_local_table(x)
n=numel(x);
all=repmat('all',n,1);

RGB1=zeros(n,1);
RGB2=zeros(n,1);
RGB3=zeros(n,1);

group_color_assignment_table=table(all,RGB1,RGB2,RGB3);

function leg_n = count_per_group(species)
if ischar(species)
    species=cellstr(species);
end
unique_species=unique(species);
n_unique_species=numel(unique_species);
leg_n=cell(n_unique_species,1);


for i=1:n_unique_species
    temp=ismember(species,unique_species{i});
    temp=sum(temp);
    leg_n{i}=[unique_species{i} ' (n=' num2str(temp) ')'];
    
end

function add_count_to_legend(leg_n)
leg=legend;
temp=char(leg_n);
n_leg=size(leg.String,2);
for i=1:n_leg
    old=leg.String{i};
    n_char=size(old,2);
    
    ix=find(ismember(temp(:,1:n_char),old,'rows'));
    new=leg_n{ix};
    new(1)=upper(new(1));
    leg.String{i}=new;
    
end
