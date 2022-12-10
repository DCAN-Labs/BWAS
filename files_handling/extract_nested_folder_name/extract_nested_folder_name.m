function nested_folder_name=extract_nested_folder_name(fullpath,depth)


delimiter=filesep;

if strcmp(fullpath(1),delimiter)
    fullpath(1)=[];
end
    
nested_folder_name=split(fullpath,delimiter);

if exist('depth','var')
    nested_folder_name=nested_folder_name(depth);
end
    