function [truncated_table truncated_within_headers]=truncate_simulated_main_table(simulated_main_table,within_headers,system_pair)

local_tit=system_pair{1};
ix=ismember(table2array(within_headers),local_tit);
ix=find(ix);

truncated_table=simulated_main_table(:,[1 1+ix']);

truncated_within_headers=within_headers(ix,1);