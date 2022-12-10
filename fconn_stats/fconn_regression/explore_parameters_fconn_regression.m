function explore_parameters_fconn_regression(main_table,within_headers,y,options,validation_table,y2)

if nargin < 4
    options=[];
end


%%
two_samples_flag=0;
preffix='one_sample';
if nargin == 6
    
    two_samples_flag=1;
    preffix='two_samples';
    if size(main_table,2)~=size(validation_table,2)
        error('Check size of provided tables')
    end
end
two_samples_flag=two_samples_flag==1;
%%
wd=[pwd filesep preffix];
mkdir(wd)
cd(wd)

%% read options
options = read_options_explore_parameters_fconn_regression(options);

if two_samples_flag
    options.out_for_xval=1;
end

out_for_xval=options.out_for_xval;
n_comp_to_keep=options.n_comp_to_keep;
zscoring=options.zscoring;

save_data=options.save_data;

%% Make for loops for each case
for N = options.N(:)'
    fconn_reg_options.N=N;
    
    for N_Null = options.N_Null(:)'
        fconn_reg_options.N_Null=N_Null;
        
        for out=out_for_xval
            fconn_reg_options.xval_left_N_out=out;
            
            for n_comp=n_comp_to_keep
                fconn_reg_options.components=n_comp;
                
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
                    
                    try
                        
                        if two_samples_flag
                            
                            [performance,Weights,labels,P,Y]=fconn_regression_two_samples(main_table, within_headers,local_y,fconn_reg_options,validation_table,local_y2);
                            
                        else
                            [performance,Weights,labels,P,Y]=fconn_regression(main_table, within_headers,local_y,fconn_reg_options);
                        end
                        
                        N=size(Weights{1},1);% recalculating the real value of N
                        
                        to_encode_names_in_folder_name(1).name='rep';
                        to_encode_names_in_folder_name(1).value=num2str(N);
                        to_encode_names_in_folder_name(2).name='null';
                        to_encode_names_in_folder_name(2).value=num2str(N_Null);
                        to_encode_names_in_folder_name(3).name='out';
                        to_encode_names_in_folder_name(3).value=num2str(out);
                        to_encode_names_in_folder_name(4).name='n_comp';
                        to_encode_names_in_folder_name(4).value=num2str(n_comp);
                        to_encode_names_in_folder_name(5).name='transformed_outcome';
                        to_encode_names_in_folder_name(5).value=num2str(ZSCORE);
                        %                         switch ZSCORE
                        %                             case 0
                        %                                 to_encode_names_in_folder_name(5).value='no';
                        %                             case 1
                        %                                 to_encode_names_in_folder_name(5).value='zscore';
                        %                             case 2
                        %                                 to_encode_names_in_folder_name(5).value='boxcox';
                        %                         end
                        %
                        
                        save_folder=encode_for_loop_variables_as_folder_name(wd,to_encode_names_in_folder_name);
                        mkdir (save_folder)
                        cd(save_folder)
                        
                        if two_samples_flag
                            plot_only_R_two_samples(performance,Weights,labels,P,Y)
                        else
                            pull_data_show_results(performance,Weights,labels,P)
                            plot_only_R(performance,Weights,labels,P,Y)
                        end
                        
                        
                        close all
                        
                        if save_data==1
                            save_planB(['pred_results_performance.mat'],performance)
                            save_planB(['pred_results_Weights.mat'],Weights)
                            save_planB(['pred_results_labels.mat'],labels)
                            save_planB(['pred_results_P.mat'],P)
                            save_planB(['pred_results_Y.mat'],Y)
                            save_planB(['pred_results_.mat'],local_y)
                            save_planB(['pred_results_local_y.mat'],main_table)
                            save_planB(['pred_results_within_headers.mat'],within_headers)
                            save_planB(['pred_results_fconn_reg_options.mat'],fconn_reg_options)
                        end
                        display(['done'])
                        cd (wd)
                    end
                end
            end
        end
    end
end



%% pull data and make summary

if two_samples_flag==0
    fconn_reg_settings_labels{1}='rep_';
    fconn_reg_settings_labels{2}='_null_';
    fconn_reg_settings_labels{3}='_out_';
    fconn_reg_settings_labels{4}='_n_comp_';
    fconn_reg_settings_labels{5}='_transformed_outcome_';
    
    local_dir=wd; % reusing variables
    text_for_dir=[local_dir filesep '*'];
    path_to_file=['cat_results.csv'];
    delete(path_to_file)
    tall_table=read_combine_R_p_and_Cohen(text_for_dir,fconn_reg_settings_labels);
    
    writetable(tall_table,path_to_file)
end
%% Visualize results
if two_samples_flag==0
    column_x=13;
    columns_to_sort_by=[10:12 14];
    columns_to_sort_by=[11:12 14];% to make it work ignoring N
    for p_corrected_flag=[0 1]
        summarize_cat_data(path_to_file,column_x,columns_to_sort_by,p_corrected_flag);
        close all
    end
end
%% added since nesting was added with preffix (nse sample, two samples)
cd ..
