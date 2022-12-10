function [fconn_top, parcel,fconn_pred] = run_rank_brain_features(path_imaging,path_Rsquared,varargin)

%% Oscar Miranda-Dominguez
% First line of code: Nov 13, 2020

%% Define defaults

fs = filesep;

% Define outpur folder
output_folder=[pwd fs 'ranked_brain_features'];

% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
options.top_features=[20:20:100 150 200];
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];

% Define parcel filename
parcel_filename='parcel_top_features';


% define path_imaging_pred
path_imaging_pred=[];
fconn_pred=[];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;
            
        case 'parcel_filename'
            parcel_filename=varargin{q+1};
            q = q+1;
            
        case 'path_imaging_pred'
            path_imaging_pred=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;

%% Move to output_folder

local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end

%% Load imaging data
% path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\path_hcp.txt';
fconn = load_imaging_data(path_imaging);

%% Symmetrize, if fconn
% Correlation matrices are already symmetrized. THis step is implemented
% for connectotyping. When applied to correlation matrices, there is no
% effect, just a few miliseconds wasted
sz=size(fconn);
if numel(sz)==3
    if options.symmetrize==1
        fconn=symmetryze_M(fconn);
    end
end

%% Tabify imaging data

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(fconn,options);


%% Load R qsquared
R=readtable(path_Rsquared);

%% rank brain features

[fconn_top, parcel, ix] = rank_brain_features(Y,R,options);
fconn_top=table2array(fconn_top);


%% Save results


save([output_folder fs 'fconn_top.mat'],'fconn_top');
save([output_folder fs parcel_filename '.mat'],'parcel');

%%
if ~isempty(path_imaging_pred)
    fconn_pred = load_imaging_data(path_imaging_pred);
    
    if numel(sz)==3
        if options.symmetrize==1
            fconn_pred=symmetryze_M(fconn_pred);
        end
    end
    [Y_pred, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(fconn_pred,options);
    fconn_pred=Y_pred(:,ix);
    fconn_pred=table2array(fconn_pred);
    save([output_folder fs 'fconn_pred.mat'],'fconn_pred');
end