function [filteredT,T] = summarize_cat_results(cat_results_full_path,varargin)

%%
Dictionary_filename=which('dictionary_cat_results.csv');

%% Read cat results

tidyData_filename=cat_results_full_path;
T = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);
VarNames=T.Properties.VariableNames;

comp_column=find(ismember(VarNames,'n_comp'));
trans_column=find(ismember(VarNames,'transformed_outcome'));
%% Define default values and options

% cost
cost='mean_square_error';
menu_cost{1}='mean_square_error';
menu_cost{2}='mean_absolute_error';

% n_comp
all_comp=T{:,comp_column};
menu_comp=all_comp;
n_comp=round(min(unique(all_comp)));

% min d
min_d=0.5;


% transformed_outcome
all_transformed_outcome=T{:,trans_column};
menu_transformed_outcome=all_transformed_outcome;
transformed_outcome=round(max(unique(all_transformed_outcome)));

%%

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'cost'
            cost=varargin{q+1};
            cost=validate_varargin_options(cost,menu_cost,'cost');
            q = q+1;
            
        case 'n_comp'
            n_comp=varargin{q+1};
            n_comp=validate_varargin_options(n_comp,menu_comp,'n_comp');
            q = q+1;
            
        case 'transformed_outcome'
            transformed_outcome=varargin{q+1};
            transformed_outcome=validate_varargin_options(transformed_outcome,menu_transformed_outcome,'transformed_outcome');
            q = q+1;
            
            
        case 'min_d'
            min_d=varargin{q+1};
            q = q+1;
            
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
cost_column=find(ismember(VarNames,cost));
%% FIlter table
errValues=T{:,cost_column};
ix_err=errValues>=min_d;

comp=T{:,comp_column};
ix_comp=comp==n_comp;

trans=T{:,trans_column};
ix_trans=trans==transformed_outcome;

ix=and(ix_err,ix_comp);
ix=and(ix,ix_trans);

filteredT=T(ix,[1 comp_column trans_column cost_column]);
filteredT=T(ix,[1 2 3 comp_column trans_column cost_column]);
filteredT=sortrows(filteredT,size(filteredT,2),'descend');
if ~isempty(filteredT)
    %% Rename data
    
    old_header={'mean_absolute_error'};
    new_header={'cohen_d_MAE'};
    filteredT=rename_table_header(filteredT,old_header,new_header);
    
    old_header={'mean_square_error'};
    new_header={'cohen_d_MSE'};
    filteredT=rename_table_header(filteredT,old_header,new_header);
    
    %%
    transformed_outcome=filteredT.transformed_outcome;
    
    switch unique(transformed_outcome)
        case 0
            new_name='no_transformation';
            
        case 1
            new_name='z score';
            
        case 2
            new_name='boxcox';
    end
    ix_to_kill=find(ismember(filteredT.Properties.VariableNames,'transformed_outcome'));
    filteredT(:,ix_to_kill)=[];
    %%
    
    t_outcome=table(repmat({new_name},size(filteredT,1),1));
    
    filteredT=[filteredT t_outcome];
    filteredT.Properties.VariableNames{end}='transformed_outcome';
%     filteredT=filteredT(:,[1 4 2 3]);
    filteredT=filteredT(:,[1 6 4 2 3 5]);
end