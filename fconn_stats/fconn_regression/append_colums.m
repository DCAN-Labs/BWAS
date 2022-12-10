function expanded_t=append_colums(t,header,data)

temp_t=table(data);
temp_t.Properties.VariableNames={header};

expanded_t=[t temp_t];