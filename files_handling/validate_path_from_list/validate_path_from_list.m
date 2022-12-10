function path=validate_path_from_list(path_list,filename_to_open)


%% Oscar Miranda-Domínguez
% Feb 13, 2020


% Count the provided paths
n=numel(path_list);

%pre-allocate memory for the index
ix=nan;

% look for the file inthis system
for i=1:n
    if isfile(path_list{i})
        ix=i;
        break
    end
end

% if not ptovided, ask the user
if isnan(ix)
    [file, path] = uigetfile(...
        '*.*',...
        ['Please provide path to ' filename_to_open]);
    path=[path filesep file];
else
    path=path_list{ix};
end

path=quotes_if_space(path);