function [performance,W,Y]=do_regression_two_samples(X,y,ix_in,ix_out,is_null,options)

if is_null==0
    N_rep=options.N;
else
    N_rep=options.N_Null;
end


y_out=zeros(N_rep,options.xval_left_N_out);
y_out=repmat([y{2}(:)]',N_rep,1);

% y_out=y{2};
% y_out=y_out(:)';

yp=y_out*0;
% n_out=size(y,1)-options.xval_left_N_out;

n_out=size(y{2},1);

W=zeros(N_rep,size(X{1},2));

X1=X{1};
X2=X{2};
y1=y{1};
y2=y{2};

for i=1:N_rep
    X_in=X1(ix_in(i,:),:);
    X_out=X2;
    y_in=y1;
%     if is_null==1
%         y_in=y_in(randi(n_out,[1 n_out]));
%     end
    
%     y_out(i,:)=y(ix_out(i,:));
    [yp(i,:), W(i,:)]=do_regression_core(X_in,y_in,X_out,options);
end
if N_rep>0
    performance=get_performance_two_samples(y_out,yp);
end
Y.observed=y_out;
Y.predicted=yp;