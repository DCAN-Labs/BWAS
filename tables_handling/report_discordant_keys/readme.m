%% using report_discordant_keys

% Use this function to identify ids in two list
%% Dependencies

% generic_for_functions: https://gitlab.com/Fair_lab/generic_for_functions.git
% tables_handling: https://gitlab.com/Fair_lab/tables_handling.git

%% Example
% Imagine you have 2 lists and you want to know which elements exist in
% both list but also to identify discrepancies

list1={'a','b','c',        'f','g'    };
list2={'a',        'd','e',    'g','h'};

%% Run the function report_discordant_keys to report counts and identify discrepancies
key1=list1;
key2=list2;


[T,exists_in_key1_missing_in_key2,exists_in_key2_missing_in_key1]=report_discordant_keys(key1,key2);

%% Display results
% Table T table show all the unique elements and reports if they exist in list
% 1 and list 2
disp(T)

% Table exists_in_key1_missing_in_key2 i
disp(exists_in_key1_missing_in_key2)


% Table exists_in_key2_missing_in_key1 i
disp(exists_in_key2_missing_in_key1)