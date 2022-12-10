function list=get_path_to_folders(root_path,depth)


fs=filesep;

% check rooth path does not end with filesep
if strcmp(root_path(end),fs)
    root_path(end)=[];
end

% include nested folders
target_path=root_path;
for i=1:depth    
    target_path=[target_path fs '*'];
end

% do the search
full_list=dir(target_path);

% preallocate memory to unfolde the list
n=size(full_list,1);

% unfold the list
list=cell(n,1);
for i=1:n
    list{i}=[full_list(i).folder fs full_list(i).name];
end

% if output is folder, remove extra files
n=size(list,1);
ends_with_dot=zeros(n,1);
for i=1:n
    ends_with_dot(i)=strcmp(['.'],list{i}(end));
end
ends_with_dot=ends_with_dot==1;
list(ends_with_dot)=[];