
%% For poster
cd C:\Users\mirandad\Desktop
options.correction_type=2;
options.resort_parcel_order=[8 5 2];
% options.resort_parcel_order=[];
options.calculate_Fisher_Z_transform=1;
options.boxcox_transform=0;
options.save_figures=0;
options.display_figures=1;
options.plot_uncorrected_NN_other_factor=1;
options.p_th=0.05;
options.show_y_scale=1;
options.is_connectotyping=1;
options.avoid_main_table=1;
% [main_table_long, global_stats]=fconn_rm_anovan(fconn,parcel,between_design,within_design,options);
%
[main_table_long, global_stats]=fconn_rm_anovan_ctyping(fconn,parcel,between_design,within_design,options);