function [this_post_file, this_marg_file] = find_files_to_paired(path_to_save,local_included_factors)
n_factors=size(local_included_factors,2);

%% find posthoc file

depth=0;
string_to_match=['posthoc_' num2str(n_factors) '_factor*_for*'];
post_files=get_path_to_file(path_to_save,depth,string_to_match);
this_post_file = filter_file_by_factors(post_files,local_included_factors);


%% find marginal_means file

depth=0;
string_to_match=['marginal_means_' num2str(n_factors) '_factor*_by*'];
marg_files=get_path_to_file(path_to_save,depth,string_to_match);
this_marg_file = filter_file_by_factors(marg_files,local_included_factors);