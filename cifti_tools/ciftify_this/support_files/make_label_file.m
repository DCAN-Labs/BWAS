function make_label_file(scene,name,gordon_label,path_wb_c,template_label)
n=size(scene,2);
n=numel(fieldnames(scene));
n=1;
formatSpec = '%s %s %s %s %s\n';
% template_label='C:\Users\mirandad\Documents\MATLAB\OSCAR_WIP\cifti_tools\ciftify_this\support_files\xlabel_files\Human\Gordon\fsLR\Gordon.networks.32k_fs_LR.dlabel.nii';

all_label=[name '.dlabel.nii'];
delete(all_label);
for i=1:n
    temp=gordon_label;
    m=length(scene(i).ix);
    ix_m=scene(i).ix;
    for j=1:m
        local_ix=2*ix_m(j);
        RGB=round(scene(i).RGB(j,:)*255);
        alpha=scene(i).alpha(j);
        temp{local_ix,2}=num2str(RGB(1));
        temp{local_ix,3}=num2str(RGB(2));
        temp{local_ix,4}=num2str(RGB(3));
%         temp{local_ix,5}=num2str(alpha);
        temp{local_ix,5}=num2str(255);
    end
    
    % Make temp txt file
    txt_fname=['scene_' num2str(i) '.txt'];
    fileID = fopen(txt_fname,'w');
    for row=1:size(temp,1)
        fprintf(fileID,formatSpec,temp{row,:});
    end
    fclose(fileID);
    
    this_label=[txt_fname(1:end-4) '.dlabel.nii'];
    % Make cifti label file
%     [a ]=evalc(['! wb_command -cifti-label-import ' template_label ' ' txt_fname ' ' this_label]);
    [a]=evalc(['! ' path_wb_c ' -cifti-label-import ' template_label ' ' txt_fname ' ' this_label]);
    
    if i==1
        copyfile(this_label,all_label);
    else
%         evalc(['! wb_command -cifti-merge ' all_label ' -cifti ' all_label ' -cifti ' this_label]);
        b=evalc(['! ' path_wb_c ' -cifti-merge ' all_label ' -cifti ' all_label ' -column 1 -cifti ' this_label]);
        
    end
    delete(this_label);
end
