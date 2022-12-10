function customized_hist(data,fig_settings)

[points, traces]=size(data);

if isempty(fig_settings.n_bins)
    n_bins=floor(sqrt(points));
else
    n_bins=fig_settings.n_bins;
end
bar_color=fig_settings.bar_color;

if isempty(fig_settings.bar_color)
    fig_settings.bar_color=get(0,'DefaultAxesColorOrder');
end
%%
tit_fig=fig_settings.title;
fig_size=[1 1 fig_settings.wide fig_settings.hight];
f = figure('Visible','on',...
    'Units','centimeters',...
    'name',tit_fig{1},...
    'Position',fig_size,...
    'PaperPosition',fig_size);
fs_axis=fig_settings.fs_axis; %size of fonts in plots
fs_title=fig_settings.fs_title;%size of fonts in title
fs_label=fig_settings.fs_legend;%size of fonts in title
fs_legend=fig_settings.fs_legend;

set(gcf,'Color',fig_settings.fig_color,...
    'DefaultAxesColorOrder',fig_settings.bar_color,...
    'DefaultAxesLineWidth',1,...
    'DefaultAxesFontSize',fs_axis)%,...

%%

hist(data(:),n_bins);
xl=xlim;

x=linspace(xl(1),xl(2),n_bins);
y=histc(data,x);


%%
clf
axis on
hold all
h=cell(traces,1);
for i=1:traces
    h{i}=histogram(data(:,i),x);
    h{i}.FaceColor=bar_color(i,:);
end
hold off
box on
xlabel(fig_settings.xlabel)
ylabel(fig_settings.ylabel)
title(fig_settings.title,'fontsize',fs_title)
l=legend(fig_settings.legend);



if ~isempty(fig_settings.extra_text)
    yl=ylim;
    xl=xlim;
    text(mean(xl),yl(2),fig_settings.extra_text,...
        'VerticalAlignment','bottom',...
        'HorizontalAlignment','center',...
        'fontsize',fig_settings.fs_extra_text)
    yl(2)=1.4*yl(2);
    set(gca,'ylim',yl)
end

set(l,'box','off')

box off
%%
