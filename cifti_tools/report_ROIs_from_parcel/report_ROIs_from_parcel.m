function T = report_ROIs_from_parcel(parcel,varargin)

%% Oscar Miranda-Dominguez

% This function takes as input an structure parcel and reports their
% content as a table.
%
% It can also take as optional argument a cell with ROI names. If provided,
% this info will be included in the report
%% Define defaults 

ROI_name_flag=0;

%% Read additional arguments

q=1;
v = length(varargin);
while q<=v
    switch lower(varargin{q})
        case 'roi_names'
            ROI_name=varargin{q+1};
            ROI_name_flag=1;
            q = q+1;
            
   
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

% binarize flags
ROI_name_flag=ROI_name_flag==1;

%% Count ROIs and networks
n_systems=size(parcel,2);
N_rois=sum(cat(1,parcel.n));
%% Read ROI_names 
if ROI_name_flag==0
    ROI_name=repmat('unknown',N_rois,1);
end
%% Pre-allocate memory
network_name=cell(N_rois,1);
network_shortname=cell(N_rois,1);
ix=[1:N_rois]';
RGB=nan(N_rois,3);

%% Populate cells
for i=1:n_systems
    local_n=parcel(i).n;
    local_ix=parcel(i).ix;
    for j=1:local_n
        k=local_ix(j);
        network_name{k}=parcel(i).name;
        try
            network_shortname{k}=parcel(i).shortname;
        end
        RGB(k,:)=parcel(i).RGB;
    end
end

color_R=RGB(:,1);
color_G=RGB(:,2);
color_B=RGB(:,3);
%% Make table
T=table(ix, ROI_name,network_name,network_shortname,color_R,color_G,color_B);

