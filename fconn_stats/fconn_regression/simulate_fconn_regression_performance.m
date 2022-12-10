function [h, data, sim_options,local_fconn_reg_options]=simulate_fconn_regression_performance(path_pred_results,simulated_main_table,within_headers,system_pair,varargin)

%% seed random number generator
rng('shuffle');
%% for debugiung
% path_pred_results='V:\FAIR_HORAK\Projects\Martina_RO1\Experiments\open_closed_loop\results_predicting_closed_loop_ctyping_saving_outputs\one_sample\rep_286_null_10000_out_3_n_comp_4_transformed_outcome_1\pred_results.mat';
% path_surrogated_data='V:\FAIR_HORAK\Projects\Martina_RO1\surrogate_connectotyping\Functional\List_MCMethod_power_2014_FD_only_FD_th_0_30_min_frames_165_skip_frames_5_TRseconds_2_00\Gordon_subcortical\fconn_168_frames.mat';
% system_pair={'Sal and Sub'};
% system_pair={'Aud and Vis'};
% system_pair={'CiP and Sub'};
%% Define default options
ss_to_explore=[10 20:10:40 60:20:120];
n_rep=100;
add_noise_flag=0;
xval_for_sim='ratio';%'ratio or same'
%% Read varargin

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'ss_to_explore'
            ss_to_explore=varargin{q+1};
            q = q+1;
            
        case 'n_rep'
            n_rep=varargin{q+1};
            q = q+1;
            
            
        case 'add_noise_flag'
            add_noise_flag=varargin{q+1};
            q = q+1;
            
        case 'xval_for_sim'
            xval_for_sim=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

add_noise_flag=add_noise_flag==1;


%% Read fconn_regression results
load(path_pred_results)

%% add original sample size

n_orig=size(local_y,1);
ss_to_explore=[ss_to_explore(:);  n_orig];
ss_to_explore=unique(ss_to_explore);
ss_to_explore=sort(ss_to_explore);
n_ss_to_explore=size(ss_to_explore,1);
%% Encapsulate options for simulations
sim_options.ss_to_explore=ss_to_explore(:)';
sim_options.n_rep=n_rep;
sim_options.add_noise_flag=add_noise_flag;
sim_options.xval_for_sim=xval_for_sim;
T_sim_options=struct2table(sim_options);
filename=[system_pair{:} '_sim_options.csv'];
filename= strrep( filename , ' ' , '_' );
writetable(T_sim_options,filename);

%% calculate scores
[truncated_table, truncated_within_headers]=truncate_simulated_main_table(simulated_main_table,within_headers,system_pair);
beta=get_weights(main_table,fconn_reg_options,within_headers,system_pair,local_y);
surrogated_y=get_surrogate_y(truncated_table,beta);
%% add noise
ix=find(ismember(labels,system_pair));
e=Y{ix}.alt.observed-Y{ix}.alt.predicted;
mu=mean(e(:));
sigma=std(e(:));
%% preallocate partitions

n_surr_subjects=size(simulated_main_table,1);
IX=index_for_subsampling_surrogate_data(ss_to_explore,n_surr_subjects,n_rep,fconn_reg_options);
%%

local_fconn_reg_options=fconn_reg_options;
local_fconn_reg_options.N=numel(performance{end}.alt.mae);

%% Save original fconn_reg_options

T_local_fconn_reg_options=struct2table(local_fconn_reg_options);
filename=[system_pair{:} '_local_fconn_reg_options.csv'];
filename= strrep( filename , ' ' , '_' );
writetable(T_sim_options,filename);

% local_fconn_reg_options.N_Null=11;
%%
mae_alt=nan(n_ss_to_explore,n_rep,local_fconn_reg_options.N);
mae_nul=nan(n_ss_to_explore,n_rep,local_fconn_reg_options.N_Null);
ss_alt=nan(n_ss_to_explore,n_rep,local_fconn_reg_options.N);
ss_null=nan(n_ss_to_explore,n_rep,local_fconn_reg_options.N_Null);

d=zeros(n_ss_to_explore,n_rep);
ss_d=zeros(n_ss_to_explore,n_rep);
%%

ratio=local_fconn_reg_options.xval_left_N_out/n_orig;
%%
for i=n_ss_to_explore:-1:1
    local_IX=IX{i};
    local_n=size(local_IX,2);
    switch xval_for_sim
        case 'ratio'
            local_fconn_reg_options.xval_left_N_out=round(local_n*ratio);
    end
    for j=1:n_rep
        ix=local_IX(j,:);
        local_main_table=truncated_table(ix,:);
        local_surrogated_y=surrogated_y(ix);
        
        r=normrnd(mu,sigma,[local_n 1]);
        
        local_surrogated_y=local_surrogated_y+r*add_noise_flag;
        
        
        %         local_fconn_reg_options.xval_left_N_out=round(local_n*ratio);
        try
            [perf,W,labs,localP,localY]=fconn_regression(local_main_table, truncated_within_headers,local_surrogated_y,local_fconn_reg_options);
            local_mae_alt=perf{1}.alt.mae;
            till=size(local_mae_alt,1);
            mae_alt(i,j,1:till)=perf{1}.alt.mae;
            ss_alt(i,j,:)=local_n;
            
            mae_nul(i,j,:)=perf{1}.null.mae;
            ss_null(i,j,:)=local_n;
            
            
            d(i,j)=abs(computeCohen_d(mae_nul(i,j,:),mae_alt(i,j,1:till)));
            ss_d(i,j)=local_n;
            display(['Sample size n = ' num2str(local_n) ', replica ' num2str(j) ' out of ' num2str(n_rep)])
            display(['Cummulative Cohen effect size ' num2str(mean(d(i,1:j)),'%4.2f')])
        end
    end
end
display(['Done!'])
%% Encapsulate data

data(1).name='Cohen_effect_size';
data(1).x=ss_d(:);
data(1).y=d(:);


data(2).name='Alternative_hypothesis';
data(2).x=ss_alt(:);
data(2).y=mae_alt(:);

data(3).name='Null_hypothesis_data';
data(3).x=ss_null(:);
data(3).y=mae_nul(:);

% explore_parameters_fconn_regression(local_main_table,truncated_within_headers,local_surrogated_y,local_fconn_reg_options)
%% ploting

h=plot_simulate_fconn_regression_performance(data,system_pair);
% set(gcf,'color','w')
% set(gcf,'units','centimeters')
% set(gcf,'position',[8 8 12 11])
%
% dotted_line_flag=0;
% yl=[-.1 2.1];
%
% subplot 311
% t_d=table(num2str(ss_d(:)),d(:));
% t_d.Properties.VariableNames{2}='Cohen_effect_size';
% skinny_plot(t_d,repmat([44,162,95]/255,n_ss_to_explore,1),...
%     'dotted_line_flag',dotted_line_flag,...
%     'yl',yl)
% ylabel('d''s effect size')
%
% subplot 312
% t_mae_alt=table(num2str(ss_alt(:)),mae_alt(:));
% t_mae_alt.Properties.VariableNames{2}='Alternative_hypothesis';
% skinny_plot(t_mae_alt,repmat([.90 .60 .00],n_ss_to_explore,1),...
%     'dotted_line_flag',dotted_line_flag,...
%     'yl',yl)
% ylabel('Absolute error')
%
% subplot 313
% t_mae_nul=table(num2str(ss_null(:)),mae_nul(:));
% t_mae_nul.Properties.VariableNames{2}='Null_hypothesis_data';
% skinny_plot(t_mae_nul,repmat([0 0 0],n_ss_to_explore,1),...
%     'dotted_line_flag',dotted_line_flag,...
%     'yl',yl)
% ylabel('Absolute error')
%
