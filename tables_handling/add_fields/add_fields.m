function updated_T=add_fields(target_T,from_T,key_names,fields_to_add)

%% Read keys to match
local_ix=find_ix_in_header(target_T,key_names.target_T);
keys_target=target_T{:,local_ix};
keys_target=data_as_cell(keys_target);
updated_T=target_T(:,local_ix);
ix_target=local_ix;

local_ix=find_ix_in_header(from_T,key_names.from_T);
keys_from=from_T{:,local_ix};
keys_from=data_as_cell(keys_from);
ix_from=local_ix;
%% Find columns to add
IX=find_ix_in_header(from_T,fields_to_add);
n_IX=size(IX,1);
%% Find indices in the from_T
n_ix=size(target_T,1);
ix=nan(n_ix,1);
for i=1:n_ix
    try
    ix(i)=find(ismember(keys_from,keys_target{i}));
    end
end
ix(isnan(ix))=[];
to_append=from_T(ix,[local_ix; IX]);
[r,c]=size(to_append);
%% Find potential missing points

ix_in=find(ismember(keys_target,keys_from(ix)));

% [Liam Locb]=ismember(keys_target,keys_from(ix));
% ix_in=(find(Liam));
% ix_in=ix_in(Locb(find(Liam)));
%% Pre-allocate to populate table

% Add field to store key
updated_T{:,2}={''};

% add fields to add numerical or values 
for i=1:n_IX
    switch class(to_append{:,1+i})
        
        case 'double'
            updated_T{:,end+1}=nan;
        case 'cell'
            updated_T{:,end+1}={''};
    end
end

% add names to the columns
for i=2:size(updated_T,2)
    try
    updated_T.Properties.VariableNames{i}=to_append.Properties.VariableNames{i-1};
    catch
        updated_T.Properties.VariableNames{i}=[to_append.Properties.VariableNames{i-1} '_2'];
    end
end
% updated_T(ix_in,2:n_IX+1+1)=to_append

%% Populate key 

for i=1:r
    
    k=ix_in(i);
    
    key_target=target_T{ix_in(i),ix_target};
    if ~iscell(key_target)
        key_target=cellstr(key_target);
    end
    
    key_from=to_append{i,1};
    if ~iscell(key_from)
        key_from=cellstr(key_from);
    end
    
    same_key_flag=strcmp(key_target,key_from);
    
    if same_key_flag
        
        updated_T{k,2}=key_from;
        for j=2:c
            try
            updated_T{k,j+1}=to_append{i,j};
            catch
                updated_T{k,j+1}=str2double(cell2mat(to_append{i,j}));
            end
        end
    else
        error(['mismatch on keys ' key_from{:} ' and ' key_target{:}])
    end
end
%%
% 
% for i=1:r
%     
%     key_target=target_T{ix_in(i),1};
%     if ~iscell(key_target)
%         key_target=cellstr(key_target);
%     end
%     
%     key_from=to_append{i,1};
%     if ~iscell(key_from)
%         key_from=cellstr(key_from);
%     end
%     
%     if strcmp(key_target,key_from)
%         
%         for j=1:c
%             
%             
%             key_from=to_append{i,1};
%             
%             
%             updated_T{ix_in(i),1+j}={to_append{i,j}};
%         end
%         
%     else
%         error(['mismatch on keys ' key_from{:} ' and ' key_target{:}])
%     end
% end
%%
updated_T=[target_T updated_T(:,3:end)];