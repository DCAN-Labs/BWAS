function [tidyData, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);


% This function imports data given 2 csv files, a dictionary
% (Dictionary_filename) where each row has the variables' description which
% are the headres of the file with data (tidyData_filename). 

% This function expects the dictionary to have the following mandatory
% columns:
%
% 1) Variable_name
% 2) Variable_type: only allowed values are alphanumeric or numeric
% 3) Description: WOuld be nice of you indicate what the variable means
% 4) Range: Expected range in values (it is fine if you provide no info)
% 5) Units: Self-descriptive (it is fine if you provide no info)
%
% Data provided in the tidyData_filename must have as headers the variables
% indicaded in the first columns of the Dictionary

%
% Oscar Miranda-Dominguez | Jan 24. 2019

Dictionary = importDictionary(Dictionary_filename);
tidyData = import_tidyData(Dictionary,tidyData_filename);