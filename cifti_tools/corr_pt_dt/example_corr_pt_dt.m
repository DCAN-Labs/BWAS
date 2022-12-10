
%% Add the folders containing the function to your path
addpath(genpath('/group_shares/PSYCH/code/development/utilities/corr_pt_dt'));
%%
rp='/group_shares/FAIR_HCP/HCP/processed/ADHD-HumanYouth-OHSU/10050-1/20120605-SIEMENS-Nagel_K-Study/HCP_prerelease_FNL_0_1/MNINonLinear/Results';
f=filesep;


dt_series_file=[rp f '10050-1_FNL_preproc_Atlas.dtseries.nii'];
pt_series_file=[rp f '10050-1_FNL_preproc_Gordon_subcortical.ptseries.nii'];

ix=[1 2 350]';% indices of the ROIS in the dt_series to be used for correlation
corr_pt_dt(pt_series_file,dt_series_file,ix)
%%
% output_file='/remote_home/omiranda/Desktop/test';
% corr_pt_dt(pt_series_file,dt_series_file,ix,[])
% corr_pt_dt(pt_series_file,dt_series_file,ix)
% corr_pt_dt(pt_series_file,dt_series_file,ix,output_file)
% 
% %%
% ix=1:10
% %%
% 
% p=pt_series(1:10,:);
% d=dt_series(1:3,:);
% 
% R=corr(d',p');
% whos R
% corr_pt_dt(pt_series_file,dt_series_file,ix)
