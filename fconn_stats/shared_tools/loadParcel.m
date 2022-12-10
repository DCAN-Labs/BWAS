function parcel=loadParcel(path_parcellation_table)

%% Get file extension
[filepath,name,ext] = fileparts(path_parcellation_table);

switch ext
    case '.mat'
        parcel=load_dot_mat_imaging(path_parcellation_table);
        
    case '.csv'
        parcel = import_parcel_from_csv(path_parcellation_table);       
 
        
    otherwise
        disp([ext 'is an invalid extension for path_parcellation_table'])
end
summarize_parcel(parcel)