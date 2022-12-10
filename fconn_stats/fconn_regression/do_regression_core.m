function [yp,W]=do_regression_core(X_in,y_in,X_out,options)


n_components = options.components;

switch options.method
    case 'plsr'
        [Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X_in,y_in,n_components);
        W=beta(2:end);
        yp=[ones(size(X_out,1),1),X_out]*beta;
    case 'tsvd'
        [U, S, V]=svd(X_in,'econ');
        x_inv=zeros(size(X_in'));
        for l=1:n_components
            x_inv=x_inv+V(:,l)*(1/S(l,l))*U(:,l)';
        end
        W=x_inv*y_in;
        yp=X_out*W;
    
end