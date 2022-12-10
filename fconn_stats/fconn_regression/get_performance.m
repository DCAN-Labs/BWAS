function performance=get_performance(y_out,yp)

% R=diag(corr(y_out',yp'));
R=corr(y_out(:),yp(:));% change introduced on Sep 17. 2018 


mse=nanmean((y_out-yp).^2,2);
mae=nanmean(abs(y_out-yp),2);
mape=nanmean(100*abs((y_out-yp)./y_out),2);



performance.R=R;
performance.mse=mse;
performance.mae=mae;
performance.mape=mape;