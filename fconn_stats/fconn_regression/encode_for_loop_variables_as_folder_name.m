function save_folder=encode_for_loop_variables_as_folder_name(wd,to_encode_names_in_folder_name)
f=filesep;
n=size(to_encode_names_in_folder_name,2);

save_folder=[wd f];
i=1;
save_folder=[save_folder to_encode_names_in_folder_name(i).name '_' to_encode_names_in_folder_name(i).value];
for i=2:n
    save_folder=[save_folder '_' to_encode_names_in_folder_name(i).name '_' to_encode_names_in_folder_name(i).value];
end