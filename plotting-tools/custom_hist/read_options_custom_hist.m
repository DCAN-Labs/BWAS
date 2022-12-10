function options = read_options_custom_hist(options,points)

%% Assign number of bins
if ~isfield(options,'n_bins') || isempty(options.n_bins)
%     options.n_bins=floor(sqrt(min(points))); % 
    options.n_bins=[]; 
end
options.n_bins=abs(round(options.n_bins));

%% Normalize flag
if ~isfield(options,'normalize') || isempty(options.normalize)
    options.normalize=1; % sort the parcels as presented in the structure parce
end
options.normalize=options.normalize==1;
%% Shown as box or curve
if ~isfield(options,'shown_as') || isempty(options.shown_as)
    options.shown_as='box'; % Making default box    
end
ct{1}='box';
ct{2}='curve';
ct{3}='stairs';
ct{4}='contour';
if sum(ismember(ct,options.shown_as))==0
    display('Available methods are')
    display(ct)
    error(['unknown method: ' options.method,])
end
%% smooth factor | only for curve

if ~isfield(options,'smooth_factor') || isempty(options.smooth_factor)
    options.smooth_factor=0; % No smoothing as default
end
options.smooth_factor=abs(round(options.smooth_factor));

%% color face flag
if ~isfield(options,'color_face_flag') || isempty(options.color_face_flag)
    options.color_face_flag=1; % Making default 1
end
options.color_face_flag=options.color_face_flag==1;

%% alpha
if ~isfield(options,'alpha') || isempty(options.alpha)
    options.alpha=sqrt(2)/2; % Making default
end
if or(options.alpha<0,options.alpha>1)
    error('alpha must be bounded between 0 and 1')
end

%% color LineWidth
if ~isfield(options,'LineWidth') || isempty(options.LineWidth)
    options.LineWidth=1.5; % Making default 1.5
end

%% Read xlim
if ~isfield(options,'xlim') || isempty(options.xlim)
    options.xlim=[]; 
end