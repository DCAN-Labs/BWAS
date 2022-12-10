%% Oscar's debuging zone 
% addpath(genpath('/group_shares/PSYCH/code/development/utilities/HCP_Matlab/CIFTIS'));
% addpath(genpath('/group_shares/PSYCH/code/external/utilities/Matlab_CIFTI'));
% addpath(genpath('/group_shares/PSYCH/code/external/utilities/gifti-1.4'));

%%
addpath(genpath('C:\Users\mirandad\Documents\MATLAB\OSCAR_WIP'))
addpath(genpath('P:\code\external\utilities\gifti-1.6'))
%% Test scalar

file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\testing_scalar' num2str(round(1e3*abs(randn) ))];

file_and_path='C:\Users\mirandad\Desktop\delete\ciftis\testing_scalar_delete_me_';
file_and_path='testing_scalar_delete_me_';

n_rois=352; % Define the number of ROIs
n_scenes=10; % Define the number of brain figures
%
clear scene % make sure the variable does not exist
data=randn(n_rois,n_scenes); % make fake data

data(data>.2)=nan; % Assign some NAN

scene.scalar=data; % Prepare the data for the function

ciftify_this(scene,file_and_path) % Enjoy!
%% test RGB
file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\Oscar/ciftis/Gordon_color_' num2str(round(1e3*abs(randn) ))];

file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\testing_scalar' num2str(round(1e3*abs(randn) ))];
file_and_path=['testing_scalar1'];
n_rois=333;
n_scenes=1;
clear scene
RGB=rand(n_rois,3,n_scenes);
ix_nan=randperm(333,300);
for i=1:3
    RGB(:,:,i)=repmat([1 2 3]==i,n_rois,1);
end
RGB(ix_nan,:,:)=nan;
alpha=rand(n_rois,n_scenes);
scene.RGB=RGB;
ciftify_this(scene,file_and_path)
%% Test survivors
clear scene
file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\Oscar/ciftis/Gordon_surv_per_network_' num2str(round(1e3*abs(randn) ))];
n_rois=333;
n_scenes=5;

surv=randn(n_rois,n_scenes)>1;
surv(:,end)=1;
scene.surv=surv;
ciftify_this(scene,file_and_path)

%%
path_cifti_templates='/group_shares/PSYCH/code/development/utilities/HCP_Matlab/CIFTIS/cifti_files';
path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command'; %path to wb_command

a=dir(path_cifti_templates);

n=length(a)
for i=3:n
    filename=a(i).name;
    foo=strsplit(filename,{'10055-1_FNL_preproc_','.ptseries.nii'});
    parcellation=char(foo{2});
    display([num2str(i) ' ' parcellation ])
    
    
    cii=ciftiopen([path_cifti_templates filesep filename],path_wb_c);
    newcii=cii;
    X=newcii.cdata;
    [n_rois, TRs]=size(X);
    
    newcii.cdata=X(:,1);
    ciftisave(newcii,[path_cifti_templates filesep parcellation '.ptseries.nii'],path_wb_c); % Making your cifti
    display([num2str(i) ' ' parcellation ', ' num2str(n_rois) ' ROIs'])
end

%%
%% test RGB
file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\Oscar/ciftis/Gordon_color_' num2str(round(1e3*abs(randn) ))];

file_and_path=['C:\Users\mirandad\Desktop\delete\ciftis\testing_scalar' num2str(round(1e3*abs(randn) ))];
file_and_path=['testing_scalar2'];
n_rois=333;
n_scenes=1;
clear scene
RGB=rand(n_rois,3,n_scenes);
ix_nan=randperm(333,300);
for i=1:n_scenes
    RGB(:,:,i)=repmat([1 2 3]==i,n_rois,1);
end
RGB(ix_nan,:,:)=nan;
alpha=rand(n_rois,n_scenes);
scene.RGB=RGB;
ciftify_this(scene,file_and_path)
%% Make Gordon parcellation
clear
load HumanGordon.mat
n=size(parcel,2);
n_rois=333;
n_scenes=1;
rgb=nan(n_rois,3,n_scenes);
parcel(13)=[];
for i=1:n
    ix=parcel(i).ix;
    local_n=parcel(i).n;
    local_RGB=parcel(i).RGB;
    RGB=nan(n_rois,3,n_scenes);
    RGB(ix,:)=repmat(local_RGB,local_n,1);
    local_filename=['gordon_' parcel(i).shortname];
    scene.RGB=RGB;
    ciftify_this(scene,local_filename)
end

%% Make bezfiin parcellation
clear
load('parcel.mat')
n=size(parcel,2);
parcel(1).RGB=[1 1 0];
parcel(4).RGB=[1 0 1];
n_rois=82;
n_scenes=1;
rgb=nan(n_rois,3,n_scenes);
for i=1:n
    ix=parcel(i).ix;
    local_n=parcel(i).n;
    local_RGB=parcel(i).RGB;
    RGB=nan(n_rois,3,n_scenes);
    RGB(ix,:)=repmat(local_RGB,local_n,1);
    local_filename=['bezgiin_' parcel(i).shortname];
    scene.RGB=RGB;
    ciftify_this(scene,local_filename)
end

%% Make combined bezfiin parcellation
clear
load('parcel.mat')
n=size(parcel,2);
parcel(1).RGB=[1 1 0];
parcel(4).RGB=[1 0 1];
parcel(4).ix=unique(sort([parcel(4).ix;parcel(7).ix]));
parcel(4).n=numel(parcel(4).ix);
parcel(7)=[];

n_rois=82;
n_scenes=1;
rgb=nan(n_rois,3,n_scenes);
n=size(parcel,2);
for i=1:n
    ix=parcel(i).ix;
    local_n=parcel(i).n;
    local_RGB=parcel(i).RGB;
    RGB=nan(n_rois,3,n_scenes);
    RGB(ix,:)=repmat(local_RGB,local_n,1);
    local_filename=['bezgiin_7_' parcel(i).shortname];
    scene.RGB=RGB;
    ciftify_this(scene,local_filename)
end