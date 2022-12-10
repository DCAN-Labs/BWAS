function filename=title2filename(tit,varargin)

%% 
%% concatenate multiple rows into a row
filename=strcat(tit{:});


%% Define defaults

% Define string to remove
str_to_remove{1}='';

% str_to_replace_with_underscores
str_to_replace_with_underscores{1}=',';
str_to_replace_with_underscores{2}='.';
str_to_replace_with_underscores{3}=' ';
str_to_replace_with_underscores{4}='(';
str_to_replace_with_underscores{5}=')';
str_to_replace_with_underscores{6}='/';
str_to_replace_with_underscores{7}='\';

% define replace_old_new
replace_old_new=[];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'str_to_remove'
            str_to_remove=varargin{q+1};
            q = q+1;
            
        case 'str_to_replace_with_underscores'
            str_to_replace_with_underscores=varargin{q+1};
            q = q+1;
                   
        case 'replace_old_new'
            replace_old_new=varargin{q+1};
            q = q+1;            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
%% Remove undesired characteres

n_to_remove=numel(str_to_remove);
new='';
for i=1:n_to_remove
    filename=strrep(filename,str_to_remove{i},new);
end
%% Replace spaces with underscores

new='_';
n_to_replace=numel(str_to_replace_with_underscores);
for i=1:n_to_replace
    filename=strrep(filename,str_to_replace_with_underscores{i},new);
end

%%
if ~isempty(replace_old_new)
    n_replace_old_new=size(replace_old_new,1);
    for i=1:n_replace_old_new
        old=replace_old_new{i,1};
        new=replace_old_new{i,2};
        filename=strrep(filename,old,new);
    end
end