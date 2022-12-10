function do_showM_communities(R,local_label,idx,external_cmap,...
    output_folder,...
    res,...
    save_flag)

% imagesc(R)
n_colors=256;
cmap=(hot(n_colors));
cmap1=(hot(n_colors));
cmap2=(hot(4*n_colors));
camp3=summer(n_colors/64);
camp3=camp3(end:-1:end/2,:);
% colormap(cmap([1:round(n_colors*.7) round(n_colors*.85):round(n_colors*.9)],:))
% % colormap([cmap1([1:round(n_colors*.7) ],:);cmap2([round(2*n_colors*.9) :round(2*n_colors*.95)],:)])
% colormap([cmap([1:round(n_colors*.7)],:);camp3])
% colormap([cmap([1:round(n_colors*.7) round(n_colors*.85):round(n_colors*.9)],:);cmap2(end*.8:end*.9,:)])
[u,nu,ix,nix]=find_uniques(idx);

parcel(nu).n=[];
parcel(nu).ix=[];
parcel(nu).shortname=[];
csum=cumsum(nix)+.5;
offset=0;
for i=1:nu
    parcel(i).n=nix(i);
    parcel(i).shortname=num2str(i);
    parcel(i).ix=[1:nix(i)]+offset;
    offset=nix(i);
end

force_diag_to_be_zero_flag=0;
one_side_labels=1;
clims=[-1 1];
showM(R,...
    'force_diag_to_be_zero_flag',force_diag_to_be_zero_flag,...
    'one_side_labels',one_side_labels,...
    'clims',clims);
colormap([cmap([1:round(n_colors*.7)],:);camp3])
if prctile(R(:),50)<.75
    colormap (neg_pos_cmap)
end
if ~isempty(external_cmap)
    colormap(external_cmap)
end
lw=2;
for i=1:nu
    xline([csum(i)],...
        'linewidth',lw)
    yline([csum(i)],...
        'linewidth',lw)
end
set(gca,'ytick',csum)
set(gca,'xtick',csum)
title(local_label)
set(gca,'xtick',csum,'TickDir','both')
set(gca,'ytick',csum,'TickDir','both')
%% add labels
for i=1:nu
    xpos=csum(i)-nix(i)/2;
    text(xpos,csum(end),num2str(nix(i)),...
        'fontsize',8,...
        'VerticalAlignment','Top',...
        'HorizontalAlignment','Center')
    ylab=['G ' num2str(u(i))];
    if and (i==nu,nix(end)>nix(end-1))
        ylab=['\fontsize{7}others'];
    end
    text(0,xpos,ylab,...
        'fontsize',8,...
        'HorizontalAlignment','Right')
end
if isnumeric(local_label)
    local_label=num2str(local_label);
end
if iscell(local_label)
    local_label=local_label{:};
end

%% rewrite text in the bottom bar
h=get(gcf,'children');
subplot(h(1));
% set(gca,'xtick',[-1 -.5 0 .5 1])
xl=get(gca,'xtick');

set(gca,'xtick',xl);
try
    axis_label=set_axis_label(xl); 
    set(gca,'Xticklabel',axis_label)
end
%%

fig_name=['Distance_matrix_' local_label];
if save_flag
    save_fig(fig_name,...
        'res',res,...
        'path_to_save',output_folder)
end