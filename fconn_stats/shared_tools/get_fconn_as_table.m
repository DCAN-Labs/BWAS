function [X, imaging_type,ind] = get_fconn_as_table(fconn,demographics_Table,options)

%% Get imagint type
[imaging_type, sz] = get_imaging_type(fconn);

%% Symmetrize, if fconn
% Correlation matrices are already symmetrized. THis step is implemented
% for connectotyping. When applied to correlation matrices, there is no
% effect, just a few miliseconds wasted
if strcmp(imaging_type,'3D')
    if options.symmetrize==1
        fconn=symmetryze_M(fconn);
    end
end

%% Tabify imaging data

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(fconn,options);

%% Select included imaging
brain_features=table2array(Y);
try
    IX=find_ix_in_header(demographics_Table,'consecutive_number');
    ix_to_include=demographics_Table{:,IX};
catch
    ix_to_include=[1:size(brain_features,1)]';
end
brain_features=brain_features(ix_to_include,:);

%% Reshape residuals as fconn was provided

M = table2fconn(brain_features,options, imaging_type, ind, sz);

%% Re-Tabify imaging data
[X, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(M,options);

%% 
X=table2array(X);