function [between_design, within_design, M, resorted_T,ix]=local_prep_for_fconn_rm_anovan(T,T_column_names_for_between,T_column_names_for_within,fconn,T_column_names_for_id)
%%

warning('off','all')
%% Look if consecutive_number is provided

header_names='consecutive_number';
IX_header=find_ix_in_header(T,header_names);

if isnan (IX_header)
    consecutive_number=[1:size(T,1)]';
    T=[T table(consecutive_number)];
end

%% Sort table by unique id
try

    ix_id=find_ix_in_header(T,T_column_names_for_id{1});
catch
    ix_id=find_ix_in_header(T,'id');
end
T=sortrows(T,ix_id);
%% Count between and within factors

[between_subgroup_names, between_n_subgroups_per_factor, between_header_ix]=count_subgroups(T,T_column_names_for_between);
[within_subgroup_names, within_n_subgroups_per_factor, within_header_ix]=count_subgroups(T,T_column_names_for_within);
%% Resort by id, within and between

T=sortrows(T,[ within_header_ix(:)'  between_header_ix(:)' ix_id]);
%% Resort table based on within{1} or between{1} if within{1} not available

resorted_T = sort_T_within_between(T,T_column_names_for_within,T_column_names_for_between,T_column_names_for_id);
%% Make between design object

between_design = make_design_object(resorted_T,T_column_names_for_between);
within_design = make_design_object(resorted_T,T_column_names_for_within);



%% Sort matrix as in table



ix=resorted_T.consecutive_number;

[r,c,h]=size(fconn);
try
    if h>1
        M=fconn(:,:,ix);% connectivity matrix
    else
        M=fconn(ix,:);% table with repeated factors
    end
    
catch
    M=[];
end
warning('on','all')