#!/usr/bin/env bash

/home/exacloud/lustre1/fnl_lab/code/external/GUIs/MATLAB/R2018a/mcc -v -m -R -singleCompThread \
	-o GUI_environments GUI_environments.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/GUI_environments.fig \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/GUI_environments.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/change_permissions.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/count_remaining_frames.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/find_parcellated_paths.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/isthisanoutlier.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_file_censored_data.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_filename_censored_data.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_hist_surv.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_model_based_env.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_no_autocorrelation_env.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_outliers_mask.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_std_env.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_text_FD_th.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_text_survivors.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/make_wrapper_connectotype.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/read_cifti_via_csv.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/read_motion_data.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/read_participants_and_paths.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/remove_autocorrelation.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/settings_make_par_env.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/text_after_reading_path.m \
    -a /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/validate_path_wb_command.m

# -I /home/exacloud/lustre1/fnl_lab/code/internal/GUIs/BIDS_conn_matrix_maker/
