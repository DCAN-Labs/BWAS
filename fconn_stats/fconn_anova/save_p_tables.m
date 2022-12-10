function save_p_tables(global_stats)
filename_table{1}='p_uncorrected';
filename_table{2}='p_corrected_fdr_bh';
filename_table{3}='p_corrected_mafdr';
filename_table{4}='DOF';


local_table=cell(4,1);

to_include=':';



local_table{1}=global_stats.posthoc_3F_RM_exhaustive.p_uncorrected_table(:,to_include);
local_table{2}=global_stats.posthoc_3F_RM_exhaustive.p_corrected_table_fdr_bh(:,to_include);
local_table{3}=global_stats.posthoc_3F_RM_exhaustive.p_corrected_table_mafdr(:,to_include);
local_table{4}=global_stats.posthoc_3F_RM_exhaustive.DOF_table(:,to_include);
for j=1:4
    try
    writetable(local_table{j},[filename_table{j} '.csv'],'WriteRowNames',true)
    end
end

RowNames=local_table{1}.Properties.RowNames;
filePh = fopen(['RowNames.txt'],'w');
fprintf(filePh,'%s\n',RowNames{:});
fclose(filePh);
