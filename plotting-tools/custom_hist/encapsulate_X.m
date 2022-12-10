function Xcell=encapsulate_X(X)


if iscell(X)
     [n1,n2]=size(X);
     points=zeros(n1,n2);
     
     for i=1:n1
         for j=1:n2
             points(i,j)=numel(X{i,j});
         end
     end
     traces=n1*n2;
     
     Xcell=cell(traces,1);
     for k=1:traces
         Xcell{k}=X{k};
     end
     
 else
     [points,traces]=size(X);
     Xcell=cell(traces,1);
     for k=1:traces
         Xcell{k}=X(:,k);
     end
     
 end