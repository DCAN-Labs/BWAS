function show_1_dist_performance(perf,nn_label,p,cost_function_to_use)


if nargin<4
    cost_function_to_use=3;
end
xlab=cell(4,1);

xlab{1}='Correlations';
xlab{2}='Mean Square Error';
xlab{3}='Mean Absolute Error';
xlab{4}='Mean Absolute Percent Error';
%%
outcomes=fieldnames(perf.alt);
n_outcomes=length(outcomes);

%%
FaceColor=[251,154,153]/255;
EdgeColor=[231,41,138]/255;
% lineColor=[51,160,44]/255;
lineColor=[8,29,88]/255;
FaceAccept=[178,223,138]/255;

FA=0.67;
n_points=1e4;
lw=3;
for i=cost_function_to_use
    
    x_alt=getfield(perf.alt,outcomes{i});
    x_null=getfield(perf.null,outcomes{i});
    
    
%     subplot (1,n_outcomes-1,i);
    h=histogram(x_null);
    h.FaceColor = 'w';
    h.EdgeColor = 'k';
    set(gca,'yticklabel',[])
    
    
    
    
    title({nn_label, outcomes{i}})
    xlabel(xlab{i})
    
    
    xl=xlim;

    
    [reject, accept,th]=get_reject_accept(x_null,outcomes{i});
    [xi,yi]=interpolate_hist(h,xl,n_points);
    
    ix_r=get_x_y_patch(xi,reject);
    ix_a=get_x_y_patch(xi,accept);
    
    xpr=xi(ix_r);
    ypr=yi(ix_r);
    ypr([1 end])=0;
    patch(xpr,ypr,FaceColor,...
        'EdgeColor',FaceColor,...
        'FaceAlpha',FA)
    
    xpa=xi(ix_a);
    ypa=yi(ix_a);
    ypa([1 end])=0;
    patch(xpa,ypa,FaceAccept,...
        'EdgeColor',FaceAccept,...
        'FaceAlpha',FA)
    
    lineColor=[231,41,138]/255;
    if p{i}.c<.05
        lineColor=[0,69,41]/255;
    
    end
        
    

    
    line([1 1]*x_alt,ylim,...
        'color',lineColor,...
        'linewidth',lw)
    
    line([1 1]*th,ylim,...
        'linestyle',':',...
        'color','k')
    
    yl=ylim;
    
%     leg=legend('Null','Reject zone (95%)','Accept zone (5%)',['Prediction, ' num2str(x_alt,'%4.2f') ', p=' num2str(p{i}.c,'%4.2f')] ,['Th. for significance, ' num2str(th,'%4.2f')],...
%         'location','southoutside');
    
    leg=legend('Null','Reject zone (95%)','Accept zone (5%)',['Prediction, ' num2format_text(x_alt,'0.2') ', p=' num2format_text(p{i}.c,'0.2')] ,['Th. for significance, ' num2format_text(th,'%0.2')],...
        'location','southoutside');
    set(leg,'box','off');
    xl=get(gca,'xtick');
    axis_label=set_axis_label(xl);
    set(gca,'xticklabel',axis_label)

    ylim(yl)
   
end