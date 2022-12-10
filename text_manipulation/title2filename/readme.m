%% title2filename
%
% Use this function to replace characters used in a title to make a
% filename
%
%% Using defaults
%
%
% Using defaults the function relaces the characters ',', '.', ' ', '(',
% and ')' with '_'
tit{1}='EF-ADHD symptom score: BWAS in ABCD, PNRS in OHSU';
tit{2}='\fontsize{9}(Gordon, pre-whithening)';
tit{3}='_R_';
tit{4}='All';
filename=title2filename(tit)
%
%% Providing str_to_remove

str_to_remove{1}='\fontsize{9}';
str_to_remove{2}='{';
str_to_remove{3}='}';
str_to_remove{4}='(';
str_to_remove{5}=')';
str_to_remove{6}=':';
filename=title2filename(tit,...
    'str_to_remove',str_to_remove)

%% Providing replace_old_new
replace_old_new{1,1}='__';
replace_old_new{1,2}='_';
replace_old_new{2,1}='Gordon';
replace_old_new{2,2}='_Gordon';
filename=title2filename(tit,...
    'str_to_remove',str_to_remove,...
    'replace_old_new',replace_old_new)