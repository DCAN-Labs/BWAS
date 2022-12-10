function read_save_dot_fig(path_dot_fig,varargin)

%% Oscar Miranda-Dominguez
%
% First line of code Nov 19, 2019
% This figure opens a dot fig file and saves it on a desired format
% read_save_dot_fig(path_dot_fig,varargin)


% formattype default tif
formattype='tif';

% dpi default 1000
dpi=1000;

% pos_flag
pos_flag=0;

% units_flag
units_flag=0;

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'formattype'
            formattype=varargin{q+1};
            q = q+1;
            
        case 'dpi'
            dpi=varargin{q+1};
            q = q+1;
            
        case 'position'
            pos=varargin{q+1};
            pos_flag=1;
            q = q+1;
            
        case 'units'
            units=varargin{q+1};
            units_flag=1;
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

pos_flag=pos_flag==1;
units_flag=units_flag==1;
%% Assign format type option
switch formattype
    case 'tif'
        formatoption='-dtiffn';
        
    case 'png'
        formatoption='-dpng';
end
%% Assign resolution
res=['-r' num2str(dpi)];
%%
local_file=path_dot_fig;
fs=filesep;

[filepath,name,ext] = fileparts(local_file);

f=openfig(local_file);

% Read position
if pos_flag==0
    pos=f.Position;
else
    f.Position=pos;
end

% Read units
if units_flag==0
    units=f.Units;
else
    f.Units=units;
end

% Preserve paper position and units
f.PaperUnits=units;
f.PaperPosition=pos;


% Save the figure
local_fig_name=[filepath fs name];
f.InvertHardcopy = 'off';
print(local_fig_name,formatoption,res)