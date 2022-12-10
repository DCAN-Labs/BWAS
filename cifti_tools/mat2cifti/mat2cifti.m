function mat2cifti(M,filename,template_file)

%%

if nargin<3
    template_file=[];
end
%% Get path to wb_command
handles=[];
handles = validate_path_wb_command(handles);
path_wb_command=handles.paths.wb_command;

%%
[r,c]=size(M);

%% Select template

if isempty(template_file)
    
    if contains(filename,'tseries')
        cifti_type='xtseries';
    end
    
    if contains(filename,'conn')
        cifti_type='xconn';
    end
    template_file=select_template_from_size(r,cifti_type);
end
%% Read template
cii=ciftiopen(template_file,path_wb_command);
newcii=cii;
%% Save cifti
display(['Saving your file ' filename])

newcii.cdata=M;
ciftisave(newcii,filename,path_wb_command); % Making your cifti
display(['Done'])