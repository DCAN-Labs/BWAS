function distance = compare_dist_of_communities(sample1,...
    sample2,...
    cost_function)
%% measure size
[r1,c1]=size(sample1);
[r2,c2]=size(sample2);

if c1==c1
    c=c1;
else
    error(' input data should have the same number fo columns')
end


%% Calculate individual scores
switch cost_function
    case 'kolmogorov_combined'
        [h,p,distance] = kstest2(sample1(:),sample2(:));
        
    case 'kolmogorov_per_score'
        distance=zeros(c,1);
        for i=1:c
            [h,p,distance(i)] = kstest2(sample1(:,i),sample2(:,i));
        end
        
        
    case 'median_diff'
        distance=nanmedian(sample1)-nanmedian(sample2);
%         x=nanmedian(sample1);
%         y=nanmedian(sample2);
%         distance=1-corr(x(:),y(:));
             
end

%% Combine scores

%distance=norm(distance);
distance=sum(abs(distance));