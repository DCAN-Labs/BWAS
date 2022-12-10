function make_colorcoded_dlabels_from_parcel(parcel,varargin)


%% Define defaults

preffix='';
suffix = '';
template_label_flag=0;
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
            
        case 'suffix'
            suffix=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

% binarize flags
template_label_flag=template_label_flag==1;


%% Count ROIs and networks
n_systems=size(parcel,2);
n_rois=sum(cat(1,parcel.n));

%% if not provided, guess template_label
if template_label_flag==0
    switch n_rois
        case 333
            template_label=which('Gordon.networks.32k_fs_LR.dlabel.nii');
        case 82
            template_label=which('Bezgin_RM.32k_fs_LR.dlabel.nii');
    end
end
%% Get parcellation name

[path, parcellation_name, ext]=fileparts(template_label);

parcellation_name=strrep(parcellation_name,'.dlabel','');
parcellation_name=strrep(parcellation_name,'.nii','');
parcellation_name=strrep(parcellation_name,'.gz','');
%%
n_scenes=1;
RGB_all=nan(n_rois,3,n_scenes);
for i=1:n_systems
    ix=parcel(i).ix;
    local_n=parcel(i).n;
    local_RGB=parcel(i).RGB;
    RGB=nan(n_rois,3,n_scenes);
    RGB(ix,:)=repmat(local_RGB,local_n,1);
    RGB_all(ix,:)=RGB(ix,:);
    local_filename=[preffix parcel(i).shortname '_' parcellation_name suffix];
    scene.RGB=RGB;
    ciftify_this(scene,local_filename,...
        'template_label',template_label)
end
%%
scene.RGB=RGB_all;
local_filename=[preffix 'ALL_' parcellation_name suffix '_colorcoded'];
ciftify_this(scene,local_filename,template_label,...
        'template_label',template_label)