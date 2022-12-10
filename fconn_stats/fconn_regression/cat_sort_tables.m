function cat_t=cat_sort_tables(t1,t2)

n1=size(t1,1);
n2=size(t2,1);
if n1~=n2
    error('Tables must have the same number of rows');
end
n=n1;
%% Rename the networks/labes

lab1=t1{:,1};
lab2=t2{:,1};

for i=1:n
    lab1{i}=rename_networks(lab1{i});
    lab2{i}=rename_networks(lab2{i});
    
end
t1_renamed=t1;
t2_renamed=t2;

t1_renamed(:,1)=lab1;
t2_renamed(:,1)=lab2;
%% Resort the tables

t1_sorted=sortrows(t1_renamed,1);
t2_sorted=sortrows(t2_renamed,1);

lab1=t1_sorted{:,1};
lab2=t2_sorted{:,1};
for i=1:n
    tf=strcmp(lab1{i},lab2{i});
    
    if tf==0
        error('Check names of network-network/labels');
    end
end

%% Concatenate the tables
cat_t=[t1_sorted t2_sorted(:,2:end)];

%%

function str=rename_networks(str)
% str='Doa_and_Doa';
old_pattern='_and_';
new_pattern=' and ';
k=strfind(str,old_pattern);
if ~isempty(k)
    str(k:k+4)=new_pattern;
end

