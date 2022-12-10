function scatter_pValues (pValue_cifti_paths,...
    path_parcellation_table,...
    varargin)

%% Oscar Miranda-Dominguez
% First line of code: Aug 23, 2022
%% Example 1


% filename='scatter_pValues_pscalars';
% path_parcellation_table='/home/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/Gordon_subcortical.mat';
% pValue_cifti_paths(1).path='/home/miran045/shared/projects/PNRS_emotion_regulation/experiments/Oscar_make_BWAS_pscalars/Gordon/LAmy/BWAS_ABCD/case4_prewhitening_mass_univariate_g1/ciftis/brain_feature/brain_feature_pValue.ptseries.nii';
% pValue_cifti_paths(1).title='ABCD';
% pValue_cifti_paths(2).path='/home/miran045/shared/projects/PNRS_emotion_regulation/experiments/Oscar_make_BWAS_pscalars/Gordon/LAmy/BWAS_ARM1/case4_prewhitening_mass_univariate_g1/ciftis/brain_feature/brain_feature_pValue.ptseries.nii';
% pValue_cifti_paths(2).title='ARM1';
% scatter_pValues (pValue_cifti_paths,...
%     path_parcellation_table,...
%     'filename',filename)

%% Example 2

% path_parcellation_table='/home/faird/shared/code/internal/utilities/fconn_matrices_tools/parcel_schemas/Gordon_subcortical.mat';
% pValue_cifti_paths(1).path='/home/miran045/shared/projects/ABCD_neurocog/experiments/make_BWAS_controling_pc1pc2pc3/Gordon/FD_0_20_time_08_mins_all/BWAS_ABCD/case4_prewhitening_mass_univariate_g1/ciftis/brain_feature/brain_feature_pValue.pconn.nii';
% pValue_cifti_paths(1).title='ABCD';
% pValue_cifti_paths(2).path='/home/miran045/shared/projects/ABCD_neurocog/experiments/make_BWAS_controling_pc1pc2pc3/Gordon/FD_0_20_time_08_mins_all/BWAS_ARM1/case4_prewhitening_mass_univariate_g1/ciftis/brain_feature/brain_feature_pValue.pconn.nii';
% pValue_cifti_paths(2).title='ARM1';
% 
% 
% scatter_pValues (pValue_cifti_paths,...
%     path_parcellation_table)

%% Define defaults
fs=filesep;

% output folder
output_folder=pwd;

% filename
filename='scatter_pValues';


% resolution
res=300;


% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})

        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;

        case 'filename'
            filename=varargin{q+1};
            q = q+1;

        case 'res'
            res=varargin{q+1};
            q = q+1;

        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;

        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Read pValues

[Px, C] =read_pValues_and_Color(pValue_cifti_paths(1).path,path_parcellation_table,options);
[Py, C] =read_pValues_and_Color(pValue_cifti_paths(2).path,path_parcellation_table,options);

%% Convert to log scale
Px_log=-log10(Px);
Py_log=-log10(Py);

%% get lines
[X_tick_values th_names]=get_tick_values(Px_log,options);
[Y_tick_values th_names]=get_tick_values(Py_log,options);
n=numel(Y_tick_values);
%% Make figure

fig_name=filename;
fig_size=[1 1 8 8];
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

%%

line_color=[1 1 1]*.7;
line_style='-';
line_width=.1;
fs=7;
subplot ('Position',[.2 .2 .6 .6])
try
scatter(Px_log,Py_log,[],C,'filled');
catch
    scatter(Px_log,Py_log,[],'k','filled');
end

R=corr(Px_log,Py_log);
R_text=num2format_text(R);
axis_room;

xl=xlim;
yl=ylim;

xl(1)=0;
yl(1)=0;
xlim(xl)
ylim(yl)
for i=1:n
    xline(X_tick_values([i i]),...
        'color',line_color,...
        'LineStyle',line_style,...
        'Linewidth',line_width);

    text(X_tick_values(i),yl(2),...
        th_names{i},...
        'Rotation',45,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','Middle',...
        'Fontsize',fs);


    yline(Y_tick_values([i i]),...
        'color',line_color,...
        'LineStyle',line_style,...
        'Linewidth',line_width);

    text(xl(2),Y_tick_values(i),...
        th_names{i},...
        'Rotation',0,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','Middle',...
        'Fontsize',fs);
end
box on

yticks=get(gca,'ytick');
set(gca,'ytick',yticks);
axis_label=set_axis_label(yticks);
set(gca,'yticklabel',axis_label);

xticks=get(gca,'xtick');
set(gca,'xtick',xticks);
axis_label=set_axis_label(xticks);
set(gca,'xticklabel',axis_label);

xlab=[pValue_cifti_paths(1).title ' (-log_{10}(P))'];
xlabel(xlab)

ylab=[pValue_cifti_paths(2).title ' (-log_{10}(P))'];
ylabel(ylab)



tit=['R = ' R_text];
xlm=xlim;
ylm=ylim;
text(xlm(1)+.05*xlm(2),0.95*ylm(2),tit,...
    'VerticalAlignment','Top',...
    'HorizontalAlignment','Left',...
    'BackgroundColor','w')

lsline
%% Save figure
if ~isfolder(output_folder)
    mkdir(output_folder)
end

set(gcf,'name',filename)
saveas(gcf,[output_folder filesep filename])
res_text=['-r' num2str(res)];
print([output_folder filesep filename],'-dpng',res_text)
%print([output_folder filesep filename],'-dtiffn',res_text)
