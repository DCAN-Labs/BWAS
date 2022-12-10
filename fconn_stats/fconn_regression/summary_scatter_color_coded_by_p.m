function Weight=summary_scatter_color_coded_by_p(X,Y,p,mae_names,local_folder,suffix_name)
%%
X_ptile=ecdf_unsorted(X);
Y_ptile=ecdf_unsorted(Y);
Weight=sqrt(X_ptile.^2+Y_ptile.^2);
% Weight=Weight./max(Weight);
%%

vis_flag='on';
fig_size=[1 1 8 8];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
%% Define subpanes
% units in cm
BottomSpace = 1.2;
TopSpace = 1.2;
LeftSpace=1.5;
RightSpace=0.;
BetweenH=0.;
BetweenV=0.03;

L_fraction_W=.1;

L=(min(fig_size(end-1:end))-max([BottomSpace+TopSpace,LeftSpace+RightSpace]))/(1+L_fraction_W);
W=L_fraction_W*L;
main_plot=subplot('Position',[LeftSpace/fig_size(3) BottomSpace/fig_size(4) L/fig_size(3) L/fig_size(4)]);
sample1_plot=subplot('Position',[LeftSpace/fig_size(3) (L+BottomSpace)/fig_size(4) L/fig_size(3) W/fig_size(4)]);
sample2_plot=subplot('Position',[(L+LeftSpace)/fig_size(3) BottomSpace/fig_size(4) W/fig_size(3) L/fig_size(4)]);
%% Make groups
pth=[.05 .1 1];
n_pth=numel(pth);
p_th1=.05;
p_th2=.1;
p_th3=1;
g1=p<=p_th1;
g2=p<=p_th2;
g3=p<=p_th3;

g1_color=[44,162,95]/255;
g2_color=[254,178,76]/255;
g3_color=[231,225,239]/255;
% g3_color=[255 255 255]/255;
g_color=[g1_color;g2_color;g3_color];
n_system_pairs=numel(X);
g=zeros(n_system_pairs,3);


g(g3,:)=repmat(g3_color,sum(g3),1);
g(g2,:)=repmat(g2_color,sum(g2),1);
g(g1,:)=repmat(g1_color,sum(g1),1);
%%
subplot(main_plot)

leg=cell(n_pth,1);
i=1;
scatter(X(i),Y(i),[],g_color(i,:),'filled')
leg{i}=['p <= ' num2str(pth(i),'%4.2f')];
hold all
for i=2:3
    scatter(X(i),Y(i),[],g_color(i,:),'filled')
    leg{i}=['p <= ' num2str(pth(i),'%4.2f')];
end
[b,ix]=sort(p,'descend');% trick to show p<0.05 on top of the others
scatter(X(ix),Y(ix),[],g(ix,:),'filled')
ptiles=[5 10];
s1_ptiles=prctile(X,ptiles);
s2_ptiles=prctile(Y,ptiles);
hold off


%%
%% measure xlim ylim
xl=xlim;
yl=ylim;

%% add percentile lines

for i=1:numel(ptiles)
    line(s1_ptiles([i i]),yl,...
        'color','k',...
        'linestyle',':')
    line(xl,s2_ptiles([i i]),...
        'color','k',...
        'linestyle',':')
end
%% Add percentile labels sample 1
preffix{1}='';
preffix{2}='\leftarrow';
suffix{1}='\rightarrow';
suffix{2}='';
HorizontalAlignment{1}='right';
HorizontalAlignment{2}='left';
VerticalAlignment{1}='top';
VerticalAlignment{2}='top';
fs=8;
for i=1:numel(ptiles)
    line(s1_ptiles([i i]),yl,...
        'color','k',...
        'linestyle',':')
    line(xl,s2_ptiles([i i]),...
        'color','k',...
        'linestyle',':')
    local_text=[preffix{i} num2str(ptiles(i)) '%' suffix{i}];
    text(s1_ptiles(i),yl(2),local_text,...
        'VerticalAlignment',VerticalAlignment{i},...
        'HorizontalAlignment',HorizontalAlignment{i},...
        'fontsize',fs)
end
%%
%% Add percentile labels sample 2
suffix{1}='';
suffix{2}='';
preffix{1}='\uparrow';
preffix{2}='\downarrow';
HorizontalAlignment{1}='left';
HorizontalAlignment{2}='left';
VerticalAlignment{1}='top';
VerticalAlignment{2}='bottom';
for i=1:numel(ptiles)
    line(s1_ptiles([i i]),yl,...
        'color','k',...
        'linestyle',':')
    line(xl,s2_ptiles([i i]),...
        'color','k',...
        'linestyle',':')
    local_text=[preffix{i} num2str(ptiles(i)) '%' suffix{i}];
    text(xl(2),s2_ptiles(i),local_text,...
        'VerticalAlignment',VerticalAlignment{i},...
        'HorizontalAlignment',HorizontalAlignment{i},...
        'fontsize',fs)
end
%%
subplot(sample1_plot)
options.shown_as='contour';
custom_hist(X,options)
xlim(xl)
fs=8;
for i=1:numel(ptiles)
    line(s1_ptiles([i i]),ylim,...
        'color','k',...
        'linestyle',':')
end
axis off
%%
subplot(sample2_plot)
options.xlim=yl;
custom_hist(Y,options)
camroll(-270)
set(gca,'XDir','reverse');
xlim(yl)
set(gca,'xticklabel',[])
fs=8;
for i=1:numel(ptiles)
    line(s2_ptiles([i i]),ylim,...
        'color','k',...
        'linestyle',':')
end
axis off
axis off
%%
subplot(main_plot)
box on
l=legend(leg(1:2),'box','on');
l.Position(1)=1-l.Position(3);
l.Position(2)=0.03;
xlim(xl)
ylim(yl)
%%
subplot(sample1_plot)
title({'Out of sample','mean absosule error'})
%%
subplot(main_plot)
xlabel(mae_names{1})
set(gca,'XAxisLocation','Bottom')

ylabel(mae_names{2})
set(gca,'YAxisLocation','Left')
%%
yl=get(gca,'ytick');
axis_label=set_axis_label(yl);
set(gca,'yticklabel',axis_label)

xl=get(gca,'xtick');
axis_label=set_axis_label(xl);
set(gca,'xticklabel',axis_label)
colormap hsv
%% add legends
%%
filename=['summary_scatter' suffix_name];
set(gcf,'name',filename)
saveas(gcf,[local_folder filesep filename])
print([local_folder filesep filename],'-dpng','-r300')
print([local_folder filesep filename],'-dtiffn','-r300')
