function alternative_path_variances=ask_for_alternative_path_variance(has_variance_flag)

alternative_path_variances=pwd;
if sum(has_variance_flag)<numel(has_variance_flag)
    title='Some variance files might not exist in the derivatives folder. If existing, provide an alternative path to look for variance files';
    display(title);
    alternative_path_variances = uigetdir([],title);
end