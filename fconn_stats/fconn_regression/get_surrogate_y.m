function yp=get_surrogate_y(truncated_table,beta)
% function yp=get_surrogate_y(main_table,fconn_reg_options,within_headers,system_pair)

local_data=truncated_table{:,2:end};
yp=[ones(size(local_data,1),1),local_data]*beta;
