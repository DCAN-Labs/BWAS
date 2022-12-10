function beta=get_weights(main_table,fconn_reg_options,within_headers,system_pair,local_y)

local_tit=system_pair{1};
ix=ismember(table2array(within_headers),local_tit);
ix=find(ix);
local_data=table2array(main_table(:,ix+1));



[Xl,Yl,Xs,Ys,beta] = plsregress(local_data,local_y,fconn_reg_options.components);
