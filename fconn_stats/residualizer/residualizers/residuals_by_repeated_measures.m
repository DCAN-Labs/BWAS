function [R, model,ranovatbl]=residuals_by_repeated_measures(user_provided_model_flag,...
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

%% Identify model with significant effects

if user_provided_model_flag==0
    % Get the model structure
    prelim_model=get_default_residualizer_model(ind,T_column_names_for_id,T_column_names_for_between,T_column_names_for_within);
    disp('Scouted model')
    disp(prelim_model)
    
    % Fit the prelim_model
    rm = fitrm(catT,prelim_model,'WithinDesign',BrainFeatures_table);
    
    % show significance
    ranovatbl = ranova(rm);
    disp('Scouted model stats')
    disp(ranovatbl)
    
    % recalculate model 
    try
    model=adjust_model_from_ranovatbl(prelim_model,ranovatbl);
    
    catch
        model=prelim_model;
        display(['No need to residualize the data'])
    end
    models_are_equal =compare_models(prelim_model,model);
    % save user provided model and ranova table
    prelim_folder=[output_folder fs 'scouted_model'];
    save_model(prelim_folder,prelim_model,'scouted_model');
    
    save([prelim_folder fs 'ranovatbl.mat'],'ranovatbl')
    save_main_anova_table(ranovatbl, [prelim_folder fs 'ranovatbl.csv'])
    
    
else
    models_are_equal=0;

end

%% Fit the model
disp('Model to be used')
disp(model)

if models_are_equal==0
    rm = fitrm(catT,model,'WithinDesign',BrainFeatures_table);
    ranovatbl = ranova(rm);
end
disp('Model stats')
disp(ranovatbl)
%% Predict corrected responses

YP=predict(rm,catT);

%% Calculate residuals

R=table2array(Y)-YP;

%% Save table
save([output_folder fs 'ranovatbl.mat'],'ranovatbl')
save_main_anova_table(ranovatbl, [output_folder fs 'ranovatbl.csv'])

save_model(output_folder,model,'model');