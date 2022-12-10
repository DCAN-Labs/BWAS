function scatter_fconn_outcome(main_table,within_headers,y,options,y_color)

if nargin < 4
    options=[];
end

%%
% wd=pwd;
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

out_for_xval=options.out_for_xval;
n_comp_to_keep=options.n_comp_to_keep;
zscoring=options.zscoring;

save_data=options.save_data;

%% Make for loops for each case


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
        
        
        
        %         to_encode_names_in_folder_name(1).name='rep';
        %         to_encode_names_in_folder_name(1).value=num2str(N);
        %         to_encode_names_in_folder_name(2).name='null';
        %         to_encode_names_in_folder_name(2).value=num2str(N_Null);
        %         to_encode_names_in_folder_name(3).name='out';
        %         to_encode_names_in_folder_name(3).value=num2str(out);
        %         to_encode_names_in_folder_name(4).name='n_comp';
        %         to_encode_names_in_folder_name(4).value=num2str(n_comp);
        to_encode_names_in_folder_name(1).name='transformed_outcome';
        to_encode_names_in_folder_name(1).value=num2str(ZSCORE);
        
        local_wd=[wd filesep 'scatter_fconn_outcome'];
        save_folder=encode_for_loop_variables_as_folder_name(local_wd,to_encode_names_in_folder_name);
        mkdir (save_folder)
        cd(save_folder)
        [X, labels]=get_fconn_labels(main_table, within_headers);
        
        %         scatter_first_component_y(Xscores,labels,local_y,y_color)
        plot_scatter_fconn_outcome(X,labels,local_y,y_color)
        
        close all
        
        
        display(['done'])
        cd (wd)
        cd ..
    end
end



%% pull data and make summary


