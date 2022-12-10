function M = load_imaging_data(path_imaging)


whos_path_imaging=whos('path_imaging');

switch whos_path_imaging.class
    case 'char'
        [filepath,name,ext] = fileparts(path_imaging);
    case 'double'
        ext='';

    otherwise
        
end

%% Get file extension


switch ext
    case '.mat'
        M = load_dot_mat_imaging(path_imaging);
        
    case '.csv'
        M = load_dot_csv_imaging(path_imaging);
        
    case '.txt'
        M = load_dot_txt_imaging(path_imaging);
        
        
    case '.nii'
        M = cifti2mat(path_imaging);
        
    case ''
        M=path_imaging;
        
    otherwise
        disp([ext 'is an invalid extension for path_imaging'])
end

