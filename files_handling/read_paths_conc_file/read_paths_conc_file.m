function paths=read_paths_conc_file(conc_file_and_path)


%%
fid = fopen(conc_file_and_path);
tline = fgetl(fid);
i=0;

while ischar(tline)
    i=i+1;
%     disp(tline);
    tline = fgetl(fid);
end


fclose(fid);
%%
n_subjects=i;
paths=cell(n_subjects,1);

fid = fopen(conc_file_and_path);
tline = fgetl(fid);
i=0;
while ischar(tline)
    i=i+1;
    paths{i}=tline;
%     disp(tline);
    tline = fgetl(fid);
end
