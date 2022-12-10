function make_file_censored_data(handles)
surv_file=[handles.env.path_group_list filesep handles.env.group handles.env.original_filename_ext];

ix=handles.mc.surv_ix;
n=sum(ix,1);
fileID = fopen(surv_file,'wt');

ix1=find(ix(:,1));
T=table(handles.participants.full_path(ix1,:));
writetable(T,surv_file,'WriteVariableNames',0);
% for i=1:n(1)
%     fprintf(fileID,[handles.participants.full_path(ix1(i),:) '\n']);
% end
% fclose(fileID);
% change_permissions(handles,surv_file)
