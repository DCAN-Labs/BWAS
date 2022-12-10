function show_exp_variance_overfitting(V,...
    outcome,...
    pred,...
    output_folder_W_V)
    

[b, IX]=sort(V,'descend');

%%
sorted_pred=pred(:,IX);
cumsum_sorted_pred=cumsum(sorted_pred,2);

% cumsum_sorted_pred=sorted_pred;
rr=corr(outcome,cumsum_sorted_pred);
VV=100*rr.^2;

%%
% subplot 311
% plot(100*V)
% 
% subplot 312
% plot(VV)

% subplot 313
figure
set(gcf,'color','w')
scatter(100*V(IX),VV,'.')
xlabel(['% explained variance of each individual feature'])
ylabel(['% cumulative explained variance'])
box on
yl=ylim;
%%
options.percentile=[0.1000 0.2000 0.5000 1 2 5 10 25 50 100];
n_th=numel(options.percentile)+1;
n_features=numel(V);
up_to=[1 round(n_features*options.percentile/100)];
VV(up_to)

for i=1:n_th
    x=100*V(IX(up_to(i)));
    xline(100*V(IX(up_to(i))))
    if i==1
        local_text=num2str(1);
    else
    local_text=[num2str(options.percentile(i-1)) ' %'];
    end
    text(x,yl(2),local_text,...
        'rotation',90,...
        'HorizontalAlignment','left')
end

%%
ix=[1:n_features]';
T1=table(ix,100*V(IX)',VV');
T1.Properties.VariableNames{1}='index';
T1.Properties.VariableNames{2}='individual_explained_variance';
T1.Properties.VariableNames{3}='cumulative_explained_variance';
T1(1:10,:)
filename='all_features.csv';
writetable(T1,[output_folder_W_V filesep filename])


%%
figure
set(gcf,'color','w')
scatter(VV,100*V(IX),'.')
ylabel(['% explained variance of each individual feature'])
xlabel(['% cumulative explained variance'])
box on
yl=xlim;
for i=1:n_th
    x=100*V(IX(up_to(i)));
    yline(100*V(IX(up_to(i))))
    if i==1
        local_text=num2str(1);
    else
    local_text=[num2str(options.percentile(i-1)) ' %'];
    end
    text(yl(2),x,local_text,...
        'rotation',00,...
        'HorizontalAlignment','left')
end