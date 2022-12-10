function leg_n=count_from_categorical(data,sorted_groups)

% second argument for sorting only
if ischar(data)
    data=cellstr(data);
end
unique_data=unique(data);
n_unique_data=numel(unique_data);
leg_n=cell(n_unique_data,1);


for i=1:n_unique_data
    temp=ismember(data,unique_data{i});
    temp=sum(temp);
    leg_n{i}=[unique_data{i} ' (n=' num2str(temp) ')'];   
end

if nargin==2
    new_ix=zeros(n_unique_data,1);
    
    for i=1:n_unique_data
        new_ix(i)=find(ismember(unique_data,sorted_groups(i,:)));
    end
    leg_n=leg_n(new_ix);
    
end
