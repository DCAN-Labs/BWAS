function ciftify_this(scene,file_and_path,varargin)

% Oscar Miranda-Dominguez
% Feb 11, 2016
%% Define defaults


%% Read additional arguments

q=1;
v = length(varargin);
while q<=v
    switch lower(varargin{q})
        case 'template_label'
            template_label=varargin{q+1};
            template_label_flag=1;
            q = q+1;
            
        case 'preffix'
            preffix=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
template_label_flag=template_label_flag==1;

%% Read the filename information
[save_path,filename,ext]=fileparts(file_and_path);
if isempty(save_path)
    save_path=pwd;
end
%% Read path to templates
f=filesep;
temp=which('ciftify_this');
[filepath,name,ext] = fileparts(temp);
path_cifti_templates=[filepath f 'support_files'];
% path_cifti_templates='P:\code\internal\utilities\HCP_Matlab\CIFTIS\support_files';
%% Geat path for wb_command

% Execute script with hardcoded paths
path_list=paths_wb_command;
filename_to_open='path to wb_command';
path_wb_c=validate_path_from_list(path_list,filename_to_open);

% path_wb_c='"C:\Program Files (x86)\workbench\bin_windows64_1_4_0\wb_command.exe"'; %path to wb_command
% % path_wb_c='C:\Program Files (x86)\workbench\bin_windows64_1_4_0\wb_command.exe';
%%
% Detect provided data
names = fieldnames(scene);

if length(names)>1
    error(['Your scenes file has ambiguous information, only one field for scalar, survor RGB needs to be provided'])
end

flag_names{1}='scalar';
flag_names{2}='surv';
flag_names{3}='RGB';


flag_values=zeros(4,1);
flag_values(1)=sum(strcmp(names,'scalar'))>0;
flag_values(2)=sum(strcmp(names,'surv'))>0;
flag_values(3)=sum(strcmp(names,'RGB'))>0;
input_data=char(flag_names(flag_values(:)==1));
%% Validation of appropriate inputs

if sum(flag_values(1:3))~=1
    scene
    error(['Your scenes file has ambiguous information, only one field for scalar, survor RGB needs to be provided'])
end

%% Define filename for saving

switch input_data
    case 'scalar'
        cifti_ext='ptseries.nii';
    case 'surv'
        cifti_ext='dlabel.nii';
    case 'RGB'
        cifti_ext='dlabel.nii';
end

%% Read the data
data=getfield(scene, flag_names{find(flag_values(1:3))});
%%
if flag_values(2)
    foo=unique(data(:));
    if sum(data(:)==0)+sum(data(:)==1)~=numel(data)
        error('surv can only take zeros and ones as input')
    end
    
    [rois, n_scenes]=size(data)
    if rois ~=333
        error(['At this moment, this function can only handle Gordon'])
    end
    scenes(n_scenes).ix=[];
    scenes(n_scenes).RGB=[];
    scenes(n_scenes).alpha=[];
    
    gordon_rois;
    parcel = get_rois_per_network(gordon_network);
    parcel = get_gordon_colors(parcel);
    n_parcel=length(parcel);
    ix_template=zeros(rois,1);
    RGB_template=zeros(rois,3);
    for i=1:n_parcel
        temp_ix=parcel(i).ix;
        RGB_template(temp_ix,:)=repmat(parcel(i).RGB,parcel(i).n,1);
    end
    
    for i=1:n_scenes
        ix=find(data(:,i)==1);
        scenes(i).ix=ix;
        scenes(i).RGB=RGB_template(ix,:);
        scenes(i).alpha=repmat(255,length(ix),1);
    end
    
    % select label mat
    
    load gordon_label.mat
    display(['Saving your file ' file_and_path])
    make_label_file(scenes,file_and_path,gordon_label)
    display(['Done'])
end

%%
if flag_values(3)
    foo=data(:);
    if or(foo<0,foo>1)
        error('RGB values must be bounded between 0 and 1')
    end
    
    RGB=data;
    [rois, colors, n_scenes]=size(RGB)
    if ~ismember(rois,[333 82])
        error(['At this moment, this function can only handle Gordon'])
    end
    scenes(n_scenes).ix=[];
    scenes(n_scenes).RGB=[];
    scenes(n_scenes).alpha=[];
    for i=1:n_scenes
        ix=find(~isnan(RGB(:,1,i)));
        scenes(i).ix=ix;
        scenes(i).RGB=RGB(ix,:,i);
        scenes(i).alpha=repmat(255,length(ix),1);
    end
    
    
    % select label file
    switch rois
        case 333
            load gordon_label.mat
            labs=gordon_label;
            if template_label_flag==0
                template_label=which('Gordon.networks.32k_fs_LR.dlabel.nii');
            end
        case 82
            load Bezginsurfacelabels.mat
            
            [r,c]=size(Bezginsurfacelabels);
            for i=1:r
                for j=1:c
                    if isnan(Bezginsurfacelabels{i,j})
                        Bezginsurfacelabels{i,j}='';
                    end
                    if and(j==5,rem(i,2)==0)
                        Bezginsurfacelabels{i,j}=0;
                    end
                    if isnumeric(Bezginsurfacelabels{i,j})
                        Bezginsurfacelabels{i,j}=num2str(Bezginsurfacelabels{i,j});
                    end
                    
                end
            end
            labs=Bezginsurfacelabels;
            if template_label_flag==0
                template_label=which('Bezgin_RM.32k_fs_LR.dlabel.nii');
            end
    end
    display(['Saving your file ' file_and_path])
    make_label_file(scenes,file_and_path,labs,path_wb_c,template_label)
    display(['Done'])
end
%% Find parcellation based on number of rois
if flag_values(1)
    n_rois=size(data,1);
    switch n_rois
        case 198
            parcellation='LVE_subcortical';
            
        case 186
            parcellation='Markov';
            
        case 205
            parcellation='Markov_subcortical';
            
        case 75
            parcellation='Power';
            
        case 94
            parcellation='Power_subcortical';
            
        case 117
            parcellation='Yeo';
            
        case 136
            parcellation='Yeo_subcortical';
            
        case 333
            parcellation='Gordon';
            
        case 352
            parcellation='Gordon_subcortical';
            label_template=['/group_shares/PSYCH/ROI_sets/Surface_schemes/Human/Gordon/fsLR/Gordon.networks.32k_fs_LR.dlabel.nii'];
            
        case 91282
            parcellation='Atlas_subcortical';
            if strcmp(cifti_ext,'ptseries.nii')
                cifti_ext='dtseries.nii';
            end
            
        case 549
            parcellation='MSC02';
            
        case 568
            parcellation='MSC02_subcortical'
            
    end
    
    if flag_values(1)
        data_type='scalar';
        file_template='/group_shares/PSYCH/code/development/utilities/HCP_Matlab/CIFTIS/cifti_files/Gordon_subcortical.ptseries.nii';
    else
        data_type='label';
    end
    cifti_template=[parcellation '.' cifti_ext];
    %% Read cifti
    % cii_paint=ciftiopen(label_template,path_wb_c);
    display(['Reading cifti template'])
    local_file=which(cifti_template);
    cii=ciftiopen(local_file,path_wb_c);
    newcii=cii;
    X=newcii.cdata;
    %% Replace cifti
    output_file=[filename '.' cifti_ext]; % defining the name of your output file
    display(['Saving your file ' output_file])
    
    newcii.cdata=data;
    ciftisave(newcii,[save_path filesep output_file],path_wb_c); % Making your cifti
    display(['File saved in  ' save_path])
end
