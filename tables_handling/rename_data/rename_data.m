function updated_T = rename_data (T,to_rename)
% 
% clear updated_T
% 
% to_rename.header='Dx';
% to_rename.old='Control';
% to_rename.new='Ct';
% 
% to_rename.header='Dx';
% to_rename.old='FGD';
% to_rename.new='XX';
% 
% to_rename.header='Dx';
% to_rename.old='MCI';
% to_rename.new='YY';
% 
% T=tidyData;
% 
% 
% updated_T = rename_data (T,to_rename)
%% updated_T = rename_data (T,to_rename)
%
% This function rename values within a table. You need to provide the table
% and the values to be renamed
%
%
% Inputs:
%   T: Table with the data
%
%   to_rename: an structure with 3 fields: 
%   to_rename.header: the header or name of the column to be targeted
%   to_rename.old: the name of the value to be replaced
%   to_rename.new: the name of the value to be replaced with
%% Oscar Miranda-Dominguez
% First line of code Dec 3, 2019

%% This function 

n_fields=size(to_rename,2);
%% Find ix in table

ix_in_table=zeros(n_fields,1);

all_header_names=T.Properties.VariableNames;


for i=1:n_fields
    ix_in_table(i)=find(ismember(all_header_names,to_rename(i).header));
    
    local_ix_in_table=ix_in_table;
     
    
    local_data=cellstr(T{:,local_ix_in_table});
    old=to_rename(i).old;
    new=to_rename(i).new;
    
    
    local_ix=find(ismember(local_data,old));
    local_data(local_ix)={new};
    tempT=table(char(local_data));
    tempT.Properties.VariableNames{1}=to_rename(i).header;
    
    updated_T=[T(:,1:local_ix_in_table-1) tempT T(:,local_ix_in_table+1:end)];
    
    
  
end

