function make_hist_surv(handles)
figure
clf

mc_method{1}='None';
mc_method{2}='FD';
mc_method{3}='power 2014 FD only';
mc_method{4}='power 2014 motion';
tit2=['MC: ' char(mc_method(find(handles.mc.motions)))];


subplot (5,1,1:4)
f=handles.mc.n_surv_frames;
% n_bins=min(sum(handles.mc.surv_ix),21);
n_bins=21;
up_to=max(f(:));
x_hist=linspace(0,up_to,n_bins);
y(1,:)=histc(f(:,1),x_hist);
y(2,:)=histc(f(:,2),x_hist);

bar(x_hist,y');
line(handles.mc.min_frames*[1 1],get(gca,'ylim'),...
    'color','r',...
    'linewidth',3)
% xlim([0 up_to])
axis tight
legend('std','mb','min frames')
title({'Distribution of frames', tit2})
xlabel('Frames per study')
ylabel({'Abundance','(# of studies)'})

subplot 515
% dummy=char(make_text_FD_th(handles));
% dummy(find(dummy=='_'))=' ';
text(0.,0,char(make_text_FD_th(handles)))

text(.8,0,char(make_text_survivors(handles)))
axis off
