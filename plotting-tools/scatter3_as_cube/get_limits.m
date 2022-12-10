function xy_lims=get_limits(x,y)


fig_size=[1 1 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
plot(x,y,'.')
axis_room
xl=xlim;
yl=ylim;
close(f)

xy_lims=[xl;yl];