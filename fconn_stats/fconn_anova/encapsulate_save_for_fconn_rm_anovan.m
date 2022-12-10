function encapsulate_save_for_fconn_rm_anovan(full_filename,fconn,parcel,between_design,within_design,options)

% This function encapsulates and saves data to be used in exacloud for the
% function fconn_rm_anovan
%% chech full_filename has mat as extension
[pathstr,name,ext] = fileparts(full_filename);

fs=filesep;
ok_ext='.mat';
if strcmp(ext,ok_ext)
    fixed_full_filename=full_filename;
else
    ext=ok_ext;
    fixed_full_filename=[pathstr fs name ext];
end
%% make directory, if needed
count_subfolders=dir(pathstr);
if length(count_subfolders)<1
    mkdir(pathstr)
end
 %% saving data
save(fixed_full_filename,'fconn');
save(fixed_full_filename,'parcel','-append');
save(fixed_full_filename,'between_design','-append');
save(fixed_full_filename,'within_design','-append');
save(fixed_full_filename,'options','-append');

%% Change permissions
% try
%  fileattrib(fixed_full_filename, '+w');
%  fileattrib(fixed_full_filename, '+r');
% catch
% end
