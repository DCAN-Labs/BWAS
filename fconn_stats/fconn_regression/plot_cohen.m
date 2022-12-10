function f=plot_cohen(d,labels,performance,cost_function_name,fig_name)
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
    
    
    temp=foo{2};
    local_limits=prctile(temp,to_include);
    
    temp(temp>=local_limits)=[];
    foo{2}=temp;
    %% reorder to show first alt hypothesis
    temp=foo;
    foo{1}=temp{2};
    foo{2}=temp{1};
    %% plot
    custom_hist(foo)
    title({[num2str(i) ') ' labels{ix(i)}],['d = ' num2str(d(ix(i)),'%4.2f')]},...
        'fontsize',fs_title)
    
    set(gca,'ytick',[])
    axis tight
    xl=xlim;
    xl(1)=0;
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
local_fig_name=fig_name;

saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
% print([folder_rf filesep local_fig_name],'-dtiffn','-r300')