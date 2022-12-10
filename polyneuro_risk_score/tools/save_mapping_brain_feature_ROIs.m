function T = save_mapping_brain_feature_ROIs(row, ...
    col,...
    network_names,...
    path_explained_variance_cifti)

%% Make the table



n=numel(row);
T = [table([1:n]') network_names table(row,col)];
T.Properties.VariableNames{1}='index';
T.Properties.VariableNames{2}='network_names';
T.Properties.VariableNames{3}='ROI1';
T.Properties.VariableNames{4}='ROI2';

% censor 1D data
if sum(isnan(col))>0
    T(:,end)=[];
end
%% get path to save table

[ filepath , name , ext ] = fileparts( path_explained_variance_cifti );

filename = 'mapping_brain_feature_index_2_ROIs.csv';
old = 'ciftis';
new = 'tables';
local_path =  strrep( filepath , old , new );
full_filename = [local_path filesep filename];

%% Save table

writetable(T,full_filename)