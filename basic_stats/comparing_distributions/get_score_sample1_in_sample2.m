function score=get_score_sample1_in_sample2(sample1,sample2,varargin)

%% This function calculate how each element in sample 1 is mapped into sample 2. If multiple columns, the approach is repeated per column

[r1, c1]=size(sample1);
[r2, c2]=size(sample2);

if c1~=c2
    error('First two arguments need to have the same number of columns');
else
    c=c1;
end
%% Define and assign default options

% target_options={'mean','fit_gaussian'};
score_options={'diff','prob'};
% target=target_options{1};%
to_score=score_options{1};

%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        %         case 'target'
        %             target=validate_varargin_options(varargin{q+1},target_options,'target');
        %             q = q+1;
        
        case 'to_score'
            to_score=validate_varargin_options(varargin{q+1},score_options,'score');
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Extra validation based on size of sample 2
if r2==1
    to_score=score_options{1};
    display('Sample 2 has only one element, hence to_score changed to to difference')
end
%% DO the work
score=zeros(r1,c,1);
for i=1:c
    standar=get_standar(sample2(:,i),to_score);
    score(:,i)=get_score(sample1(:,i),standar,to_score); 
end
