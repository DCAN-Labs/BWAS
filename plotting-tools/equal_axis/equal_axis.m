function equal_axis()

xl=xlim;
yl=ylim;
% xyl=[min([xl(1) yl(1)])  max([xl(2) yl(2)])];

temp=max(abs([xl yl]));
xyl=[-temp temp];



xlim(xyl)
ylim(xyl)

% axis equal

xt=get(gca,'xtick');
yt=get(gca,'ytick');
xyt=unique(sort([xt(:); yt(:)]))';
axis_label=set_axis_label(xyt);

set(gca,'xtick',xyt)
set(gca,'ytick',xyt)

set(gca,'xticklabel',axis_label)
set(gca,'yticklabel',axis_label)