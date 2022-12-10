function [cat_mae,cat_n_comp,labels,N,d]=scout_components(cat_local_table,cat_local_within_headers,cat_up_to_components,local_y,fconn_reg_options)


n_NN=size(cat_local_table,1);
cat_mae=cell(n_NN,1);
cat_n_comp=cell(n_NN,1);
labels=cell(n_NN,1);
d=nan(n_NN,1);
for i=1:n_NN
    local_main_table=cat_local_table{i};
    local_within_headers=cat_local_within_headers{i};
    local_n_comp=numel(cat_up_to_components{i});
    local_mae=nan(local_n_comp,1);
    for n_comp=cat_up_to_components{i}
        display(['Running component ' num2str(n_comp) ' out of ' num2str(cat_up_to_components{i}(end)) ', system ' num2str(i) ' out of ' num2str(n_NN)])
        fconn_reg_options.components=n_comp;
        fconn_reg_options_scout=fconn_reg_options;
        fconn_reg_options_scout.N_Null=10;
        [performance,Weights,local_labels]=fconn_regression(local_main_table, local_within_headers,local_y,fconn_reg_options_scout);
        local_mae(n_comp)=nanmean(performance{1}.alt.mae);
    end
    cat_mae{i}=local_mae;
    cat_n_comp{i}=cat_up_to_components{i};
    labels{i}=local_labels;
    
    
    %% run null 
    display (['Running null for ' char(labels{i})])
    display(['System ' num2str(i) ' out of ' num2str(n_NN)])
    [b n_comp]=min(local_mae);
    fconn_reg_options.components=n_comp;
    [performance,Weights,local_labels]=fconn_regression(local_main_table, local_within_headers,local_y,fconn_reg_options);
    x1=performance{1}.alt.mae;
    x2=performance{1}.null.mae;
    d(i)=computeCohen_d(x2,x1);
    cost_function_name='mae';
    fig_name=char(labels{i});
    fig_name=strrep( fig_name , ' ' , '_' );
    
    fig_cohen=plot_cohen(d(i),labels{i},performance,cost_function_name,fig_name);
    close(fig_cohen)
    display(['Done with system ' num2str(i) ' out of ' num2str(n_NN)])
    
end
N=size(Weights{1},1);% recalculating the real value of N
