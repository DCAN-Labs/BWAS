function T = add_group_mean_values(local_T,T_marg)

%%
vars=local_T.Properties.VariableNames;
%% find suffix
suffix=vars{end}(end-1:end);
%% FInd header names matching the values in vars
old=suffix;
new='';
newStr=vars;

newStr = strrep( newStr , old , new );

IX=find_ix_in_header(T_marg,newStr);

%%

data_to_extract_T_marg={'Mean','StdErr','Lower','Upper'};
ix_to_extract_T_marg=find_ix_in_header(T_marg,data_to_extract_T_marg);


n=size(local_T,1);
X=nan(n,4);

text_marg_mean=join(T_marg{:,IX},2);
for i=1:n
    text_post_hoc=join(local_T{i,:});
    ix=find(ismember(text_marg_mean,text_post_hoc));
    X(i,:)=T_marg{ix,ix_to_extract_T_marg};
end

X_table=array2table(X);
X_table.Properties.VariableNames=append(data_to_extract_T_marg,suffix);

%% Concatenate the table
if size(local_T,2)>1
    T=[local_T(:,end-1:end) X_table];
else
    T=[local_T X_table];
end
% T= X_table;