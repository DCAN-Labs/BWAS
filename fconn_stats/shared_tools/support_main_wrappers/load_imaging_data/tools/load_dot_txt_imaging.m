function M = load_dot_txt_imaging(path_imaging_dot_txt)

% path_imaging_dot_txt='C:\Users\oscar\Box\CV\ABCD\ABCD_partial_list.txt';
list=importdata(path_imaging_dot_txt);


%% Determine if list has header or not by looking at the first element

[filepath,name,ext] = fileparts(list{1});
if isempty(ext)
    list(1)=[];
end
%% Count participants
n=size(list,1);

%pre-allocate memory
tempM=cell(n,1);

%% Load the data

i=1;
local_path=list{i};
temp{1}=cifti2mat(local_path);
tempM=repmat(temp,n,1);


for i=2:n
    local_path=list{i};
    tempM{i}=cifti2mat(local_path);
end
%% rename the data
%% handle 2d or 3d
if isvector(tempM{end})
    M=cell2mat(tempM')';
else
    [r,c]=size(tempM{end});
    M=nan(r,c,n);
    for i=1:n
        M(:,:,i)=tempM{i};
    end
end
%% Concatenate the data into M