function [Xscores,labels,PCTVAR,Features,BETA]=get_first_component_fconn_regression(main_table, within_headers,y,options)
%% Oscar Miranda-Dominguez
% First line of code: April 4, 2019
%% Description
%% This takes as input a table with the NN interactions from a connectivity matrix
%% Read options
[options] = read_options_regression_xval(options);
%% Encapsulate table
NN=unique(table2array(within_headers));
n_NN=length(NN);
X=cell(n_NN,1);
Xscores=cell(n_NN,1);
PCTVAR=cell(n_NN,1);
BETA=cell(n_NN,1);

interactions=cell(n_NN,1);
% n=size(y,1);
% [ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions(n,options);


for k=1:n_NN
    local_tit=NN{k};
    ix=ismember(table2array(within_headers),local_tit);
    ix=find(ix);
    local_data=table2array(main_table(:,ix+1));
    X{k}=local_data;
    display(['Run ' num2str(k) ' out of ' num2str(n_NN)]);
    [Xloadings,Yloadings,Xscores{k},YS,BETA{k},PCTVAR{k}] = plsregress(X{k},y,options.components);
    
    
end
%% Correct for multiple comparisons
% if options.N_Null>0
%     P=get_P(performance,options);
% end
labels=NN;
Features=X;