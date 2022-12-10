function W=summary_scatter(X,Y,p,mae_names,local_folder)
%%
X_ptile=ecdf_unsorted(X);
Y_ptile=ecdf_unsorted(Y);
W=sqrt(X_ptile.^2+Y_ptile.^2);
% W=W./max(W);
%%

vis_flag='on';
fig_size=[1 1 8 8];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
%%
scatter(X,Y,[],W,'filled')
%%
n_dots=1e2;
[fX_linspace, X_linspace]=interpolate_ecdf(X,n_dots);
[fY_linspace, Y_linspace]=interpolate_ecdf(Y,n_dots);
%% need to add some random noise at the begining to deal with sorting
noise = @(x) x(1)*(1-1/(100*sum(x)));
fX_linspace(1)=noise(fX_linspace);
fY_linspace(1)=noise(fY_linspace);
%%

[XX_linspace,YY_linspace] = meshgrid(X_linspace,Y_linspace);
[fXX_linspace,fYY_linspace] = meshgrid(fX_linspace,fY_linspace);
Z=sqrt(fXX_linspace.^2+fYY_linspace.^2);
Z_ptile=ecdf_unsorted(Z);
%%
scatter(X,Y,[],W,'filled')
ptiles=[7.5 12.5 25 50 75];
% hold all
% % contour(XX_linspace,YY_linspace,Z_ptile,[5 10]/100)
% contour(XX_linspace,YY_linspace,100*Z_ptile,ptiles,...
%     'ShowText','on')
% hold off
%%
scatter(X,Y,[],W,'filled')
hold all
% contour(XX_linspace,YY_linspace,Z_ptile,[5 10]/100)
contour(XX_linspace,YY_linspace,Z,prctile(Z(:),ptiles))
hold off
xlabel(mae_names{1})
ylabel(mae_names{2})
title({'Out of sample','mean absosule error'})

yl=get(gca,'ytick');
axis_label=set_axis_label(yl);
set(gca,'yticklabel',axis_label)

xl=get(gca,'xtick');
axis_label=set_axis_label(xl);
set(gca,'xticklabel',axis_label)
colormap hsv
%%
filename='summary_scatter';
set(gcf,'name',filename)
saveas(gcf,[local_folder filesep filename])
print([local_folder filesep filename],'-dpng','-r300')
print([local_folder filesep filename],'-dtiffn','-r300')
