function T_column_names = get_variable_design(group_Design_Table,design)

ix=find(ismember(group_Design_Table.Design,design));
T_column_names=group_Design_Table.Variable(ix);