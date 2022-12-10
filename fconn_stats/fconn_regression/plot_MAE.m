function plot_MAE(MAE,varargin)


%% Define defaults
up_to=5;
suffix_fig_name=[];
%% Read extra input arguments, if provided
v = length(varargin);

q=1;
while q<=v
    switch lower(varargin{q})
        case 'up_to'
            up_to=varargin{q+1};
            q = q+1;
            
        case 'suffix_fig_name'
            suffix_fig_name=varargin{q+1};
            q = q+1;
 
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
%%



y=MAE{:,4:end};
ymin=MAE{:,1};
n_comp_min=MAE{:,2};
n_func_pairs=size(y,1);
if n_func_pairs<up_to
    up_to=n_func_pairs;
end
%%
fig_size=[8 8 22 12];% cm
fig_size=[8 1 12 8];% cm

vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
%%

my_color=[0 0 0
    230 159 0
    86 180 233
    0 158 115
    0 114 178
    213 94 0
    204 121 167]/255;
if up_to>size(my_color,1)
    my_color=parula(up_to);
end

lw=2;
x=1:size(y,2);
i=1;
subplot('position',[.3 .15 .55 .8])
plot(x,y(i,:),'color',my_color(i,:),'linewidth',lw)
xlabel('Components')
ylabel('mae')
hold all
for i=2:up_to
    plot(x,y(i,:),'color',my_color(i,:),'linewidth',lw)
end
yl=ylim;
yt=linspace(yl(1),yl(end),up_to);
% [b ix]=sort(y(1:up_to,1));
[~,ii]=sort(y(1:up_to,1));
[~,r]=sort(ii);
for i=1:up_to
    scatter(n_comp_min(i),ymin(i),60,my_color(i,:),'filled')
    scatter(n_comp_min(i),ymin(i),5,'w','filled')
%     text(0,y(i,1),[' ' num2str(i) ') ' MAE.Properties.RowNames{i}],'color',my_color(i,:),'HorizontalAlignment','right')
    text(0,yt(r(i)),[' ' num2str(i) ') ' MAE.Properties.RowNames{i}],'color',my_color(i,:),'HorizontalAlignment','right')
    text(n_comp_min(i),yl(1),num2str(n_comp_min(i)),'VerticalAlignment','bottom','HorizontalALignment','center','fontsize',8,'color',my_color(i,:))
    line([n_comp_min(i) n_comp_min(i)],[yl(1) ymin(i)],'color',my_color(i,:),'LineStyle',':','linewidth',1)
%     line([0 0],[yt(r(i)) y(1,i)],'color',my_color(i,:))
%     num2format_text(m(i),'0.2')
end
hold off
box off
set(gca,'yaxislocation','right')

xlim([0 x(end)])
yl=get(gca,'ytick');
axis_label=set_axis_label(yl);
set(gca,'yticklabel',axis_label)
integer_ticks()
%% add lines
yl=ylim;
line([0 1],yl([1 1]),'color','w')
for i=1:up_to
    line([0 .9],[yt(r(i)) y(i,1)],'color',my_color(i,:))
end
%%
% legend(MAE.Properties.RowNames{1:up_to})
fig_name=['MAE_top' num2str(up_to) suffix_fig_name];
saveas(gcf,fig_name)
img = getframe(gcf);
imwrite(img.cdata, [fig_name, '.png']);
