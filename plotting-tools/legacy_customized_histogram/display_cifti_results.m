function display_cifti_results(input_vector,template_cifti,output_cifti)

%% Load Infomap results, display on WB surface as .dtseries file
    %input_vector: matlabe vector with variable name Ci_avg
    %template_cifti: template cifti with same number of nodes as
    %input_vector has rows: .pscalar.nii recommended but .pseries.nii will
    %work
    %output_cifti: name of cifti output with file type .ptseries.nii

%% Determine machine type
if ismac
    basedir = '/Volumes';
    path_wb_c= '/Applications/workbench/bin_macosx64/wb_command'; %path to wb_command as installed on OS X
else
    basedir = '/group_shares';
    path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command'; %path to wb_command as installed on AIRC server
end

%% Load paths
p{1}=[ basedir '/PSYCH/code/external/utilities/gifti-1.4' ]; %path to dependencies
p{2}=[ basedir '/PSYCH/code/external/utilities/Matlab_CIFTI' ]; %path to inhouse scripts, as well as some external dependencies
for i=1:length(p)
    addpath(genpath(p{i}));
end

%% Load Results

%Individual Communities Example
%load('/group_shares/FAIR_LAB2/Projects/ABCD_Pilot_data_experiments/6_communities.mat','Ci_avg');
load(input_vector,'matrix');

%% Load in template
    %file='/group_shares/FAIR_LAB2/Projects/ABCD_Pilot_data_experiments/64channel_2p0/ABCDPILOT_MSC02_FNL_preproc_MSC02.ptseries.nii'; %Template for pconn
    cii_template=ciftiopen(template_cifti,path_wb_c); % Here you read the file and save the content on cii
    newcii=cii_template; % resaving the data to newcii. Notice that cii and newcii are structures
    X=newcii.cdata; % Asigning the actual data to the variable X
    whos X,  
    
%% Save outputs to .pconn files
    newcii.cdata=matrix;
    %file_path='/Users/carpensa/Dropbox/MATLAB/Cifti-Matlab'
    %file_path='/Volumes/carpensa/scripts/Cifti/sandbox/DisplayInfomap';
    %file_path='/group_shares/FAIR_LAB2/Projects/ABCD_Pilot_data_experiments'
    %output_file='Individual_Subject_communities.ptseries.nii'; % defining the name of your output file
    %ciftisave(newcii,[file_path '/' output_file],path_wb_c); % Making your cifti
    ciftisave(newcii,output_cifti,path_wb_c); % Making your cifti
