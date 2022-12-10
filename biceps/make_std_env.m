function make_std_env(handles)

%% Internal variables
fs=filesep;
env_folder=[handles.env.path_gagui fs ...,
    handles.env.name{1} fs,...
    handles.func_data_name fs,...
    handles.env.group];
if ~isfolder(env_folder)
    mkdir(env_folder);
end
change_permissions(handles,env_folder)
n_parcel=length(handles.mc.surv_parcels);

% Identify participants surviving motion censoring
surv=handles.mc.surv_ix;
% surv(:,1)=[]; %first column refers to standard, second one to model based
surv(:,2)=[]; %first column refers to standard, second one to model based
n_surv=sum(surv);
ix=find(surv);

n_frames = floor(handles.mc.min_frames);% identify the min frames set in th
n_surv_frames=handles.mc.n_surv_frames;
n_surv_frames=n_surv_frames(ix,:);
n_frames2= min(n_surv_frames);% identify the min number of frames after censoring (this number must be equal or larger that the previous one)
n_frames2(2:end)=[];
%% read mask
mask=cell(n_surv,3);
for i=1:n_surv
    mask{i,1}=handles.mc.surv_std{ix(i)};
    % get indices of remaining frames and randomly select n numder of
    % remaining frames where n is the minimum number of frames after
    % censoring
    mask{i,2}=zeros(length(handles.mc.surv_std{ix(i)}),1);
    if sum(handles.mc.surv_std{ix(i)}) >= n_frames2
        inc_frames_idx=find(handles.mc.surv_std{ix(i)}==1);
        sample_inc_frames_idx=datasample(inc_frames_idx, n_frames2,'Replace',false);
        mask{i,2}(sample_inc_frames_idx)=1;
    end
    mask{i,3}=zeros(length(handles.mc.surv_std{ix(i)}),1);
    if sum(handles.mc.surv_std{ix(i)}) >= n_frames
        inc_frames_idx=find(handles.mc.surv_std{ix(i)}==1);
        sample_inc_frames_idx=datasample(inc_frames_idx, n_frames,'Replace',false);
        mask{i,3}(sample_inc_frames_idx)=1;
    end
end
mask_file=[env_folder fs handles.env.std_mask_name];
save_planB(mask_file,mask);%n_frames

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
            raw_tc=cell(n_surv,1);
        end
        %         masked_tc=cell(n_surv,1);
        handles.mc.min_frames;
        % read the first participant to preallocate memory for fconn
        j=1;
        disp(['Processing participant ' num2str(j) ' out of ' num2str(n_surv) ' in parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) '), standard']);
        path_to_nii=[strtrim(handles.participants.full_path(ix(j),:)) fs 'func'];
        
        %path_to_csv=[strtrim(handles.participants.full_path(ix(j),:)) fs handles.paths.append_path_csv_parcellations];
        %         filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '_task-rest_bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
        %filename=[handles.mc.surv_parcels{n_parcel} '.csv'];
        %     temp_raw=ciftiopen([path_to_nii fs filename], '/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command');% read raw timecourses
        %     temp_raw=ciftiopen([path_to_nii fs filename], handles.paths.wb_command);% read raw timecourses
        
        try
            filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
            local_filename=strtrim(ls([path_to_nii fs filename]));
        catch
            filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold*-' handles.mc.surv_parcels{i} '.nii'],'');
            local_filename=strtrim(ls([path_to_nii fs filename]));
        end
        
        TEMP_RAW = read_cifti_via_csv (local_filename,quotes_if_space(handles.paths.wb_command));
        % OUTLIER DETECTION - Anders Perrone 20180516
        %stdev=std(temp_raw,0,2);
        %FDvec_keep_idx=find(mask{j}==1);
        %Outlier_file=isthisanoutlier(stdev(FDvec_keep_idx),'median');
        %Outlier_idx=find(Outlier_file==1); % find outlier indices
        %mask{j}(FDvec_keep_idx(Outlier_idx))=0; % set outliers to zero within FDvec
        %handles.mc.n_surv_frames(ix(j),1)=handles.mc.n_surv_frames(ix(j),1)-length(Outlier_idx)
        %n_frames2=min(handles.mc.n_surv_frames(ix(j),1))
        
        
        %     temp_raw_masked=temp_raw.cdata(:,mask{j,1});% mask raw timecourses
        %     raw_tc{j}=temp_raw.cdata;
        %     masked_tc{j}=temp_raw_masked;
        
        
        temp_raw_masked=TEMP_RAW(:,mask{j,1});% mask raw timecourses
        if handles.save_raw_timecourses_flag
            raw_tc{j}=TEMP_RAW;
        end
        %         masked_tc{j}=temp_raw_masked;
        
        %     n_rois=size(temp_raw.cdata,1);
        n_rois=size(TEMP_RAW,1);
        fconn_temp=zeros(n_rois,n_rois,n_surv,3);
        %if i==6
        %    1;
        %end
        %ix1=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames);
        %ix1=find(mask{j,3}==1);
        %     fconn_temp(:,:,j,1)=corr(temp_raw.cdata(:,mask{j,3}==1).');
        fconn_temp(:,:,j,1)=corr(TEMP_RAW(:,mask{j,3}==1).');
        
        %ix2=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames2);
        %ix2=find(mask{j,2}==1);
        %     fconn_temp(:,:,j,2)=corr(temp_raw.cdata(:,mask{j,2}==1).');
        fconn_temp(:,:,j,2)=corr(TEMP_RAW(:,mask{j,2}==1)');
        
        %     fconn_temp(:,:,j,3)=corr(temp_raw.cdata(:,mask{j,1}==1).');
        fconn_temp(:,:,j,3)=corr(TEMP_RAW(:,mask{j,1}==1)');
        
        for j=2:n_surv
            disp(['Processing participant ' num2str(j) ' out of ' num2str(n_surv) ' in parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) '), standard']);
            path_to_nii=[strtrim(handles.participants.full_path(ix(j),:)) fs 'func'];
            %             filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '_task-rest_bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
            filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
            try
                filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold_atlas-' handles.mc.surv_parcels{i} '.nii'],'');
                local_filename=strtrim(ls([path_to_nii fs filename]));
            catch
                filename=strjoin([handles.participants.ids(ix(j),:) '_' handles.participants.visit_folder(ix(j),:) '*-rest*bold*-' handles.mc.surv_parcels{i} '.nii'],'');
                local_filename=strtrim(ls([path_to_nii fs filename]));
            end
            %filename=[handles.mc.surv_parcels{n_parcel} '.csv'];
            %         temp_raw=ciftiopen([path_to_nii fs filename], '/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command');
            %         temp_raw=ciftiopen([path_to_nii fs filename], handles.paths.wb_command);
            
            TEMP_RAW=read_cifti_via_csv (local_filename,quotes_if_space(handles.paths.wb_command));
            
            % OUTLIER DETECTION - Anders Perrone 20180516
            %stdev=std(temp_raw,0,2);
            %FDvec_keep_idx=find(mask{j}==1);
            %Outlier_file=isthisanoutlier(stdev(FDvec_keep_idx),'median');
            %Outlier_idx=find(Outlier_file==1); % find outlier indices
            %mask{j}(FDvec_keep_idx(Outlier_idx))=0; % set outliers to zero within FDvec
            %handles.mc.n_surv_frames(ix(j),1)=handles.mc.n_surv_frames(ix(j),1)-length(Outlier_idx)
            %n_frames2=min(handles.mc.n_surv_frames(ix(j),1))
            
            
            %         temp_raw_masked=temp_raw.cdata(:,mask{j,1});
            %         raw_tc{j}=temp_raw.cdata;
            %         masked_tc{j}=temp_raw_masked;
            
            temp_raw_masked=TEMP_RAW(:,mask{j,1});
            if handles.save_raw_timecourses_flag
                raw_tc{j}=TEMP_RAW;
            end
            %             masked_tc{j}=temp_raw_masked;
            
            %ix1=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames);
            %ix1=find(mask{j,3}==1);
            %         fconn_temp(:,:,j,1)=corr(temp_raw.cdata(:,mask{j,3}==1).');
            fconn_temp(:,:,j,1)=corr(TEMP_RAW(:,mask{j,3}==1).');
            
            %ix2=randperm(handles.mc.n_surv_frames(ix(j),1),n_frames2);
            %ix2=find(mask{j,2}==1);
            %         fconn_temp(:,:,j,2)=corr(temp_raw.cdata(:,mask{j,2}==1).');
            fconn_temp(:,:,j,2)=corr(TEMP_RAW(:,mask{j,2}==1).');
            
            %         fconn_temp(:,:,j,3)=corr(temp_raw.cdata(:,mask{j,1}==1).');
            fconn_temp(:,:,j,3)=corr(TEMP_RAW(:,mask{j,1}==1).');
        end
        
        disp(['Saving data from parcel ' handles.mc.surv_parcels{i} ' (' num2str(i) ' out of ' num2str(n_parcel) ')']);
        
        if handles.save_raw_timecourses_flag
            save_planB([parcel_folder fs handles.env.raw_tc],raw_tc);
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

