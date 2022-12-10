function [h, data, sim_options,local_fconn_reg_options]=prelims_to_sim_performance(path_surrogated_data,path_pred_results,parcel,system_pair,varargin)

%% Load and symmetrice fconn matrix
display('Loading surrogate data');
load(path_surrogated_data)
M1=symmetryze_M(fconn);
n=size(M1,3);

%% Make table, net and within design
display('Converting surrogate data to table');
clear between_design
between_design(1).name='CT';
between_design(1).subgroups(1).name='simulated';
between_design(1).subgroups(1).ix=1:n;
between_design(1).subgroups(1).color=[1 1 1]*0;


within_design=[];

clear options
options.boxcox_transform=0;
options.calculate_Fisher_Z_transform=0;
options.resort_parcel_order=1:13;
% options.resort_parcel_order=[8 9 10 11 5];
% options.resort_parcel_order=[6  13];
[simulated_main_table, within_headers, options, r,c] = extract_NN_table(M1,parcel,between_design,within_design,options);
within_headers_all_all=within_headers;

%% Read varargin
%% Define default options
ss_to_explore=[10 20:10:40 60:20:120];
n_rep=100;
add_noise_flag=0;
xval_for_sim='ratio';%'ratio or same'
save_data_flag=1;
%% Read varargin

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'ss_to_explore'
            ss_to_explore=varargin{q+1};
            q = q+1;
            
        case 'n_rep'
            n_rep=varargin{q+1};
            q = q+1;
            
            
        case 'add_noise_flag'
            add_noise_flag=varargin{q+1};
            q = q+1;
            
        case 'xval_for_sim'
            xval_for_sim=varargin{q+1};
            q = q+1;
            
        case 'save_data_flag'
            xval_for_sim=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

add_noise_flag=add_noise_flag==1;
save_data_flag=save_data_flag==1;
%% Make folfer and move there for saving
wd=pwd;

try
    sys_pair=strrep(system_pair{:},' ','_');
catch
    sys_pair=strrep(system_pair,' ','_');
end

to_encode_names_in_folder_name(1).name='system_pair';
to_encode_names_in_folder_name(1).value=sys_pair;
to_encode_names_in_folder_name(2).name='n_rep';
to_encode_names_in_folder_name(2).value=num2str(n_rep);
to_encode_names_in_folder_name(3).name='add_noise_flag';
to_encode_names_in_folder_name(3).value=num2str(add_noise_flag);
to_encode_names_in_folder_name(4).name='xval_for_sim';
to_encode_names_in_folder_name(4).value=num2str(xval_for_sim);

% to_encode_names_in_folder_name(5).name='transformed_outcome';
% to_encode_names_in_folder_name(5).value=num2str(ZSCORE);

save_folder=encode_for_loop_variables_as_folder_name(wd,to_encode_names_in_folder_name);
mkdir (save_folder)
cd(save_folder)
%% Run the test
display('Sending data to main function to run the test');
[h, data, sim_options,local_fconn_reg_options]=simulate_fconn_regression_performance(path_pred_results,simulated_main_table,within_headers,system_pair,...
    'n_rep',n_rep,...
    'add_noise_flag',add_noise_flag,...
    'xval_for_sim',xval_for_sim,...
    'ss_to_explore',ss_to_explore);

%% Save figure

local_fig_name=h.Name;
saveas(h,[save_folder filesep local_fig_name])
print([save_folder filesep local_fig_name],'-dpng','-r300')
%% Save data of asked
if save_data_flag
    filename=[save_folder filesep local_fig_name '.mat'];
	try
		save(filename,'data','sim_options','local_fconn_reg_options','system_pair')
	catch
		save(filename,'data','sim_options','local_fconn_reg_options','system_pair','-v7.3')
	end
end

cd(wd)