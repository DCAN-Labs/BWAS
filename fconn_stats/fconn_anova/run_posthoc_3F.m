function global_stats=run_posthoc_3F(global_stats)
rm=global_stats.main_fit_model;
parcel=global_stats.parcel;
i=1;
arg1=rm.WithinFactorNames{1};
arg3=rm.WithinFactorNames{2};
arg2=rm.BetweenFactorNames{i};
options=global_stats.options;
between_design=global_stats.between_design;
within_design=global_stats.within_design;

m=margmean(rm,{arg1 arg2 arg3 });
within_plus_conn=global_stats.within_plus_conn;
ix_to_ix_table=global_stats.ix_to_ix_table;

to_run=global_stats.command_to_run_main_test;
to_run(end-11:end)=[];
to_run=[to_run ');'];
tt=global_stats.table_raw_data;
% plot_mcomp3F_RM_by_connections(m,parcel,global_stats.options,arg1,arg2,arg3,between_design(1),tt,to_run,within_plus_conn,ix_to_ix_table,global_stats)

posthoc_3F_RM_exhaustive=plot_connections_from_isolated_NN(m,parcel,global_stats.options,arg1,arg2,arg3,between_design(1),tt,to_run,within_plus_conn,ix_to_ix_table,global_stats);
global_stats.posthoc_3F_RM_exhaustive=posthoc_3F_RM_exhaustive;
save_p_tables(global_stats);