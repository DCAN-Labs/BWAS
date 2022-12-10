function settings=settings_corr_pt_dt()

%% Define the paths for support functions
str = computer;
switch str
    case 'GLNXA64'
        path{1}='/group_shares/fnl/bulk/code/external/utilities/gifti-1.6/';
        path{2}='/group_shares/fnl/bulk/code/external/utilities/Matlab_CIFTI/';
        path_wb_c='/usr/bin/wb_command'; %path to wb_command
        
    case 'PCWIN64'
        path{1}='P:\code\external\utilities\gifti-1.6';
        path{2}='P:\code\external\utilities\Matlab_CIFTI';   
        path_wb_c='C:\Program Files\workbench-windows64-v1.1.1\workbench\bin_windows64\wb_command'; %path to wb_command
end

settings.path=path;
settings.path_wb_c=path_wb_c;
