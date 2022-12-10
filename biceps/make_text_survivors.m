function text_survivors=make_text_survivors(handles)
temp=sum(handles.mc.surv_ix,1);

text_survivors{1}=['std: ' num2str(temp(1),'%4.0f')];
text_survivors{2}=['mb: ' num2str(temp(2),'%4.0f')];


