function make_cummulative_and_null_by_network(IX,...
    Y,...
    ids,...
    orig_sort_network_names,...
    betas,...
    x,...
    options,...
    path_reference_table_by_networks)
%% check if skip_figures_flag
filename='correlations_by_networks.csv';
path_PNRS_table=[pwd filesep 'tables' filesep filename];
T = readtable(path_PNRS_table);
if ~exist('path_reference_table_by_networks','var')
    filename='correlations_by_networks.csv';
    path_reference_table_by_networks=[pwd filesep 'tables' filesep filename];
end
%% Tablify fconn
fconn=table2array(Y);
[n_subjects,n_features]=size(fconn);


%% read networks to sort by
temp_T_to_sort_by = readtable(path_reference_table_by_networks);

%% resort T by temp_T_to_sort_by


n_networks=size(T,1);
ix_to_sort_by=nan(n_networks,1);
for ii=1:n_networks
    ix_to_sort_by(ii)=find(ismember(T{:,1},temp_T_to_sort_by{ii,1}));
end
T=T(ix_to_sort_by,:);
%% Find ix top
ix_top=nan(n_networks,1);
for i=1:n_networks
    ix_top(i)=find(ismember(orig_sort_network_names,T{i,1}));
end

%% Make cummulative sum
cumIX=cumsum(IX(ix_top,:));
% cumIX=cumIX>0;
brain_features=sum(cumIX,2);
percent_brain_features=100*brain_features/brain_features(end);
T_brain_features=table(brain_features,percent_brain_features);
%%
PBScores_cum = get_PBScores(n_subjects,...
    n_networks,...
    betas,...
    fconn,...
    cumIX);

% PBScores_cum = get_PBScores(n_subjects,...
%     n_networks,...
%     betas,...
%     fconn,...
%     IX(ix_top,:));

%% Tablify PBScores
%% Tablify PBScores
Tscores=array2table(PBScores_cum);
u=orig_sort_network_names(ix_top);
try
    Tscores.Properties.VariableNames=u;
catch
    temp=u;
    temp=strrep(temp,' ','_');
    Tscores.Properties.VariableNames=temp;
end
    
Tscores=[ids Tscores];

filename='scores_by_networks_cummulative.csv';
writetable(Tscores,[pwd filesep 'tables' filesep filename])
clear Tscores
%% make R cumsum
Rcum=corr(PBScores_cum,x);
Vcum=100*Rcum.^2;

%% Make Null
N_null=options.N_null;
R_Null=nan(n_networks,N_null);
PBScores_cum_Null=nan(n_subjects,n_networks,N_null);

for i=1:N_null
    ix_random=randperm(n_networks);
    cumIX=cumsum(IX(ix_random,:));
    PBScores_cum_Null(:,:,i)=get_PBScores(n_subjects,...
        n_networks,...
        betas,...
        fconn,...
        cumIX);
    R_Null(:,i)=corr(squeeze(PBScores_cum_Null(:,:,i)),x);
    display(['Calculating Null cummulative by networks, run ' num2str(i) ' out of ' num2str(N_null)])
end

V_Null=100*R_Null.^2;
%%
save_planB([pwd filesep 'PBScores_by_networks_cum_Null.mat'],PBScores_cum_Null);
% save_planB('PBScores_by_networks_cum_Null.mat','PBScores_cum_Null');
%% Make figure Null
R=T{:,2};
V=T{:,3};

xlab=T{:,1};
tit='% Explained Variance by networks';
plot_data_versus_null(Vcum,V_Null,xlab,...
    tit)
plot_data_versus_null(Vcum,V_Null,xlab,...
    tit,15)
tit='Correlations by networks';
plot_data_versus_null(Rcum,R_Null,xlab,...
    tit)
plot_data_versus_null(Rcum,R_Null,xlab,...
    tit,15)

%% Make table
TT=[T table(Rcum) table(Vcum) T_brain_features];
filename='correlations_by_networks_plus_cummulative.csv';
writetable(TT,[pwd filesep 'tables' filesep filename]);

%% Repeat for negative correlations

%% Make cummulative sum
cumIX=cumsum(IX(ix_top(end:-1:1),:));
brain_features=sum(cumIX,2);
percent_brain_features=100*brain_features/brain_features(end);
T_brain_features=table(brain_features,percent_brain_features);
%%
PBScores_cum = get_PBScores(n_subjects,...
    n_networks,...
    betas,...
    fconn,...
    cumIX);
%% Tablify reversed PBScores
Tscores=array2table(PBScores_cum);
u=orig_sort_network_names(ix_top(end:-1:1));
try
    Tscores.Properties.VariableNames=u;
catch
    temp=u;
    temp=strrep(temp,' ','_');
    Tscores.Properties.VariableNames=temp;
end
    
Tscores=[ids Tscores];

filename='scores_by_networks_cummulative_reversed.csv';
writetable(Tscores,[pwd filesep 'tables' filesep filename])
clear Tscores
%% make R cumsum
Rcum=corr(PBScores_cum,x);
Vcum=100*Rcum.^2;
%% Make figure Null


xlab=T{end:-1:1,1};
tit='% Explained Variance by networks (Neg corr)';
plot_data_versus_null(Vcum,V_Null,xlab,...
    tit)
plot_data_versus_null(Vcum,V_Null,xlab,...
    tit,15)
tit='Correlations by networks (Neg corr)';
plot_data_versus_null(Rcum,R_Null,xlab,...
    tit)
plot_data_versus_null(Rcum,R_Null,xlab,...
    tit,15)


%% Make table 
TT=[T(end:-1:1,:) table(Rcum) table(Vcum) T_brain_features];
filename='correlations_by_networks_plus_cummulative_reversed.csv';
writetable(TT,[pwd filesep 'tables' filesep filename]);