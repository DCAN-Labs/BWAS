function filename_censored_data = make_filename_censored_data(handles)

ix=find(handles.mc.motions);
mc_method=char(handles.mc.methods{ix});
fd=num2str(handles.mc.FD_th,'%4.2f');
fd(fd=='.')='_';

min_frames=num2str(handles.mc.min_frames);
skip=num2str(handles.mc.skip);
tr=num2str(handles.mc.TR,'%4.2f');
tr(tr=='.')='_';
if handles.mc.motions(1)
    filename_censored_data=[handles.env.original_filename,...
    '_MCMethod_' mc_method,...
    '_min_frames_',min_frames,...
    '_skip_frames_',skip,...
    '_TRseconds_',tr];
else
    filename_censored_data=[handles.env.original_filename,...
    '_MCMethod_' mc_method,...
    '_FD_th_', fd, ...
    '_min_frames_',min_frames,...
    '_skip_frames_',skip,...
    '_TRseconds_',tr];
end

