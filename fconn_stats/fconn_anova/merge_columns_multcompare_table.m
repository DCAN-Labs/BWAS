function T=merge_columns_multcompare_table (T_orig,varargin)

%% function T=merge_columns_multcompare_table (T_orig,varargin)
%
% THis function takes as input a table and merge fields
%% Oscar Miranda-Dominguez, first line of code: April 25, 2019

%% Define defaults:

% columns to merge
columns_to_merge=[1 2];

% order matters flag
order_matters_flag=0;

% juncture text
juncture_text=' vs ';
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'columns_to_merge' % path to a file having the size for fonts and subplots
            columns_to_merge=varargin{q+1};
            q = q+1;
            
        case 'order_matters_flag' % path to a file having the size for fonts and subplots
            order_matters_flag=varargin{q+1};
            q = q+1;
            
        case 'juncture_text' % path to a file having the size for fonts and subplots
            juncture_text=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end


%% Calculate table size

[r,c]=size(T_orig);
%% Make the merged column

multicolumn=T_orig(:,columns_to_merge);
unicolumn=merge_columns(multicolumn,juncture_text,order_matters_flag);
%% Create the merged table

T=T_orig;
T(:,columns_to_merge)=[];
T=[unicolumn T];
%% Find unique elements

temp=unicolumn{:,1};
[C,ix] = unique(temp,'rows');
T=T(ix,:);
% cell2table(table2array(T_orig(:,columns_to_merge(1))))
%%






%%

