function [T,exists_in_key1_missing_in_key2,exists_in_key2_missing_in_key1]=report_discordant_keys(orig_key1,orig_key2)

%% Recast variables
key1=recast_as_cell(orig_key1);
key2=recast_as_cell(orig_key2);

%% concatenate key elements

all=cat(1,key1,key2);
all=unique(all);
%% Find concordant/discortants

exist_in_key1=ismember(all,key1);
exist_in_key2=ismember(all,key2);
%% Make master table

T=table(all,exist_in_key1,exist_in_key2);

%% Report discordants

exists_in_key1_missing_in_key2=exists_missing(T);
exists_in_key2_missing_in_key1=exists_missing(T(:,[1 3 2]));
