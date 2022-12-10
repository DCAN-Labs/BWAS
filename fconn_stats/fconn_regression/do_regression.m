function [performance,W,Y]=do_regression(X,y,ix_in,ix_out,is_null,options)

if is_null==0
    N_rep=options.N;
else
    N_rep=options.N_Null;
end


y_out=zeros(N_rep,options.xval_left_N_out);
yp=y_out;
n_out=size(y,1)-options.xval_left_N_out;
W=zeros(N_rep,size(X,2));
for i=1:N_rep
    X_in=X(ix_in(i,:),:);
    X_out=X(ix_out(i,:),:);
    y_in=y(ix_in(i,:));
    if is_null==1
        y_in=y_in(randi(n_out,[1 n_out]));
    end
    
    y_out(i,:)=y(ix_out(i,:));
    [yp(i,:), W(i,:)]=do_regression_core(X_in,y_in,X_out,options);
end
if N_rep>0
    performance=get_performance(y_out,yp);
end
Y.observed=y_out;
Y.predicted=yp;