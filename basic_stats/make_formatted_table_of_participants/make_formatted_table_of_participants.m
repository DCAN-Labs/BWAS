function summarized_paired_comparisons=make_formatted_table_of_participants (T, columns_with_basic_info,filename,varargin)

% columns_with_basic_info.group='recoded_FOG';
% columns_with_basic_info.to_compare={'Age_at_session','MoCA_score'};
% 
% columns_additional_info.sex='sex';
warning('off','all');
VariableNames=T.Properties.VariableNames;
%% Define and assign default options |
test_2_samples='t';


%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'test_2_samples'
            test_2_samples=varargin{q+1};  
            q = q+1;
            
        
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Read univariate statistics
tidyData=T;
%% Find column_to_group_by
column_to_group_by=find(ismember(VariableNames,columns_with_basic_info.group));
%% Find columns_to_be_matched

n_to_show=size(columns_with_basic_info.to_compare,2);
columns_to_be_matched=find(ismember(VariableNames,columns_with_basic_info.to_compare));

%% Count participants and get univariate stats


matched_participants=[];

univariate_table=univariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched);

%% Get paired comparisons

summarized_paired_comparisons=summarize_paired_comparisons(tidyData,matched_participants,column_to_group_by,columns_to_be_matched,test_2_samples);

writetable(summarized_paired_comparisons,filename,...
    'WriteRowNames',1)
warning('on','all');