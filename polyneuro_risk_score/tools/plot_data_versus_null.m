function plot_data_versus_null(V,V_null,xlab,...
    tit,...
    n_tick_upto)
%%
if nargin<5
    n_tick_upto=size(V,1);
end
%%
vis_flag='on';
fig_size=[1 1 8 8];
if n_tick_upto>15
    fig_size(3)=20;
end
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
%%
lw=3;

%%
if numel(V)>n_tick_upto
    V(n_tick_upto+1:end)=[];
    V_null(n_tick_upto+1:end,:)=[];
    xlab(n_tick_upto+1:end)=[];
end
n_tick_upto=numel(V);
%% Make figs to get limits

% boxplot(V_null',...
%     'PlotStyle','compact',...
%     'Colors',[122,1,119]/255,...
%     'OutlierSize',1e-4)
[r,c]=size(V_null);
t1=repmat(xlab,1,c);
t2=V_null;

t=table(t1(:), t2(:));
t.Properties.VariableNames{1}='Features';
t.Properties.VariableNames{2}='R';
[foo, ix] = ismember(xlab,sort(xlab));

show_text_flag=0;
dotted_line_flag=0;
use_median_instead_of_mean_flag=1;
my_color=repmat([122,1,119]/255,r,1);
skinny_plot(t,my_color,...
    'show_text_flag',show_text_flag,...
    'dotted_line_flag',dotted_line_flag,...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'resort_groups',ix)

yl1=ylim;
plot(V,...
    'color',[0 158 115]/255,...
    'linewidth',lw)
yl2=ylim;

yl(1)=min([yl1 yl2]);
yl(2)=max([yl1 yl2]);
%%
if n_tick_upto>15
    subplot('Position',[.05 .15 .9 .75]);
else
    subplot('Position',[.15 .3 .8 .55])
end

clf

plot(V,...
    'color',[0 158 115]/255,...
    'linewidth',lw)


% boxplot(V_null',...
%     'PlotStyle','compact',...
%     'Colors',[122,1,119]/255,...
%     'OutlierSize',1e-4)

hold all
patchplot(V_null');
hold all
plot(V,...
    'color',[0 158 115]/255,...
    'linewidth',lw)
% boxplot(V_null',...
%     'PlotStyle','compact',...
%     'Colors',[122,1,119]/255,...
%     'OutlierSize',1e-4)
hold all
skinny_plot(t,my_color,...
    'show_text_flag',show_text_flag,...
    'dotted_line_flag',dotted_line_flag,...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'yl',yl,...
    'resort_groups',ix)
hold all
plot(V,...
    'color',[0 158 115]/255)

hold off
leg=legend('Predictions','Null data');
yt=get(gca,'ytick');
ytl=get(gca,'yticklabel');
%% clean xlab
old = 'p 00.';
new='p 0.';
xlab= strrep( xlab , old , new );
old = 'p 000.';
new='p 0.';
xlab= strrep( xlab , old , new );
old = 'p 0';
new='p ';
xlab= strrep( xlab , old , new );
old = 'p .';
new='p 0.';
xlab= strrep( xlab , old , new );
old = ' features';
new='';
xlab= strrep( xlab , old , new );
old = ' feature';
new='';
xlab= strrep( xlab , old , new );
old = 'top';
new='Top';
xlab= strrep( xlab , old , new );

set(gca,'xtick',1:n_tick_upto)
set(gca,'xticklabel',xlab')
if n_tick_upto>15
    set(gca,'xticklabel',xlab',...
        'fontsize',7)
end

X=xlabel('Features');
angle=90;
xtickangle(angle)

%%

% X.Position(2)=-X.Position(2);
%% title
local_tit=cell(2,1);
local_tit{1}=tit;
local_tit{2}=['(N null = ' num2str(size(V_null,2)) ')'];
local_tit=downsize_fontsize_additionall_rows(local_tit,11);
title(local_tit);

str_to_remove{1}='%';
str_to_remove{2}=' ';
filename=title2filename({tit},...
    'str_to_remove',str_to_remove);
filename=[filename '_N_' num2str(n_tick_upto)];
%% ylabel

if contains(tit,'Variance')
    ylab='% Explained Variance';
else
    ylab='R';
end
ylabel(ylab)

%%
ylab=get(gca,'ytick');
set(gca,'ytick',ylab);
axis_label=set_axis_label(ylab);
set(gca,'yticklabel',axis_label)
set(gca,'ytick',yt);
set(gca,'yticklabel',ytl);
%%

if V(end)>0
    leg.Position=[0.5237 0.3929 0.3775 0.1076];
end

%%
filepath=[pwd filesep 'figures' filesep 'ExplainedVariance_and_Null'];
if ~isfolder(filepath)
    mkdir(filepath)
end
save_fig(filename,...
    'path_to_save', filepath)