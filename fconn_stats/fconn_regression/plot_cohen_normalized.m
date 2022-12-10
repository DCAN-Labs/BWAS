function plot_cohen(d,labels,performance,cost_function_name,fig_name)
% Oscar Miranda Dominguez

%%
fs_title=9;
fs_labels=8;
to_include=99.9;% percentile
to_include=95;% percentile
%%
n=numel(d);
ns=ceil(sqrt(n));

[b ix]=sort(d,'descend');


%%
chunk=3.5;
offset=1;

xy=ns*chunk+offset;

fig_size=[8 1 xy xy];
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
%%
for i=1:n
    subplot(ns,ns,i)
    
    switch cost_function_name
        case 'R'
            foo{1}=performance{ix(i)}.alt.R;
            foo{2}=performance{ix(i)}.null.R;
            
        case 'mse'
            foo{1}=performance{ix(i)}.alt.mse;
            foo{2}=performance{ix(i)}.null.mse;
            
        case 'mae'
            foo{1}=performance{ix(i)}.alt.mae;
            foo{2}=performance{ix(i)}.null.mae;
            
        case 'mape'
            foo{1}=performance{ix(i)}.alt.mape;
            foo{2}=performance{ix(i)}.null.mape;
    end
    
    %% clean outliers
    
    
    y=[foo{1}; foo{2}];
    
    y=[foo{2}; foo{1}];% inverting order to show alt first
y_boxcox=boxcox_transform(y);

n1=numel(foo{1});
foo_boxcox=foo;
foo_boxcox{1}=y_boxcox(1:n1);
foo_boxcox{2}=y_boxcox(n1+1:end);
    
    %% plot
    options.n_bins=21;
custom_hist(foo_boxcox,options)
    title({[num2str(i) ') ' labels{ix(i)}],['d = ' num2str(d(ix(i)),'%4.2f')]},...
        'fontsize',fs_title)
    
    set(gca,'ytick',[])
    axis tight
    xl=xlim;
    delta=diff(xl);
    inc=0.05;
    xl(1)=xl(1)-delta*inc;
    xl(2)=xl(2)+delta*inc;
    xlim(xl);
    xlabel(cost_function_name,...
        'fontsize',fs_labels)
    
    ylabel('Rel. abund.',...
        'fontsize',fs_labels)
    
end
%  subplot(ns,ns,i+1)
%  plot([1 1],[2 2])
% legend({'alt','null'})

folder_rf=pwd;
local_fig_name=[fig_name '_norm_errors'];

saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
% print([folder_rf filesep local_fig_name],'-dtiffn','-r300')