function [performance,W,labels,P,Y]=fconn_regression(main_table, within_headers,y,options)
%% Oscar Miranda-Dominguez
% First line of code: Jan 24, 2018
%% Description
%% This takes as input a table with the NN interactions from a connectivity matrix
%% Read options
[options] = read_options_regression_xval(options);
%% Encapsulate table
NN=unique(table2array(within_headers));
n_NN=length(NN);
X=cell(n_NN,1);
W=cell(n_NN,1);
P=cell(n_NN,1);
Y=cell(n_NN,1);
performance=cell(n_NN,1);

interactions=cell(n_NN,1);
% n=size(y,1);
% [ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions(n,options);


for k=1:n_NN
    local_tit=NN{k};
    ix=ismember(table2array(within_headers),local_tit);
    ix=find(ix);
    local_data=table2array(main_table(:,ix+1));
    X{k}=local_data;
    
    [W{k},P{k},performance{k}, Y{k}]=regression_xval(X{k},y,options);
    
    x1=performance{k}.alt.mae;
    x2=performance{k}.null.mae;
    d=abs(computeCohen_d(x2,x1));
    disp([local_tit ' (' num2str(k) ' out of ' num2str(n_NN) ')']);
    disp(['mean mae for alt: ' num2str(nanmean(performance{k}.alt.mae),'%4.2f'), ', for null: ' num2str(nanmean(performance{k}.null.mae),'%4.2f') ' | d = ' num2str(d,'%4.2f')])
    display('             ');
    
    
end
%% Correct for multiple comparisons
% if options.N_Null>0
%     P=get_P(performance,options);
% end
labels=NN;