function [reject, accept,th]=get_reject_accept(x_null,outcome)

f_th=0.05;
[f,x] = ecdf(x_null);



switch outcome
    case 'R'
        ix=find(f>=1-f_th,1);
        reject=[x(1) x(ix-1)];
        accept=[x(ix) x(end)];
        
        
    otherwise
        ix=find(f>=f_th,1);
        reject=[x(ix) x(end)];
        accept=[x(1) x(ix-1)];
        
end

th=x(ix);