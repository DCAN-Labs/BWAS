function [X, labels]=get_fconn_labels(main_table, within_headers)
%% Encapsulate table
NN=unique(table2array(within_headers));
n_NN=length(NN);
X=cell(n_NN,1);


for k=1:n_NN
    local_tit=NN{k};
    ix=ismember(table2array(within_headers),local_tit);
    ix=find(ix);
    local_data=table2array(main_table(:,ix+1));
    X{k}=local_data;
    display(['Run ' num2str(k) ' out of ' num2str(n_NN)]);
    
    
end
%% Correct for multiple comparisons
% if options.N_Null>0
%     P=get_P(performance,options);
% end
labels=NN;