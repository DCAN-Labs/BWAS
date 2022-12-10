%% Using importData tools
%
%% Repo location
%
% https://gitlab.com/Fair_lab/text_manipulation
%% Intro
%
% Lack of consistency sharing data might lead to delays on analysis (see
%   Wickham manuscript included here). The function
%   import_tidyData_with_Dictionary aims to simplify the process if a few
%   simple rules are followed. 
%
% import_tidyData_with_Dictionary is a function for Matlab that requires 2
% mandatory csv files:  a dictionary
% (Dictionary_filename) where each row has the variables' description which
% are the headres of the file with data (tidyData_filename). 
%
% This function expects the dictionary to have the following 5 mandatory
% columns:
%
% # Variable_name
% # Variable_type: only allowed values are alphanumeric or numeric
% # Description: Would be nice of you indicate what the variable means
% # Range: Expected range in values (it is fine if you provide no info)
% # Units: Self-descriptive (it is fine if you provide no info)
%
% Data provided in the tidyData_filename must have as headers the variables
% indicaded in the first columns of the Dictionary

%% Usage
%
% You can give it a try using the provided example files and running the
% following commands on your Matlab session:

Dictionary_filename='Dictionary_for_random_data.csv';
tidyData_filename='random_data.csv';
[tidyData, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);

%% Show the size of the outputs (ie, tidyData and Dictionary)
whos tidyData Dictionary

%% Show the content of the dictionary
Dictionary

%% Show the first elements of the actual data
tidyData(1:10,:)

%% More details
%
% As you can see, the file Dictionary_for_random_data has the 5 mandatory
% columns that describe the data that will be imported. The second column of the
% dictionary (Variable_type)is used to format the data contained in
% random_data.csv. This Dictionary also indicates that the data has 8
% variables: 
%
% # SubjectID, 
% # Sex, 
% # test, 
% # Freq, 
% # AMP, 
% # Rise Time, 
% # Decay Time, and 
% # AREA.
% 
% As expected, the file random_data.csv has 8 columns, each corresponding
% to the variables described in the dictionary.
%% Post usage recomendations
%
% Do not forget to double check and compare the content of the outputs
% tidyData and Dictionary with the files random_data.csv and
% Dictionary_for_random_data.csv respectively

%% Credits
%
%
% Developer: Oscar Miranda-Dominguez
%
% First line of code: Jan 24, 2019