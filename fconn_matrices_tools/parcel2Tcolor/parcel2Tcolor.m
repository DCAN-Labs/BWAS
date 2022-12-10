function Tcolor = parcel2Tcolor(path_parcellation_table,ispconn)

%% Oscar Miranda-Dominguez
% First line of code: Nov 27, 2021

%% Tcol = parcel2Tcolor(parcel,ispconn)
% Use this funciton to get a Table with colors:

% Example 1:
% ispconn=0;
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Gordon_subcortical.mat';
% Tcol = parcel2Tcolor(path_parcellation_table,ispconn)

%% Example 2
% ispconn=1;
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Gordon_subcortical.mat';
% Tcol = parcel2Tcolor(path_parcellation_table,ispconn)

%% Example 3 | Same as Example 2

% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Gordon_subcortical.mat';
% Tcol = parcel2Tcolor(path_parcellation_table)
%% Define defaults

fs = filesep;


% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];



%%
if nargin<2
    ispconn=1;
end
ispconn=ispconn==1;
%% Load parcel
parcel=loadParcel(path_parcellation_table);
%% count ROIs
n=sum(cat(1,parcel.n));

%% Make fake data to reuse code
fconn=randn(n);

F=fconn;
if ispconn
    F=cat(3,fconn,fconn);
end
%%
[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(F,options);

%%
if strcmp (imaging_type,'3D')
    parcel = network_network_as_parcel(parcel,imaging_type,ind,options);
end
%% Convert to color table

T = struct2table( parcel );
headers={'shortname','RGB'};
IX=find_ix_in_header(T,headers);
Tcolor=T(:,IX)