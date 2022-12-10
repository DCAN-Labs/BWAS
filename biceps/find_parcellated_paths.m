function handles = find_parcellated_paths(handles)
fs=filesep;
ix_surv=find(or(handles.mc.surv_ix(:,1),handles.mc.surv_ix(:,2)));
n=size(ix_surv,1);
parcel_names=cell(n,1);
mismatch_frames=zeros(n,1);
parcels_that_mismatch=cell(n,1);
parcels_per_study=zeros(n,1);
%% Promt user to ignore validation of frame count per parcel
prompt={'Do you want to skip frame validation count per subject and parcel to save time?'};
answer = questdlg(prompt, ...
    'To validate frame count?', ...
    'Yes','No','Yes');
% Handle response
switch answer
    case 'Yes'
        skip_validation_flag = 1;
    case 'No'
        disp([answer ' coming right up.'])
        skip_validation_flag = 0;
        %     case 'No thank you'
        %         disp('I''ll bring you your check.')
        %         dessert = 0;
end
skip_validation_flag=skip_validation_flag==1;
%% Find parcels, identify mismath in number of frames
disp('FINDING PARCELS AND VALIDATING FRAME COUNTS')
tic
for k=1:n
    disp(['Reading parcellations for survivor ' num2str(k) ' out of ' num2str(n)])
    i=ix_surv(k);
    
    path_to_nii=[strtrim(handles.participants.full_path(i,:)) fs 'func'];
    %     dummy=strtrim(evalc(['! ls -1 ' path_to_nii '/*rest_bold*.ptseries.nii']));
    %     nii_files=regexp(dummy,'\n','split');
    %     while length(strtrim(nii_files{end}))==0
    %         nii_files(end)=[];
    %     end
    
    dummy=dir([path_to_nii  fs '*rest*bold*.ptseries.nii']);
    
    nn=size(dummy,1);
    nii_files=cell(nn,1);
    for iii=1:nn
        nii_files{iii}=[dummy(iii).folder fs dummy(iii).name];
    end
    
    n_nii=length(nii_files);
    nii_files_temp=cell(n_nii,1);
    for x = 1:n_nii
        %         pt = split(nii_files{x},"atlas-");
        pt = split(nii_files{x},'atlas-');
        if size(pt) < 2
            pt = split(nii_files{x},'roi-');
            nii_files{x} = strrep(nii_files{x},'atlas','roi');
            disp(nii_files{x})
        end
        nii_files_temp{x} = pt{2};
    end
    parcel_names{k}=nii_files_temp;
    temp=cell(n_nii,1);
    frame_count=zeros(n_nii,1);
    if skip_validation_flag
        this_guy_frames_per_rest=handles.mc.frames{i};
        frame_count(:)=sum(this_guy_frames_per_rest);
    else
        disp(['Validating frames and parcellations for survivor ' num2str(k) ' out of ' num2str(n)])
        parcels_per_study(k)=n_nii;
        for j = 1:n_nii
            [pathstr,name,ext] = fileparts(nii_files{j});
            temp{j}=name;
            %         c =ciftiopen(nii_files{j}, '/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command');
            %         c =ciftiopen(nii_files{j}, handles.paths.wb_command);
            %         [num_parcels,frame_count(j)]=size(c.cdata);
            
            % Avoiding ciftiopen
            nii_files{j};
            c = read_cifti_via_csv (nii_files{j},quotes_if_space(handles.paths.wb_command));
            [num_parcels,frame_count(j)]=size(c);
        end
    end
    this_guy_frames_per_rest=handles.mc.frames{i};
    this_guy_frames_total=sum(this_guy_frames_per_rest);
    validate=this_guy_frames_total~=frame_count;
    mismatch_frames(k)=sum(validate);%find mismatch in frames
    if sum(validate) > 0 % to keep track of mismatchs
        parcels_that_mismatch{k}=nii_files(find(validate));
    end
    %     parcel_names{k}=temp;
end
disp('Done')
toc
disp(' ')

%%
if skip_validation_flag==0
%% Everyone has all the parcels?
max_parcels=max(parcels_per_study);
ix=find(parcels_per_study==max_parcels,1);
potential_parcels=char(parcel_names{ix});
ix_parcel_to_exclude=zeros(max_parcels,1);
ix_participant=zeros(n,1);
for i=1:n
    found=ismember(potential_parcels,char(parcel_names{i}),'rows');
    validate=found==0;
    ix_parcel_to_exclude(validate)=1;
    ix_participant(i)=sum(validate)>0;
end
%%
temp=potential_parcels(ix_parcel_to_exclude==0,:);
n_surv_parcels=sum(~ix_parcel_to_exclude);
surv_parcels=cell(n_surv_parcels,1);
for i=1:n_surv_parcels
    [a, b, c]=fileparts(strtrim(temp(i,:)));
    surv_parcels{i}=b;
end
else
    surv_parcels=unique(cat(1,parcel_names{:}));
    surv_parcels = strrep( surv_parcels , '.nii' , '');
end
handles.mc.surv_parcels=surv_parcels;
%% Error report, mismatch between reported frames in motion numbers and csv's
if skip_validation_flag==0
    disp('REPORTING POTENTIAL MISMATCH BETWEEN REPORTED FRAMES IN MOTION NUMBERS AND CIFTI FILES: ')
    if sum(mismatch_frames)==0
        disp('No mismatch found')
        disp(' ')
    else
        ix=find(mismatch_frames);
        n_mismatch=max(size(ix));
        disp(['There is a mismatch in frame count for ' num2str(n_mismatch) ' study(ies):'])
        for j=1:n_mismatch
            i=ix_surv(ix(j));
            path_to_nii=[strtrim(handles.participants.full_path(i,:)) fs 'func'];
            
            %path_to_csv=[strtrim(handles.participants.full_path(i,:)) fs handles.paths.append_path_csv_parcellations];
            path_to_frames=[strtrim(handles.participants.full_path(i,:)) fs 'func'];
            disp(['Error ' num2str(j) ' out of ' num2str(n_mismatch)])
            disp(['Study located in the row # ' num2str(i)])
            disp(['Frames reported in ' cell2mat(parcels_that_mismatch{ix(j)}) ' do(es) not match frames reported in frames_per_scan.txt'])
            disp('Find frames_per_scan.txt here:')
            disp(char(path_to_frames))
            disp('Find cifti parcels here:')
            disp(char(path_to_nii))
            disp(' ')
        end
        disp('No action taken')
        disp('You can decide to exclude that participant or to exclude the parcels')
    end
end

%% Warning report, parcels available
if skip_validation_flag==0
    disp(' ')
    disp('REPORTING PARCELS')
    disp(['The following ' num2str(n_surv_parcels) ' parcellation(s) were found for all the studies'])
    disp([num2str([1:n_surv_parcels]') repmat(') ',n_surv_parcels,1) char(surv_parcels)]);
    disp(' ')
    if sum(ix_parcel_to_exclude)>0
        disp('At least the following parcel(s) is(are) not included in all the studies ')
        disp(potential_parcels(ix_parcel_to_exclude==1,:));
        disp('Double check the parcels/participants that you''d like to include')
    end
    disp (' ')
end


