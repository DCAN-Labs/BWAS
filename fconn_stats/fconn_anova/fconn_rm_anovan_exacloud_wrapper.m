function fconn_rm_anovan_exacloud_wrapper(mat_file_input_data)

% mat_file_input_data: file with the data required to run fconn_rm_anovan


[ pathstr , name, ext] = fileparts( mat_file_input_data ) ;
foo=pwd;
cd (pathstr)
load (mat_file_input_data);

[main_table, global_stats] = fconn_rm_anovan(fconn,parcel,between_design,within_design,options)
global_stats=run_posthoc_3F(global_stats);

if ~isempty(within_design)
    posthoc_3F_RM_by_connections=run_posthoc_3F_RM_by_connections(global_stats,between_design);
    global_stats.posthoc_3F_RM_by_connections=posthoc_3F_RM_by_connections;
end


mat_file_output_data=[pathstr filesep 'output_' name  ext];
save(mat_file_output_data,'main_table', 'global_stats');
cd (foo)