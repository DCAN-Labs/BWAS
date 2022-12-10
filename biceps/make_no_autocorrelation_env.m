function make_no_autocorrelation_env(handles)

%% Internal variables
fs=filesep;
env_folder=[handles.env.path_gagui fs ...,
    handles.env.name{2} fs,...
    handles.func_data_name fs,...
    handles.env.group];
if ~isfolder(env_folder)
    mkdir(env_folder);
end
change_permissions(handles,env_folder)
n_parcel=length(handles.mc.surv_parcels);
n_ar=handles.connectotyping_settings.n_ar;

% Identify participants surviving motion censoring
surv=handles.mc.surv_ix;
surv(:,1)=[]; %first column refers to standard, second one to model based
n_surv=sum(surv);
ix=find(surv);

n_frames = handles.mc.min_frames;% identify the min frames set in th
n_surv_frames=handles.mc.n_surv_frames;
n_surv_frames=n_surv_frames(ix,:);
% n_frames2= min(n_surv_frames);% identify the min number of frames after censoring (this number must be equal or larger that the previous one)

n_frames2= min(n_surv_frames(:,2));% identify the min number of frames after censoring (this number must be equal or larger that the previous one)

% n_frames2(1)=[];
%% read mask

mask_file=[env_folder fs handles.env.std_mask_name];
mask=cell(n_surv,1);
for i=1:n_surv
    mask{i}=handles.mc.surv_mb{ix(i)};
end
save_planB(mask_file,mask);

%% Read parcellated data
for i=1:n_parcel
    
    % Identify parcel and preallocate memory
    
    j=strcmp(cat(1,{handles.cbh.String}'),strtrim(char(handles.mc.surv_parcels{i})));
    if handles.cbh(find(j)).Value
        parcel_folder=[env_folder fs strtrim(char(handles.mc.surv_parcels{i}))];
        if ~isfolder(parcel_folder)
            mkdir(parcel_folder)
        end
        change_permissions(handles,parcel_folder)
        if handles.save_raw_timecourses_flag
            raw_tc_no_auto=cell(n_surv,1);
        end
        %         masked_tc=cell(n_surv,1);
        
        % read the first participant to preallocate memory for fconn
        j=1;
        disp(['Processing participant ' num2str(j) ' out of ' num2str(n_surv) ' in parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) '), no autocorrelation']);
        path_to_nii=[strtrim(handles.participants.full_path(ix(j),:)) fs 'func'];
        filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '_task-rest_bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
        
        %path_to_csv=[strtrim(handles.participants.full_path(ix(j),:)) fs handles.paths.append_path_csv_parcellations];
        %filename=[handles.mc.surv_parcels{i} '.csv'];
        %     temp_raw_cifti=ciftiopen([path_to_nii fs filename], '/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command');% read raw timecourses
        %     temp_raw_cifti=ciftiopen([path_to_nii fs filename], handles.paths.wb_command);% read raw timecourses
        %     temp_raw=temp_raw_cifti.cdata.';
        %     temp_raw_no_auto=temp_raw;
        
        try
            filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
            local_filename=strtrim(ls([path_to_nii fs filename]));
        catch
            filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold*-' handles.mc.surv_parcels{i} '.nii'],'');
            local_filename=strtrim(ls([path_to_nii fs filename]));
        end
        TEMP_RAW = read_cifti_via_csv (local_filename,quotes_if_space(handles.paths.wb_command));
        TEMP_RAW=TEMP_RAW';
        temp_raw_no_auto=TEMP_RAW;
        
        % Prep to remove autocorrelations
        frames_per_resting=handles.mc.frames{ix(j)};
        n_resting=length(frames_per_resting);
        
        foo=cumsum(frames_per_resting)+1;
        foo(end)=1;
        init=circshift(foo,1);
        till=init+n_ar-1;
        offset_dummy=0;
        for k=1:n_resting
            ix_resting=(1:frames_per_resting(k))+offset_dummy;
            temp_raw_no_auto(init(k):till(k),:)=0;
            %         temp_raw_no_auto(till(k)+1:ix_resting(end),:)=remove_autocorrelation(temp_raw(ix_resting,:),n_ar);
            temp_raw_no_auto(till(k)+1:ix_resting(end),:)=remove_autocorrelation(TEMP_RAW(ix_resting,:),n_ar);
            offset_dummy=ix_resting(end);
        end
        
        temp_raw_masked=temp_raw_no_auto(mask{j},:);% mask raw timecourses
        if handles.save_raw_timecourses_flag
            raw_tc_no_auto{j}=temp_raw_no_auto;
        end
        %         masked_tc{j}=temp_raw_masked;
        
        %     n_rois=size(temp_raw,2);
        n_rois=size(TEMP_RAW,2);
        fconn_temp=zeros(n_rois,n_rois,n_surv,3);
        
        ix1=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames);
        fconn_temp(:,:,j,1)=corr(temp_raw_masked(ix1,:));
        
        ix2=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames2);
        fconn_temp(:,:,j,2)=corr(temp_raw_masked(ix2,:));
        
        fconn_temp(:,:,j,3)=corr(temp_raw_masked);
        
        for j=2:n_surv
            disp(['Processing participant ' num2str(j) ' out of ' num2str(n_surv) ' in parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) '), no autocorrelation']);
            path_to_nii=[strtrim(handles.participants.full_path(ix(j),:)) fs 'func'];
            %             filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '_task-rest_bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
            %         temp_raw_cifti=ciftiopen([path_to_nii fs filename], '/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command');
            %         temp_raw_cifti=ciftiopen([path_to_nii fs filename], handles.paths.wb_command);
            %         temp_raw=temp_raw_cifti.cdata.';
            %         temp_raw_no_auto=temp_raw;
            try
                filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
                local_filename=strtrim(ls([path_to_nii fs filename]));
            catch
                filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold*-' handles.mc.surv_parcels{i} '.nii'],'');
                local_filename=strtrim(ls([path_to_nii fs filename]));
            end
            
            TEMP_RAW = read_cifti_via_csv (local_filename,quotes_if_space(handles.paths.wb_command));
            TEMP_RAW=TEMP_RAW';
            temp_raw_no_auto=TEMP_RAW;
            
            % Prep to remove autocorrelations
            frames_per_resting=handles.mc.frames{ix(j)};
            n_resting=length(frames_per_resting);
            
            foo=cumsum(frames_per_resting)+1;
            foo(end)=1;
            init=circshift(foo,1);
            till=init+n_ar-1;
            offset_dummy=0;
            for k=1:n_resting
                ix_resting=(1:frames_per_resting(k))+offset_dummy;
                temp_raw_no_auto(init(k):till(k),:)=0;
                %             temp_raw_no_auto(till(k)+1:ix_resting(end),:)=remove_autocorrelation(temp_raw(ix_resting,:),n_ar);
                temp_raw_no_auto(till(k)+1:ix_resting(end),:)=remove_autocorrelation(TEMP_RAW(ix_resting,:),n_ar);
                offset_dummy=ix_resting(end);
            end
            
            
            temp_raw_masked=temp_raw_no_auto(mask{j},:);% mask raw timecourses
            if handles.save_raw_timecourses_flag
                raw_tc_no_auto{j}=temp_raw_no_auto;
            end
            %             masked_tc{j}=temp_raw_masked;
            
            ix1=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames);
            fconn_temp(:,:,j,1)=corr(temp_raw_masked(ix1,:));
            
            ix2=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames2);
            fconn_temp(:,:,j,2)=corr(temp_raw_masked(ix2,:));
            
            fconn_temp(:,:,j,3)=corr(temp_raw_masked);
        end
        
        disp(['Saving data from parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) ')']);
        
        if handles.save_raw_timecourses_flag
            save_planB([parcel_folder fs handles.env.raw_tc],raw_tc_no_auto);
            %         save_planB([parcel_folder fs handles.env.masked_tc],masked_tc);
        end
        
        fconn=squeeze(fconn_temp(:,:,:,1));
        file_fconn=['fconn_' num2str(n_frames) '_frames.mat'];
        save_planB([parcel_folder fs file_fconn],fconn);
        
        fconn=squeeze(fconn_temp(:,:,:,2));
        file_fconn=['fconn_' num2str(n_frames2) '_frames.mat'];
        save_planB([parcel_folder fs file_fconn],fconn);
        
        fconn=squeeze(fconn_temp(:,:,:,3));
        file_fconn='fconn_all_surv_frames.mat';
        save_planB([parcel_folder fs file_fconn],fconn);
        
        %% patch added in Oct 10, 2016 by Oscar Miranda to add Fisher Z transform
        %         Zfconn_temp=atanh(fconn_temp);
        %
        %         fconn=squeeze(Zfconn_temp(:,:,:,1));
        %         file_fconn=['Zfconn_' num2str(n_frames) '_frames.mat'];
        %         save_planB([parcel_folder fs file_fconn],fconn);
        %
        %         fconn=squeeze(Zfconn_temp(:,:,:,2));
        %         file_fconn=['Zfconn_' num2str(n_frames2) '_frames.mat'];
        %         save_planB([parcel_folder fs file_fconn],fconn);
        %
        %         fconn=squeeze(Zfconn_temp(:,:,:,3));
        %         file_fconn='Zfconn_all_surv_frames.mat';
        %         save_planB([parcel_folder fs file_fconn],fconn);
    end
    
end

