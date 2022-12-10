function run_explore_fconn_regression(path_imaging_training,...
    path_demographics_Table_training,...
    path_dictionary_demographics_Table_training,...
    path_group_Design_Table_training,...
    path_parcellation_table,...
    varargin)
%% Credits
% Oscar Miranda-Dominguez
% First line of code: Nov 4, 2020

%% Define defaults

from_wd=pwd;
fs = filesep;

% Define outpur folder
output_folder=[pwd fs 'output_explore_fconn_regression'];

% Define default options
options = [];
user_provided_options_flag=0;

% Samples
two_samples_flag=0;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'path_Group_Color_Table'
            path_Group_Color_Table=varargin{q+1};
            Group_Color_Table_flag=1;
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;
            
        case 'path_imaging_prediction'
            two_samples_flag=1;
            path_imaging_prediction=varargin{q+1};
            q = q+1;
            
        case 'path_demographics_Table_prediction'
            two_samples_flag=1;
            path_demographics_Table_prediction=varargin{q+1};
            q = q+1;
            
        case 'path_dictionary_demographics_Table_prediction'
            two_samples_flag=1;
            path_dictionary_demographics_Table_prediction=varargin{q+1};
            q = q+1;
            
        case 'path_group_Design_Table_prediction'
            two_samples_flag=1;
            path_group_Design_Table_prediction=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;
two_samples_flag=two_samples_flag==1;
%% Move to output_folder

local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
cd(output_folder)

%% Load parcellation schema
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Bezgin.csv';
parcel=loadParcel(path_parcellation_table);

%% Load options

options=update_options(options);
[options] = read_options_fconn_anovas(options,parcel);
%% Set data for training
path_imaging=path_imaging_training;
path_dictionary_demographics_Table=path_dictionary_demographics_Table_training;
path_demographics_Table=path_demographics_Table_training;
path_group_Design_Table=path_group_Design_Table_training;
[X1,within_headers,y1]=get_X_y_for_fconn_regression(path_imaging,...
    path_dictionary_demographics_Table,...
    path_demographics_Table,...
    path_group_Design_Table,...
    parcel,...
    options);

%% Set data for prediction

if two_samples_flag==1
path_imaging=path_imaging_prediction;
path_dictionary_demographics_Table=path_dictionary_demographics_Table_prediction;
path_demographics_Table=path_demographics_Table_prediction;
path_group_Design_Table=path_group_Design_Table_prediction;
[X2,within_headers,y2]=get_X_y_for_fconn_regression(path_imaging,...
    path_dictionary_demographics_Table,...
    path_demographics_Table,...
    path_group_Design_Table,...
    parcel,...
    options);
end
%% run test

if two_samples_flag
    explore_parameters_fconn_regression(X1,within_headers,y1,options,X2,y2);
else
    explore_parameters_fconn_regression(X1,within_headers,y1,options);
end
cd(from_wd)

