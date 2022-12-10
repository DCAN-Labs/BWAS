%% Filter parameters
bp_order=2;
TR=2.5; %TR, in seconds
BW_Hz=[0.009 0.080];

%% add paths

addpath(genpath('/group_shares/PSYCH/code/external/utilities/gifti-1.4'));
addpath(genpath('/group_shares/PSYCH/code/external/utilities/Matlab_CIFTI'));
addpath(genpath('/group_shares/PSYCH/code/development/utilities/HCP_Matlab'));

%% Define paths for cifti and 

% path to data
path_cii='/group_shares/FAIR_LAB/scratch/Oscar/HCM_pipeline/REST1/REST1_Atlas.dtseries.nii';%path to cifti
% path to wb_command
path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command';%path to wb_command

%% Read cifti

cd /group_shares/FAIR_LAB/scratch/Oscar/HCM_pipeline/REST1/
cii=ciftiopen(path_cii,path_wb_c);
newcii=cii;
X=newcii.cdata;
%% Perform analysis



%% set env

cd /group_shares/FAIR_LAB/scratch/Oscar/HCM_pipeline/test_regression/test_fslmeants
file_wm='REST1_wm_mean.txt';
file_vent='REST1_vent_mean.txt';
file_mov_reg='Movement_Regressors.txt';
%% read wm

wm = import_masked_tc(file_wm);
%% read vent

vent = import_masked_tc(file_vent);
%% read mov_reg and calculate Friston regressors

MR = importMovReg(file_mov_reg);
FR=make_friston_regressors(MR);
%% Concatenate reg and detrened
WB=mean(X)';
R=conc_and_detrend(wm, vent, WB, FR);

%%
for i=1:size(R,2)
        plot(R(:,i))
    title(i)
    pause
end

%% Calculate residuals (regression)
[r, c]=size(X');
Rr=zeros(r,c);
Rr2=zeros(r,c);
%%
Xd=detrend(X');
w='stats:regress:RankDefDesignMat';
warning('off',w)
tic
for i=1:c
%     [~,~,Rr(i,:)] = regress(X(i,:)',R);
    [~,~,Rr2(:,i)] = regress(Xd(:,i),R);
end
toc
%%
i=randperm(r,1);
% plot(X(i,:))
plot(Xd(:,i))
hold all

plot(Rr2(:,i))
hold off
title(i)

%% band pass filter
F=1/TR;
Ny=F/2;
BW_N=BW_Hz/Ny;
[b, a]=butter(ceil(bp_order/2),BW_N);
Y=filter(b,a,Rr2);


%% remake cifti
newcii.cdata=Y';
ciftisave(newcii,'/group_shares/FAIR_LAB/scratch/Oscar/HCM_pipeline/REST1/test.dtseries.nii',path_wb_c);

%% Debuging that the data is filtered
% create a single voxel from the REST1 after FNL pipeline
%omiranda@beast:/group_shares/FAIR_LAB/scratch/Oscar/HCM_pipeline$ fslmeants -i /group_shares/FAIR_LAB2/CYA/processed/ADHD-HumanYouth-OHSU/11632-1/20140827-SIEMENS_TrioTim-Nagel_K_Study/FAIRPRE10_TR2pt5_RAD50pt0_SKIPSEC5pt0/GENT41/6mT4XR_gen1/mapflow/_6mT4XR_gen10/unpacked_faln_dbnd_xr3d.4dfp.img -o single_voxel -c 19 35 27

% create a single vocel from the dicom2nifti
