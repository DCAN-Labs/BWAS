function [R, model,local_fit]=residuals_by_mass_univariate(user_provided_model_flag,...
    ind,...
    T_column_names_for_id,...
    T_column_names_for_between,...
    T_column_names_for_within,...
    catT,...
    BrainFeatures_table,...
    output_folder,...
    fs,...
    Y,...
    options)

%% Read potential model

if user_provided_model_flag==0
    % Get the model structure
    model=get_default_residualizer_model(ind,T_column_names_for_id,T_column_names_for_between,T_column_names_for_within);
end

%% Fit the model
n=size(Y,2);

% Read original terms
original_terms=get_right_side_terms(model);
n_original_terms=numel(original_terms);
T_included_terms=zeros(n,n_original_terms);
%% find non imaging headers and make table with those columnes

IX_until_demo=find_ix_in_header(catT,'Y1')-1;
partialT=catT(:,1:IX_until_demo);

%%
R=nan(size(Y));
for i=1:n
    prelim_model=reuse_model_from_rmanova(model,i);
    local_ix=find_ix_in_header(catT,['Y' num2str(i)]);
    localT=[partialT catT(:,local_ix)];
    prelim_fit=fitlm(localT,prelim_model);
    if options.only_consider_significant_covariates_in_mass_univariate==1
        try
            updated_model=adjust_model_from_ranovatbl(prelim_model,prelim_fit.Coefficients);
            [shaved_model, T_included_terms(i,:)] = shave_model(prelim_model,updated_model);
            local_fit=fitlm(localT,shaved_model);
            %% Predict corrected responses
            try
                YP=predict(local_fit,localT);
            catch
                YP=0*Y{:,i};
            end
        catch
            YP=0*Y{:,i};
        end
    else
        [shaved_model, T_included_terms(i,:)] = shave_model(prelim_model,prelim_model);
        local_fit=prelim_fit;
        YP=predict(local_fit,localT);
    end
    %% Calculate residuals
    R(:,i)=Y{:,i}-YP;
    ['n = ' num2str(i) '; ptile= ' num2format_text(100*i/n) '%']
end

%% Report percent used terms
report_used_terms(n,T_included_terms,original_terms,output_folder)
%% Save table
% save([output_folder fs 'ranovatbl.mat'],'ranovatbl')
% save_main_anova_table(ranovatbl, [output_folder fs 'ranovatbl.csv'])
%
% save_model(output_folder,model,'model');