function custom_hist(X,options,my_color)

%% Oscar Miranda Dominguez
% First line of code: Jan 25, 2018
%% Syntax

%% Description

% X data to be displayed.
% If X is a cell, custom_hist creates histograms for each indexed matrix within x and overlays them onto a single plot.
% If the input is a multi-column array, custom_hist creates histograms for each column of x and overlays them onto a single plot.
%
% Options:
% Data can be displayed using different curves, box is defaul
%   options.shown_as='box'; default
%   options.shown_as='curve';
%   options.shown_as='stairs';
%   options.shown_as='contour';
%
% To be done: texts, an structure with text correspinding to:
% title
% xlabel
% ylabel
% legend( as a cell)
% extra_text
%% Read the data and precalculate points
[points, traces]=count_points(X);

%% Figure settings | Temp, future will be a function

if nargin<3
    if traces<9
    fig_settings.my_color=[0 0 0;
        .90 .60 .00
        .35 .70 .90
        .00 .60 .50
        .95 .90 .25
        .00 .45 .70
        .80 .40 .00
        .80 .60 .70
        ];
    else
        fig_settings.my_color=jet(traces);
    end
else
    fig_settings.my_color=my_color;
end

fig_settings.wide=8;
fig_settings.hight=8;
fig_settings.fs_title=12; % font size title
fig_settings.fs_axis=10; % font size axis
fig_settings.fs_legend=9; % font size legend
fig_settings.axis_color=[1 1 1];
fig_settings.fig_color=[1 1 1];
% fig_settings.my_color=[27,158,119;217,95,2; 1 0 1]/255;
% fig_settings.my_color=[0 0 0;
%     .90 .60 .00
%     .35 .70 .90
%     .00 .60 .50
%     .95 .90 .25
%     .00 .45 .70
%     .80 .40 .00
%     .80 .60 .70
%     ];

%% Count elements per bin
%% Read options
if nargin<2
    options=[];
end

options = read_options_custom_hist(options,points);
options.color=fig_settings.my_color;
%% Encapsulate data as cell

Xcell=encapsulate_X(X);

%% Count elements per bin

[x_hist, y_hist]=get_hist_data(Xcell,options);
% whos x_hist y_hist

%% Normalize, if ask
if options.normalize
    y_hist=y_hist./repmat(sum(y_hist),size(y_hist,1),1);
end

%% smooth, if asked
if options.smooth_factor>0
    for i=1:traces
        y_hist(:,i)=smooth(y_hist(:,1),options.smooth_factor);
    end
end
%% Define the figure

%% Make the flat figure

i=1;
C=fig_settings.my_color(i,:);


%% Temp trace to get the limits
vis_flag='off';
temp_fig=figure('Visible',vis_flag);

bar(x_hist,y_hist,1,...
    'FaceAlpha',options.alpha,...
    'EdgeColor',C,...
    'FaceColor',C,...
    'LineWidth',options.LineWidth);
xl=xlim;
close(temp_fig)
if ~isempty(options.xlim)
    xl=options.xlim;
end
%% Make the figure
plot_hist(x_hist,y_hist(:,i),options,C,xl);
hold all
for i=2:traces
    C=fig_settings.my_color(i,:);
    plot_hist(x_hist,y_hist(:,i),options,C,xl);
end
hold off
box off

if options.normalize
    set(gca,'yticklabel',[])
end
%%
set(gcf,'color',fig_settings.fig_color);
set(gca,'color',fig_settings.axis_color);

%%
xt=get(gca,'xtick');
try
axis_label=set_axis_label(xt);
set(gca,'xticklabel',axis_label)
catch 
    display('Using default format for xlabel')
    display('If you want to use set_axis_label load the repo generic_for_functions')
    display('https://gitlab.com/Fair_lab/generic_for_functions');
end
%% Add legends and text
% if ~isempty(texts)
%     if ~isempty(texts.xlabel)
%         xlabel(texts.xlabel)
%     end
%
%     if ~isempty(texts.ylabel)
%         ylabel(texts.ylabel)
%     end
%
%     if ~isempty(texts.title)
%         title(texts.title,'fontsize',fs_title)
%     end
%
%     if ~isempty(texts.legend)
%         l=legend(texts.legend);
%     end
% end




% if ~isempty(texts.extra_text)
%     yl=ylim;
%     xl=xlim;
%     text(mean(xl),yl(2),texts.extra_text,...
%         'VerticalAlignment','bottom',...
%         'HorizontalAlignment','center',...
%         'fontsize',texts.fs_extra_text)
%     yl(2)=1.4*yl(2);
%     set(gca,'ylim',yl)
% end
%
% set(l,'box','off')

box off

%% Beautify figure based on provided settings
%%

