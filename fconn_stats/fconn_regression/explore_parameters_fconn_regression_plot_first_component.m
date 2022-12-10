function explore_parameters_fconn_regression_plot_first_component(main_table,within_headers,y,options,y_color)

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
% wd=pwd;

%% read options
options = read_options_explore_parameters_fconn_regression(options);

out_for_xval=options.out_for_xval;
n_comp_to_keep=options.n_comp_to_keep;
zscoring=options.zscoring;

save_data=options.save_data;

%% Make for loops for each case
for N = options.N(:)'
    fconn_reg_options.N=N;
    
    for N_Null = options.N_Null(:)'
        fconn_reg_options.N_Null=N_Null;
        
        for out=1%out_for_xval% this is donw using only one component
            fconn_reg_options.xval_left_N_out=out;
            
            for n_comp=n_comp_to_keep
                fconn_reg_options.components=n_comp;
                
                for ZSCORE=zscoring
                    
                    switch ZSCORE
                        case 0
                            local_y=y;
                        case 1
                            local_y=zscore(y);
                        case 2
                            local_y=boxcox_transform(y);
                    end
                    
                    try
                        
%                         [performance,Weights,labels,P,Y]=get_first_component_fconn_regression(main_table, within_headers,local_y,fconn_reg_options);
                        [Xscores,labels,PCTVAR,Features,BETA]=get_first_component_fconn_regression(main_table, within_headers,local_y,fconn_reg_options);
                        
                        N=size(Xscores{1},1);% recalculating the real value of N
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
                        
                        scatter_first_component_y(Xscores,labels,local_y,y_color,...
                            'PCTVAR',PCTVAR,...
                            'Features',Features)
                        
                        close all
                        
                        %% save beta weights as table
                        for i=1:size(labels,1)
                            fig_name=['Beta-Weights_' labels{i}];
                            writematrix(BETA{i}(2:end),['Betaweights_' labels{i} '.csv'])
                            bar(BETA{i}(2:end))
                            title(['\beta-weights for ' labels{i}])
                            xlabel('Feature')
                            ylabel(['\beta-weight''s value']) 
                            set(gcf,'color','w')
                            saveas(gcf,fig_name)
                            print(fig_name,'-dpng','-r300')
                        end
                        close all
                        
                        
                       
                        display(['done'])
                        cd (wd)
                        cd ..
                    end
                end
            end
        end
    end
end



%% pull data and make summary


