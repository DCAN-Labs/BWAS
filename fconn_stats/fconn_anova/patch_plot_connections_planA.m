function patch_plot_connections_planA(T,m,between_design,options)

mk='O-';

lw=3;
% pth=0.05;
kk=0;
% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
offset_xlim=.2;
offset_ylim=.1;

vis_flag='on';
fig_size=[1 1 8 8];

fs_axis=9; %size of fonts in plots
fs_title=7;%size of fonts in title
fs_legend=10;
fs_label=12;
folder_rf='Plan_A_connection';
mkdir(folder_rf);

for j=1:size(T,1)
    
    ix=find(ismember(table2array(m(:,1)),table2array(T(j,1))));
    local_title=table2array(T(j,1));
    local_title=local_title{:};
    local_fig_name=local_title;
    
    local_m=m(ix,[2 3 4]);
    mm=table2array(local_m(:,2));
    se=table2array(local_m(:,3));
    
    min_y_plot=100;
    max_y_plot=-100;
    
    n_traces=size(mm,1);
    ii=1:n_traces;
    
    f = figure('Visible',vis_flag,...
        'Units','centimeters',...
        'PaperUnits','centimeters',...
        'name',local_fig_name,...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'color',[1 1 1]);
    
    plot(ii,mm,'w');
    hold all
    for ijk=1:n_traces%n_lines
        
        line([ijk;ijk],[mm(ijk)+tse*se(ijk) mm(ijk)-tse*se(ijk)]',...
            'color',between_design.subgroups(ijk).color,...
            'linewidth',lw)
        plot(ijk,mm(ijk),mk,...
            'color',between_design.subgroups(ijk).color,...
            'MarkerSize',6,...
            'linewidth',lw)
        plot(ijk,mm(ijk),mk,...
            'color','w',...
            'MarkerSize',2,...
            'linewidth',lw)
    end
    hold off
    foo1=([mm+tse*se mm-tse*se]);
    foo1=min(foo1(:));
    if foo1<min_y_plot
        min_y_plot=foo1;
    end
    
    foo2=([mm+tse*se mm-tse*se]);
    foo2=max(foo2(:));
    if foo2>max_y_plot
        max_y_plot=foo2;
    end
    
    delta=diff([min_y_plot max_y_plot])*.25;
    min_y_plot=min_y_plot-delta;
    ylim([min_y_plot max_y_plot])
    
    box on
    xlim([1 n_traces]);
    set(gca,'xtick',ii)
    set(gca,'xticklabel',table2array(local_m(:,1)))
    
    xl=xlim;
    dxl=abs(diff(xl));
    xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
    yl=ylim;
    dyl=abs(diff(yl));
    ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
    local_title(local_title=='_')=' ';
    title(local_title,...
        'fontsize',fs_title)
    
    yl=get(gca,'ytick');
    axis_label=set_axis_label(yl);
    set(gca,'yticklabel',axis_label)
    
    
    

    
    
    saveas(gcf,[folder_rf filesep local_fig_name])
    print([folder_rf filesep local_fig_name],'-dpng','-r300')
    print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
%     if figure_counter==1
        copyfile([folder_rf filesep local_fig_name '.png'],['summary' filesep]);
%     end
end
