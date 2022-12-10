function [C,V] = correlations_by_network_to_M(path_to_correlations_by_network,...
    varargin)
%%
% path_to_correlations_by_network='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/make_BWAS_emo_dysreg/Gordon/FD_0_20_time_08_mins_all/PNRS_ARM2/case2_yes_covariates_g1/correlations_by_networks.csv';
% [C,V] = correlations_by_network_to_M(path_to_correlations_by_network);
%% define defaults

[ output_folder , name , ext ] = fileparts( path_to_correlations_by_network ) ;
fs=filesep;

%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Make figures

T=readtable(path_to_correlations_by_network);
T = unfold_network_network(T);
[C, V] = T_to_C_V(T);
tit='Correlations';
show_R_C_as_M(C,tit)
neg_pos_cmap;
save_fig([tit '_by_networks'],...
    'path_to_save',output_folder)

tit='% Explained variance';
show_R_C_as_M(V,tit)
colormap (1-winter)
save_fig([tit '_by_networks'],...
    'path_to_save',output_folder)
