function patch_W_V_across_samples(brain_features,...
    betas,...
    outcome,...
    output_folder_W_V,...
    R)

%%
W=[betas.Estimate]';
[n_subjects,n_brain_features]=size(brain_features);
Wrep=repmat(W,n_subjects,1);
pred=Wrep.*brain_features;

r=corr(outcome,pred);
V=r.^2;

plot_W_V(W(:),V(:),output_folder_W_V)
%% This section is to show  how not to select features
% show_exp_variance_overfitting(V,...
%     outcome,...
%     pred,...
%     output_folder_W_V)
%% Plot pValues and variance
old='Weights_ExplainedVariance';
new='pValues_ExplainedVariance';
plot_P_V_output_folder = strrep(output_folder_W_V,old,new);
P=betas.pValue;
my_color_ix=2;
plot_P_V(P,V(:),plot_P_V_output_folder,...
    my_color_ix);
%% Plot pValues and variance within and between sample
old='Weights_ExplainedVariance';
new='pValues_ExplainedVariance_2_samples';
plot_P_V_output_folder = strrep(output_folder_W_V,old,new);
plot_P_V(P,[ R{:,end} V(:)],plot_P_V_output_folder);
%% Save table
T=table([1:n_brain_features]',V(:),V(:));
T.Properties.VariableNames{1}='index';
T.Properties.VariableNames{2}='Ordinary';
T.Properties.VariableNames{3}='Adjusted';
filename='Rsquared.csv';

old='figures';
new='tables';
Tpath=strrep( output_folder_W_V , old , new );
if ~isfolder(Tpath)
    mkdir(Tpath)
end
fullfilename=[Tpath filesep filename];
writetable( T,fullfilename);