function plot_scatter_fconn_outcome(Xscores,labels,local_y,y_color)

n=size(labels,1);
local_P=zeros(n,1);



%%


fig_size=[2 2 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
species=table2array(y_color(:,1));
my_color=table2array(y_color(:,2:end));
my_color=unique(my_color,'rows','stable');
ms=8;
fs_title=10;
fs_text=8;

ptiles=[25 75;2.5 97.5];
n_subjects=size(local_y,1);
for k=1:n
    x=Xscores{k};
    ix=cell(n_subjects,1);
    l=zeros(n_subjects,2);
    L=zeros(n_subjects,2);
    m=mean(x,2);
    
    plot(local_y,m,'.w')
    hold all
    
    for kk=1:n_subjects
        med(kk)=median(x(kk,:));
        m(kk)=nanmean(x(kk,:));
        L(kk,:)=prctile(x(kk,:),ptiles(1,:));
        l(kk,:)=prctile(x(kk,:),ptiles(2,:));
        
        local_color=table2array(y_color(kk,2:end));
        
        plot(local_y(kk),m(kk),'o',...
            'MarkerFaceColor',local_color,...
            'MarkerEdgeColor',local_color,...
            'markersize',ms)
        
        line(local_y([kk kk]),l(kk,:),...
            'color',local_color)
        line(local_y([kk kk]),L(kk,:),...
            'color',local_color,...
            'linewidth',3)
        plot(local_y(kk),m(kk),'.w',...
            'markersize',ms/2)
        
    end
    hold off
    
    tit=labels{k};
    title(tit,...
        'fontsize',fs_title);
    
    ylabel('fconn',...
        'fontsize',fs_text);
    
    xlabel('outcome',...
        'fontsize',fs_text);
    
    fig_name=[labels{(k)}];
    fig_name(fig_name==' ')='_';
    set(f,'name',fig_name);
    
    f.InvertHardcopy = 'off';
    %     print(fig_name,'-dtiffn','-r300')
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
    
end

% my_color=y_color{:,2:end};
linecolor='k';
linewidth=1.5;
for k=1:n
    x=Xscores{k};
    ix=cell(n_subjects,1);
    l=zeros(n_subjects,2);
    L=zeros(n_subjects,2);
    m=nanmean(x,2);
    
    scatter(m,local_y);
    yl=ylim;
    [r p]=corr(m,local_y);
    h=lsline;
        xline=h.XData;
        yline=h.YData;
    scatterhist(m,local_y,'Group',species,'Kernel','on',...
            'color',my_color,...
            'LineStyle',{'-','-','-'},...
            'LineWidth',[2,2,2],...
            'Marker','...',...
            'MarkerSize',[1 1 1]*20);
        
        
        
        line(xline,yline,...
            'color',linecolor,...
            'linewidth',linewidth)
        box off
        ylim(yl)
        leg=get(gca,'legend');
        leg.String{end}='';
        set(leg,'box','off')
        leg_pos=get(leg,'position');
        leg_pos(1:2)=0;
        set(leg,'position',leg_pos);
        xlabel('Mean cort. thick.')
        ylabel('Outcome')
    
    
    
    title({labels{k},['\fontsize{8} R = ' num2format_text(r,'0.2'),', p = ' num2format_text(p,'0.3')]},...
                'Units', 'normalized', 'Position', [0.5, 1, 0])
        
    
   
    
    ylabel('Outcome',...
        'fontsize',fs_text);
    
    xlabel('Mean cort. thick.',...
        'fontsize',fs_text);
    
    fig_name=[labels{(k)} '_mean'];
    fig_name(fig_name==' ')='_';
    set(f,'name',fig_name);
    
    f.InvertHardcopy = 'off';
    %     print(fig_name,'-dtiffn','-r300')
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
    
end