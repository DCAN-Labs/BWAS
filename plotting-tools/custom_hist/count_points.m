function [points, traces]=count_points(X)

 if iscell(X)
     [n1,n2]=size(X);
     points=zeros(n1,n2);
     
     for i=1:n1
         for j=1:n2
             points(i,j)=numel(X{i,j});
         end
     end
     traces=n1*n2;
     
 else
     [points,traces]=size(X);
     
 end
 
 %% For debugging/testing
%  X=cell(2,1);X{1}=randn(50000,1); X{2}=rand(10000,1);whos X
%  nn=10000;X=[randn(nn,1) rand(nn,1)];whos X