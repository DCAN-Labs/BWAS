function text_FD_th=make_text_FD_th(handles)

text_FD_th{1}=['FD th: ' num2str(handles.mc.FD_th,'%4.4f')];
text_FD_th{2}=['min time minutes: ' num2str(handles.mc.min_time_minutes,'%4.4f')];
text_FD_th{3}=['min frames: ' num2str(handles.mc.min_frames,'%4.0f')];
text_FD_th{4}=['skip: ' num2str(handles.mc.skip,'%4.0f')];
text_FD_th{5}=['ar terms: ' num2str(handles.connectotyping_settings.n_ar,'%4.0f')];


% text_FD_th{1}=['FD th: ' num2str(handles.mc.FD_th,'%4.4f')];
% text_FD_th{2}=['min time minutes: ' num2str(handles.mc.min_time_minutes,'%4.4f')];
% text_FD_th{3}=['skip: ' num2str(handles.mc.skip,'%4.0f')];
% text_FD_th{4}=['ar terms: ' num2str(handles.connectotyping_settings.n_ar,'%4.0f')];
