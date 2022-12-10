function tall_table=read_combine_R_p_and_Cohen(text_for_dir,fconn_reg_settings_labels)


%% read subfolders with data
pot_dir=dir(text_for_dir);

to_kill=[];
for i=1:size(pot_dir,1)
    if strcmp(pot_dir(i).name(1),'.')
        to_kill=[to_kill i];
    end
end
pot_dir(to_kill)=[];

n=size(pot_dir,1);




%% decompose folder name into data
n_coded=size(fconn_reg_settings_labels,2);
fconn_reg_settings_data=zeros(n,n_coded);



for i=1:n
    codded_info=pot_dir(i).name;
    for j=1:n_coded-1
        [startIndex1,endIndex1] = regexp(codded_info,fconn_reg_settings_labels{j});
        [startIndex2,endIndex2] = regexp(codded_info,fconn_reg_settings_labels{j+1});
        if isempty(endIndex1)
            endIndex1=0;
        end
        fconn_reg_settings_data(i,j)=str2double(codded_info(endIndex1+1:startIndex2-1));
        codded_info(1:endIndex2)=[];
    end
    fconn_reg_settings_data(i,end)=str2double(codded_info);
end

%% clean names for table
for j=1:n_coded
    local_text=fconn_reg_settings_labels{j};
    while strcmp(local_text(1),'_')
        local_text(1)=[];
    end
    while strcmp(local_text(end),'_')
        local_text(end)=[];
    end
    fconn_reg_settings_labels{j}=local_text;
        
end
%% read tables
cell_tables=cell(n,1);

for i=1:n
    
    local_path=[pot_dir(i).folder filesep pot_dir(i).name];
    path_filename_Rs=[local_path filesep 'R_p_from_zscores.csv'];
    path_filename_Cohen=[local_path filesep 'Cohen_effect_size.csv'];
    
%     t_R=read_fconn_regression_csvs(path_filename_Rs);
%     t_Cohen=read_fconn_regression_csvs(path_filename_Cohen);
    t_R=import_fconn_regression_csvs(path_filename_Rs);
    t_Cohen=import_fconn_regression_csvs(path_filename_Cohen);
    
    cat_t_R_cohen=cat_sort_tables(t_R,t_Cohen);
    n_rows=size(cat_t_R_cohen,1);
    for j=1:n_coded
        header=fconn_reg_settings_labels{j};
        data=repmat(fconn_reg_settings_data(i,j),n_rows,1);
        cat_t_R_cohen=append_colums(cat_t_R_cohen,header,data);
    end
    cell_tables{i}=cat_t_R_cohen;
end
%%
tall_table=cat_cell_tables(cell_tables);