function corr_pt_dt(pt_series_file,dt_series_file,ix,output_file,mask)

%% corr_pt_dt(pt_series_file,dt_series_file,ix,output_file)
%% Oscar Miranda-Dominguez, OCt 13, 2016

% This function calculate the correlation between a given set of ROIs from
% a parcellated time series to all the timecourses from a dense time series
%
% The output is a dtseries file
%
% Mandatory inputs:
%   pt_series_file, 
%       example: pt_series_file='/group_shares/FAIR_HCP/HCP/processed/ADHD-HumanYouth-OHSU/10050-1/20120605-SIEMENS-Nagel_K-Study/HCP_prerelease_FNL_0_1/MNINonLinear/Results/10050-1_FNL_preproc_Gordon_subcortical.ptseries.nii';     
%
%   dt_series_file, 
%       example: dt_series_file='/group_shares/FAIR_HCP/HCP/processed/ADHD-HumanYouth-OHSU/10050-1/20120605-SIEMENS-Nagel_K-Study/HCP_prerelease_FNL_0_1/MNINonLinear/Results/10050-1_FNL_preproc_Atlas.dtseries.nii';
%
% Optional inputs:
%
%   ix, indices of the ROIS in the dt_series. This is optional. If not
%   provided, correlation will be calculated using as seed all the ROIs
%   from the ptseries. If provided, It needs to be a vector,
%       example: ix=[1 2];
%
%   output_file, Optional, If provided, it should have an existing path and filename
%   (without the extension dtseries.nii). If not provided, is going to take
%   the path from the ptseries and the filename will be
%   corr_pt_dt.dtseries.nii
%
%  mask, Optional. If provided, removes those frames from the timeseries.
%  One means keep, 0 means delete

%% Load settings
% This code lives originally here: /group_shares/PSYCH/code/development/utilities/corr_pt_dt
% remeber to add the containing folder to your path: addpath(genpath('/group_shares/PSYCH/code/development/utilities/corr_pt_dt'));
%%
addpath('/public/code/internal/utilities/OSCAR_WIP/cifti_tools/corr_pt_dt/support_files');
settings=settings_corr_pt_dt;%
%% Adding paths for this function
np=size(settings.path,2);
for i=1:np
    addpath(genpath(settings.path{i}));
end

path_wb_c=settings.path_wb_c; %path to wb_command
%% Make default name for output file, if not provided
if nargin<4
    output_file=[];
end
if isempty(output_file)
    [pathstr_dt,name_dt,ext_dt] = fileparts(dt_series_file);
    % pathstr_out=pathstr_pt;
    output_file=[pathstr_dt filesep 'corr_pt_dt'];
end


% if or(nargin<4,isempty(output_file))
% % [pathstr_pt,name_pt,ext_pt] = fileparts(pt_series_file);
% [pathstr_dt,name_dt,ext_dt] = fileparts(dt_series_file);
% % pathstr_out=pathstr_pt;
% output_file=[pathstr_dt filesep 'corr_pt_dt'];
% end
%% Read ptseries
cii=ciftiopen(pt_series_file,path_wb_c);
newcii=cii;
pt_series=double(newcii.cdata);
N_rois=size(pt_series,1);% count the total rois in this parcellation
%% Count how many ROIs you care about

%% Error check to make sure ix is a vector and less than or equal to N_rois
if isempty(ix)
    ix=1:n_rois;
else
    if min(size(ix,1),size(ix,2))>2
        error('ix needs to be a vector')
    end
    if sum(ix>N_rois)>0
        error(['Largest ROI ix must be less than or equal to ' num2str(N_rois)])
    end
end
%% Extract the pt_series you like the correlation to be calculated
pt_series_final=pt_series(ix,:);

%% Read dtseries
cii=ciftiopen(dt_series_file,path_wb_c);
newcii=cii;
dt_series=double(newcii.cdata);
%% Get prepared for motion censoring

if nargin<5
    n_frames=size(dt_series,2);
    mask=ones(n_frames,1)==1;
end

%% calculate correlations
R=corr(pt_series_final(:,mask)',dt_series(:,mask)');
newcii.cdata=R';
%% Save data as cifti
[a b c]=fileparts(dt_series_file);[a b c]=fileparts(b);
output_file=[output_file c '.nii'];
%output_file=[output_file '.dtseries.nii'];

% output_file=[output_file '.dtseries.nii'];
ciftisave(newcii,output_file,path_wb_c); % Making your cifti
display(['Done, file ' output_file '  saved']);
%% Validation
% temp=randi(3);
% ix1=ix(temp);
% ix2=randi(91282);
% R2=corr(pt_series(ix1,:)',dt_series(ix2,:)');
% [R2 R(temp,ix2)]
