function posthoc_3F_RM_by_connections=run_posthoc_3F_RM_by_connections(global_stats,between_design)

% arg1=rm.WithinFactorNames{3};
% m=margmean(rm,{arg1 arg2 arg3 });
% 
% 
% posthoc_3F_RM_by_connections=plot_mcomp3F_RM_by_connections(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within_plus_conn,ix_to_ix_table,global_stats);
%%
parcel=global_stats.parcel;
rm=global_stats.main_fit_model;
i=1;
arg1=rm.WithinFactorNames{3};
arg3=rm.WithinFactorNames{2};
arg2=rm.BetweenFactorNames{i};
options=global_stats.options;
m=margmean(rm,{arg1 arg2 arg3 });
within_plus_conn=global_stats.within_plus_conn;
ix_to_ix_table=global_stats.ix_to_ix_table;

to_run=global_stats.command_to_run_main_test;
to_run(end-11:end)=[];
to_run=[to_run ');'];
tt=global_stats.table_raw_data;

posthoc_3F_RM_by_connections=plot_mcomp3F_RM_by_connections(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within_plus_conn,ix_to_ix_table,global_stats);