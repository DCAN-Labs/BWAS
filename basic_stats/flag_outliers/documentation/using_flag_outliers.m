%% flag_outliers
%
%% Repo location
%
% This function is contained within basic_stats
% https://gitlab.com/Fair_lab/basic_stats
%% Intro
%
% This function is designed to take a quick look to data that has been
% imported and saved in tifyformat using the function
% import_tidyData_with_Dictionary. Once the data is imported in Matlab as
% table, this function (flag_outliers) will identify outliers using matlab
% built in method to detect them. 
%% Usage
%
%
% THis function takes as input a table (T) and look for outliers adfer grouping
% data using the columns specified by the second argument. OL detection is
% made using Matlab's built-in capabilities

% Input variables
%   T, table with data
%
%   columns_to_group_by, indicates the columns with variables to be used to
%   group the data by
%
%   columns_to_be_tested, indicates the columns with data to be analyzed  columns_to_be_tested, indicates the columns with data to be analyzed

%% Example 1
%
% First load the companion data provided here:
%
load('tidyData.mat')
whos tidyData
%%
% Display the first 10 elements:
tidyData(1:10,:)
%%
% This table will be the first argument to the function.
%
% Now, let's suppose you want to to see if there are outliers for the
% outcomes in the columns 4 to 8 (ie Freq, AMP, Rise_Time, Decay_Time, and
% Area, respectively) after grouping them by the columns 3 and 9 (ie test
% and treatment, respectively). 
%
% Based on this, the vales for columns_to_group_by and columns_to_be_tested
% are
%
columns_to_group_by=[3 9];% ie ie test and treatment, respectively
columns_to_be_tested=4:8;% ie Freq, AMP, Rise_Time, Decay_Time, and AREA, respectively
%%
% Now run the function and show the results
outliers_table = flag_outliers(tidyData,columns_to_group_by,columns_to_be_tested)
%
%% 
% As you can see, the output of the function is a table that only contains
% the variables that look like outliers. The output table has the same
% columns as the input table plus an extra column to indicate which
% outcome (out of the columns_to_be_tested) seems to be outlier
%% Disclaimer
%
% I (Oscar) have tested the function using only 2 columns for
% columns_to_group_by. I have not had the time to test it with 1, 3 or more
% grouping variables (Jan 2019).

%% Post usage recomendations
%
% Always look at the data and determine whether you trust this function or
% not
%% Credits
%
% Code development: Oscar Miranda-Dominguez
%
% First line of code: Jan 2019