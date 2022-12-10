function T = split_mixed_within_names(t_posthoc,wit_factors)

%%
orig_name=t_posthoc.Properties.VariableNames{1};

%% split names
data=t_posthoc{:,1};
newStr = split( data );
%% Make the new 2 column names
G1=join(newStr(:,1:end-1),' ');
G2=newStr(:,end);

T=table(G1,G2);
T.Properties.VariableNames{1}=wit_factors{1};
T.Properties.VariableNames{2}=wit_factors{2};
%% Concatenate the other data

T=[T t_posthoc(:,2:end)];

%% Resort columns

T=[T(:,1:end-4) T(:,end-1:end) T(:,end-3:end-2)];
