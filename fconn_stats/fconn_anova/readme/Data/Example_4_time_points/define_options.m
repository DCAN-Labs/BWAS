%% Define options for repeated measures anova n

% Correction for multiple comparisons
% correction_type:
% 1}='tukey-kramer';
% 2}='dunn-sidak';
% 3}='bonferroni';
% 4}='scheffe';
% 5}='lsd';
options.correction_type=2;

% Here you define if you want to make the analysis on a few networks or
% not. It acceots as input a vector with the functional networks you want
% to include. IF not provided, it uses all the available networks. You can
% also us as input '[]' to use all the networks
% options.resort_parcel_order=[];
options.resort_parcel_order=[5 6 7];
options.resort_parcel_order=[];

% Apply Fisher_Z_transform to connectivity values. Use 1 or 0
options.calculate_Fisher_Z_transform=0;

% Apply an optimized box_cox transform to the data.
options.boxcox_transform=0;

options.save_figures=1;
options.display_figures=1;
% options.plot_uncorrected_NN_other_factor=1;

% p-value threshold used for visualization
options.p_th=[0.05];

% show numerical scale for connectivity values (y-axis)
options.show_y_scale=1;

% options.filename_to_save_all_before_plotting
options.filename_to_save_all_before_plotting='all_results';