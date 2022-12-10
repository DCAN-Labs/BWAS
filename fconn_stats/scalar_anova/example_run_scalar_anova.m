if ispc
    addpath(genpath('P:\code\internal\utilities\OSCAR_WIP\fconn_stats\fconn_anova'));

else
    addpath(genpath('/group_shares/PSYCH/code/development/utilities/fconn_anova'));
    addpath(genpath('/group_shares/PSYCH/code/development/utilities/scalar_anova'));
    p{1}='/group_shares/PSYCH/code/external/utilities/gifti-1.4';
    p{2}='/group_shares/PSYCH/code/external/utilities/Matlab_CIFTI';
    for i=1:length(p)
        addpath(genpath(p{i}));
    end
end

%% populate the data
gy=64984;
gy=3;
np=120;
n_times=4;
ct=randn(gy,np);% data in format grayordinate x subject
offset=0;
for i=1:6
    
    foo=ct(:,(1:20)+offset)+10*i;
    foo=foo.*repmat(1/n_times:1/n_times:1,gy,5);
    
    ct(:,(1:20)+offset)=foo;
    offset=offset+20;
end

% ct(:,1:end/2)=ct(:,1:end/2)+100;
% ct(:,end/2+1:end)=ct(:,end/2+1:end)-100;
% ct(:,1:40)=ct(:,1:40)*.05;
% ct(:,81:120)=ct(:,81:120)*2;
scalar_brainarea_subject=ct;
%%
% Let's supose you have data from 3 groups
%% Define the order of the indices
clear between_design
between_design(1).name='Exposure';
between_design(1).subgroups(1).name='Ct';
between_design(1).subgroups(2).name='Lo';
between_design(1).subgroups(3).name='Hi';
between_design(1).subgroups(1).ix=1:40;
between_design(1).subgroups(2).ix=41:80;
between_design(1).subgroups(3).ix=81:120;
between_design(2).name='Sex';
between_design(2).subgroups(1).name='Male';
between_design(2).subgroups(2).name='Female';
between_design(2).subgroups(1).ix=[1:20 41:60 81:100];
between_design(2).subgroups(2).ix=[21:40 61:80 101:120];
%%
within_design=[];
options=[];
y=ct(1,:);
tic
main_results = scalar_anovan(scalar_brainarea_subject,between_design,within_design,options)

toc
%% make ciftis
path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command'; %path to wb_command
cifti_scalar_template='/group_shares/PSYCH/code/development/utilities/scalar_anova/sulc.32k_fs_LR.dscalar.nii';
hosting_directory='/group_shares/FAIR_LAB/scratch/Oscar/setup_scalar_anova/test_ciftis_CT2';

ciftify_scalar_anovan(main_results,path_wb_c,cifti_scalar_template,hosting_directory)
%% Longitudinal

within_design(1).name='Time';
within_design(1).subgroups(1).name='m2';
within_design(1).subgroups(2).name='m4';
within_design(1).subgroups(3).name='m6';
within_design(1).subgroups(4).name='m8';
within_design(1).subgroups(1).ix=1:n_times:np;
within_design(1).subgroups(2).ix=2:n_times:np;
within_design(1).subgroups(3).ix=3:n_times:np;
within_design(1).subgroups(4).ix=4:n_times:np;

main_results_long = scalar_anovan(scalar_brainarea_subject,between_design,within_design,options);


%% make ciftis
path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command'; %path to wb_command
cifti_scalar_template='/group_shares/PSYCH/code/development/utilities/scalar_anova/sulc.32k_fs_LR.dscalar.nii';
hosting_directory='/group_shares/FAIR_LAB/scratch/Oscar/setup_scalar_anova/test_ciftis_CT_long';

ciftify_scalar_anovan(main_results_long,path_wb_c,cifti_scalar_template,hosting_directory)
