function N=count_loops(varargin)
n=nargin;
all=zeros(n,1);
for i=1:n
    all(i)=numel(varargin{i});
end
N=prod(all);