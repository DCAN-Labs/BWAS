function [T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(root_path,varargin)
%% [T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(root_path,varargin)
% Oscar Miranda-Dominguez
% First line of code: Aug 31, 2020
%
% Use this function to extract a list of potential subjects with enough
% data for connectivity matrices using the GUI_environments. This function
% by default will look for files with the following extensions and
% text patterns:
% - '*rest*bold*.mat';
% - '*rest*bold*dtseries.nii*';
% - '*rest*bold*HCP*ptseries.nii*';
% - '*rest*bold*ordon*ptseries.nii*';
%% Mandatory input:
% root_path: You need to provide the path to the BIDS folder



%% Example to run
% root_path='C:\Users\oscar\Box\CV\ABCD';
% [T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(root_path)
%% Define and assign default options |

% prefix for filename
preffix=[];
%
depth=2;

% define strings to match
strings_to_match=cell(2,1);
strings_to_match{1}='*rest*.mat';
strings_to_match{2}='*rest*bold*dtseries.nii*';
% strings_to_match{3}='*rest*bold*HCP*ptseries.nii*';
% strings_to_match{4}='*rest*bold*ordon*ptseries.nii*';

extra_strings_to_match=[];
n_extra_strings_to_match=0;

% exclude dt series
exclude_dtseries_flag=0;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'depth'
            depth=varargin{q+1};
            q = q+1;
            
        case 'extra_strings_to_match'
            temp=varargin{q+1};
            if ~iscell(temp)
                temp=cellstr(temp);
            end
            n_extra_strings_to_match=n_extra_strings_to_match+numel(temp);
            extra_strings_to_match=temp(:);
            q = q+1;
            
            case 'preffix'
            preffix=varargin{q+1};
            q = q+1;
            
            case 'exclude_dtseries_flag'
            exclude_dtseries_flag=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
exclude_dtseries_flag=exclude_dtseries_flag==1;
%% Exclude dtsries if asked by the user
if exclude_dtseries_flag
strings_to_match(2)=[];
end
%% Identify func folder


string_to_match='func';
list_func=get_path_to_file(root_path,depth,string_to_match);
n_folders=size(list_func,1);

%% Count strings to match
strings_to_match=cat(1,strings_to_match,extra_strings_to_match);
n_strings_to_match=size(strings_to_match,1);
%% Count
T_count=nan(n_folders,n_strings_to_match);

n_folders=size(list_func,1);
for i=1:n_folders
    local_root_path=list_func{i};
    for j=1:n_strings_to_match
        string_to_match=strings_to_match{j};
        local_list=get_path_to_file(local_root_path,0,string_to_match);
        T_count(i,j)=numel(local_list);
    end
end
to_ix=T_count>0;
to_report=sum(to_ix);
T_count=array2table(T_count);

for j=1:n_strings_to_match
    string_to_match=strings_to_match{j};
    tit=string_to_match(2:end);
    tit=strrep(tit,'*.','_star_');
    tit=strrep(tit,'*','_');
    tit=strrep(tit,'.','_');
    T_count.Properties.VariableNames{j}=tit;
end
list_func=strrep(list_func,[filesep 'func' filesep '.'],[filesep 'func' ]);
T_count=[table(list_func) T_count];
%% Report counts
text_counts=cell(n_strings_to_match,1);
text_counts{1}=['N func = ' num2str(n_folders)];
for i=2:n_strings_to_match+1
    text_counts{i}=['N ' strings_to_match{i-1} ' = ' num2str(to_report(i-1))];
end
%% Report missing
text_missing=cell(n_strings_to_match,1);
for i=1:n_strings_to_match
    text_missing{i}=['N folders with missing ' strings_to_match{i} ' data = ' num2str(n_folders-to_report(i))];
end

%% Export list with the required data

ix_in=sum(to_ix,2)==n_strings_to_match;
list=list_func(ix_in);
list=strrep(list,[filesep 'func' filesep '.'],'');
list=strrep(list,[filesep 'func' filesep],'');
list=strrep(list,[filesep 'func'],'');
% writecell(list,[preffix 'list_N_' num2str(sum(ix_in))])
writecell(list,[preffix 'list'])