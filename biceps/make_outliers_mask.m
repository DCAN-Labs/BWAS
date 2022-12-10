function handles = make_outliers_mask( handles )
%DETECT_OUTLIERS reads in the variance of the grayordinates from each frame
%created by `wb_command -cifti-stats ...dtseries.nii -reduce VARIANCE > ${subject_id}_${base_fMRI_name}_${FNL_preproc_version}_Atlas_Variance.txt`
%and then calculates which of the frames below the FD threshold are
%considered outliers and should not be included.
%   Should return a mask of outliers

fs=filesep;
n=handles.participants.N;
full_path=handles.participants.full_path;
%% Find grayordinate variance file for each subject
for i=1:n
    % initialize vector of ones; outliers will be zero
    handles.mc.outlier_mask_std{i}=ones(sum(handles.mc.frames{i}),1);
    handles.mc.outlier_mask_mb{i}=ones(sum(handles.mc.frames{i}),1);
    dtseries_var_path = strjoin([strtrim(full_path(i,:)) fs 'func' fs handles.participants.ids(i,:) '_' handles.participants.visit_folder(i,:) '_task-rest_bold_timeseries_variance.txt'],'');
    
    %% Add logic here to calculate the variance file in case of missing | aug 6, 2019
    %%
%     dtseries_var = dlmread(dtseries_var_path);

    dtseries_var=get_variance_file(dtseries_var_path,handles);
    % Get indices of frames that will be included so only included data is
    % used in computing outliers
    inc_idx_std=find(handles.mc.surv_std{i});
    inc_idx_mb=find(handles.mc.surv_mb{i});
    idx_mask_std = isthisanoutlier(dtseries_var(inc_idx_std),'median');
    idx_mask_mb = isthisanoutlier(dtseries_var(inc_idx_mb),'median');
    % Get the indices of frames that are outliers
    outlier_idx_std=inc_idx_std(idx_mask_std);
    outlier_idx_mb=inc_idx_mb(idx_mask_mb);
    handles.mc.outlier_mask_std{i}(outlier_idx_std) = 0; 
    handles.mc.outlier_mask_mb{i}(outlier_idx_mb) = 0;
end

end

