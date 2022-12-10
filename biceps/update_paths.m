function handles=update_paths(handles)
% handles.exp_path=[handles.root_path filesep 'exploratory' filesep];
handles.root_path=handles.exp_path(1:end-11);
handles.no_auto_path=[handles.root_path  'no_autocorrelation' filesep];
handles.model_based_path=[handles.root_path  'model_based' filesep];
handles.model_based_tsvd_path=[handles.root_path  'model_based_tsvd' filesep];

frames=handles.custom_frames;
rep=handles.custom_reps;

handles.model_based_custom_path=[handles.root_path 'model_based_' num2str(frames) '_frames_' num2str(rep) '_rep' filesep];
handles.model_based_tsvd_custom_path=[handles.root_path 'model_based_tsvd_' num2str(frames) '_frames_' num2str(rep) '_rep' filesep];
try
    cd(handles.root_path);
end
