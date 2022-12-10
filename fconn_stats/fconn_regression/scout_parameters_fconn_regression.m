function scout_parameters_fconn_regression(main_table,within_headers,y,options,validation_table,y2)
%% This function explore all the possible components for each functional system
%%
if nargin < 4
    options=[];
end


%%
two_samples_flag=0;
preffix='scout_1_sample';
preffix_2_samples='optimized_2_samples';
if nargin == 6
    
    two_samples_flag=1;
    if size(main_table,2)~=size(validation_table,2)
        error('Check size of provided tables')
    end
end
two_samples_flag=two_samples_flag==1;
%%
home_dir=[pwd filesep 'scout'];
wd=[home_dir filesep preffix];
mkdir(wd)
cd(wd)

%% read options
options = read_options_explore_parameters_fconn_regression(options);

% if two_samples_flag
%     options.out_for_xval=1;
% end

out_for_xval=options.out_for_xval;
n_comp_to_keep=options.n_comp_to_keep;
zscoring=options.zscoring;

save_data=options.save_data;
%% count cases will be explored
n_loops=count_loops(options.N(:),out_for_xval,zscoring);
save_folder=cell(n_loops,1);
MAE_cell=cell(n_loops,1);
%% Make for loops for each case
i=0;

for N = options.N(:)'
    fconn_reg_options.N=N;
    
    for out=out_for_xval
        fconn_reg_options.xval_left_N_out=out;
        
        for ZSCORE=zscoring
            
            switch ZSCORE
                case 0
                    local_y=y;
                    if two_samples_flag
                        local_y2=y2;
                    end
                case 1
                    local_y=zscore(y);
                    if two_samples_flag
                        local_y2=zscore(y2);
                    end
                case 2
                    local_y=boxcox_transform(y);
                    if two_samples_flag
                        local_y2=boxcox_transform(y2);
                    end
            end
            
            %             try
            i=i+1;
            
            
            
            
            local_fconn_reg_options=fconn_reg_options;
            local_fconn_reg_options.N_Null=options.N_Null(:)';
            
            
            [cat_local_table,cat_local_within_headers,cat_components]=prep_scout(main_table, within_headers,local_fconn_reg_options);
            cat_components = truncate_components(cat_components,options);
            [cat_mae,cat_n_comp,labels,NN,d]=scout_components(cat_local_table,cat_local_within_headers,cat_components,local_y,local_fconn_reg_options);
            
            
            to_encode_names_in_folder_name(1).name='rep';
            to_encode_names_in_folder_name(1).value=num2str(NN);
            to_encode_names_in_folder_name(2).name='out';
            to_encode_names_in_folder_name(2).value=num2str(out);
            to_encode_names_in_folder_name(3).name='transformed_outcome';
            to_encode_names_in_folder_name(3).value=num2str(ZSCORE);
            %
            
            save_folder{i}=[encode_for_loop_variables_as_folder_name(wd,to_encode_names_in_folder_name)];
            
            mkdir (save_folder{i})
            movefile('*fig',save_folder{i});
            movefile('*png',save_folder{i});
            cd(save_folder{i})
            %                 fconn_reg_options.N=NN;
            
            
            [MAE]=report_components(cat_mae,cat_n_comp,labels,d);
            MAE_cell{i}=MAE;
            suffix_fig_name=['_out_' num2str(out)];
            plot_MAE(MAE,'suffix_fig_name',suffix_fig_name)
            %                 plot_MAE(MAE,15)
            writetable(MAE,'MAE.csv','WriteRowNames',true)
            
            save('MAE.mat','MAE')
            %                 close all
            
            
            display(['done'])
            cd (wd)
            %             end
        end
    end
end


%% added since nesting was added with preffix (nse sample, two samples)
cd (home_dir)
%% Get and Save summary results
cat_MAE=concatenate_MAE(MAE_cell,out_for_xval);
cat_MAE_tidy=concatenate_MAE_tidy(MAE_cell,out_for_xval);
writetable(cat_MAE,'cat_MAE_1_sample_support.csv','WriteRowNames',true)
writetable(cat_MAE_tidy,'cat_MAE_1_sample.csv','WriteRowNames',true)
save('using_1_sample.mat','cat_MAE','cat_MAE_tidy');
%%
if two_samples_flag
    save_folder_2_samples=strrep(wd,preffix,preffix_2_samples);
    mkdir (save_folder_2_samples)
    cd(save_folder_2_samples)
    
    fconn_reg_options.N_Null=options.N_Null(:)';
    
    [resorted_cat_local_table,resorted_cat_local_within_headers]=resort_table_by_sorted_table(cat_local_table,cat_local_within_headers,cat_MAE);
    [cat_local_table2,cat_local_within_headers2]=prep_scout(validation_table, within_headers,fconn_reg_options);
    [resorted_cat_local_table2,resorted_cat_local_within_headers2]=resort_table_by_sorted_table(cat_local_table2,cat_local_within_headers2,cat_MAE);
    cat_optimal_components = get_cat_components_from_cat_MAE(cat_MAE);
    [xval_MAE,xval_MAE_p_closed_form,xval_MAE_p_by_null_cummulative_dist]=scout_components_two_samples(resorted_cat_local_table,resorted_cat_local_within_headers,cat_optimal_components,local_y,fconn_reg_options,resorted_cat_local_table2,local_y2);
    xval_MAE_with_ranks=add_ranks_MAE(cat_MAE_tidy,xval_MAE);
    xval_MAE_with_ranks_p_closed_form=add_ranks_MAE(cat_MAE_tidy,xval_MAE_p_closed_form);
    xval_MAE_with_ranks_p_by_null_cummulative_dist=add_ranks_MAE(cat_MAE_tidy,xval_MAE_p_by_null_cummulative_dist);
    
    plot_component_outcome_2_samples(resorted_cat_local_table,resorted_cat_local_within_headers,cat_optimal_components,local_y,fconn_reg_options,resorted_cat_local_table2,local_y2)
    
    cd (home_dir)
    summary_table_folder=[home_dir filesep 'summary_tables'];
    if ~isdir(summary_table_folder)
        mkdir(summary_table_folder)
    end
    cd (summary_table_folder)
    writetable(xval_MAE,'cat_MAE_2_samples_support.csv','WriteRowNames',true)
    writetable(xval_MAE_with_ranks,'cat_MAE_2_samples.csv','WriteRowNames',true)
    writetable(xval_MAE_p_closed_form,'cat_MAE_2_samples_support_p_closed_form.csv','WriteRowNames',true)
    writetable(xval_MAE_with_ranks_p_closed_form,'cat_MAE_2_samples_p_closed_form.csv','WriteRowNames',true)
    writetable(xval_MAE_p_by_null_cummulative_dist,'cat_MAE_2_samples_support_p_by_null_cummulative_dist.csv','WriteRowNames',true)
    writetable(xval_MAE_with_ranks_p_by_null_cummulative_dist,'cat_MAE_2_samples_p_by_null_cummulative_dist.csv','WriteRowNames',true)
    
    
    
    cat_results_samples_1_2 = cat_samples_1_2(cat_MAE_tidy,xval_MAE_with_ranks);
    filename_cat_results_samples_1_2=[summary_table_folder filesep 'cat_results_samples_1_2.csv'];
    writetable(cat_results_samples_1_2,filename_cat_results_samples_1_2,'WriteRowNames',true)
    save('using_2_sample.mat','cat_results_samples_1_2','xval_MAE','xval_MAE_with_ranks');
    
    cat_results_samples_1_2_p_closed_form = cat_samples_1_2(cat_MAE_tidy,xval_MAE_with_ranks_p_closed_form);
    filename_cat_results_samples_1_2_p_closed_form=[summary_table_folder filesep 'cat_results_samples_1_2_p_closed_form.csv'];
    writetable(cat_results_samples_1_2_p_closed_form,filename_cat_results_samples_1_2_p_closed_form,'WriteRowNames',true)
    save('using_2_sample_p_closed_form.mat','cat_results_samples_1_2_p_closed_form','xval_MAE_p_closed_form','xval_MAE_with_ranks_p_closed_form');
    
    cat_results_samples_1_2_p_by_null_cummulative_dist = cat_samples_1_2(cat_MAE_tidy,xval_MAE_with_ranks_p_by_null_cummulative_dist);
    writetable(cat_results_samples_1_2_p_by_null_cummulative_dist,'cat_results_samples_1_2_p_by_null_cummulative_dist.csv','WriteRowNames',true)
    save('using_2_sample_p_by_null_cummulative_dist.mat','cat_results_samples_1_2_p_by_null_cummulative_dist','xval_MAE_p_by_null_cummulative_dist','xval_MAE_with_ranks_p_by_null_cummulative_dist');
    
    
    cd (home_dir)
    filename_cat_results_samples_1_2_p_by_null_cummulative_dist=[home_dir filesep 'cat_results_samples_1_2_p_by_null_cummulative_dist.csv'];
    writetable(cat_results_samples_1_2_p_by_null_cummulative_dist,filename_cat_results_samples_1_2_p_by_null_cummulative_dist,'WriteRowNames',true)
    save('using_2_sample_p_by_null_cummulative_dist.mat','cat_results_samples_1_2_p_by_null_cummulative_dist','xval_MAE_p_by_null_cummulative_dist','xval_MAE_with_ranks_p_by_null_cummulative_dist');
    clc
    
    
    add_show_W_two_samples(filename_cat_results_samples_1_2_p_by_null_cummulative_dist)
    add_show_W_two_samples(filename_cat_results_samples_1_2_p_closed_form)
    add_show_W_two_samples(filename_cat_results_samples_1_2)
    cat_results_samples_1_2_p_by_null_cummulative_dist
else
    cat_MAE
    
    
    
end
