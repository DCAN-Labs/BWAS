function h=plot_simulate_fconn_regression_performance(data,system_pair)


%% Unfold data
ss_d=data(1).x;
d=data(1).y;

ss_alt=data(2).x;
mae_alt=data(2).y;

ss_null=data(3).x;
mae_nul=data(3).y;
%% Remove nans

[ss_d,d]=no_nans(ss_d,d);
[ss_alt,mae_alt]=no_nans(ss_alt,mae_alt);
[ss_null,mae_nul]=no_nans(ss_null,mae_nul);


%%
ss_to_explore=unique(ss_d);
n_ss_to_explore=numel(ss_to_explore);
%% Define figure properties
x=6*n_ss_to_explore/4;%6 cm per each 4 lines
fig_size=[8 1 x 12];
vis_flag='on';
fig_name=strrep( system_pair{1} , ' ' , '_' );
h = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

%% params for tightplot
bs=.08;% vertical space
ts=.09;% top space
ls=.1;% left space
rs=.03;% right space
bh=.3;% between horizontal space
bv=.12;% between vertical space
%%


dotted_line_flag=0;
yl=[-.1 prctile([mae_alt; mae_nul],99.9)];

try
    tightplot(3,1,1,'BottomSpace',bs,...
        'TopSpace',ts,...
        'LeftSpace',ls,...
        'RightSpace',rs,...
        'BetweenH',bh,...
        'BetweenV',bv);
catch
    subplot 311
    display('using subplot instead of tightplot')
end

t_d=table(num2str(ss_d(:)),d(:));
t_d.Properties.VariableNames{2}='Cohen_effect_size';
skinny_plot(t_d,repmat([44,162,95]/255,n_ss_to_explore,1),...
    'dotted_line_flag',dotted_line_flag)
ylabel('d''s effect size')
tit=[system_pair t_d.Properties.VariableNames{2}];
tit=strrep( tit , '_' , ' ' );
title(tit)

try
    tightplot(3,1,2,'BottomSpace',bs,...
        'TopSpace',ts,...
        'LeftSpace',ls,...
        'RightSpace',rs,...
        'BetweenH',bh,...
        'BetweenV',bv);
catch
    subplot 312
    display('using subplot instead of tightplot')
end
t_mae_alt=table(num2str(ss_alt(:)),mae_alt(:));
t_mae_alt.Properties.VariableNames{2}='Alternative_hypothesis';
skinny_plot(t_mae_alt,repmat([.90 .60 .00],n_ss_to_explore,1),...
    'dotted_line_flag',dotted_line_flag,...
    'yl',yl)
ylabel('Absolute error')

try
    tightplot(3,1,3,'BottomSpace',bs,...
        'TopSpace',ts,...
        'LeftSpace',ls,...
        'RightSpace',rs,...
        'BetweenH',bh,...
        'BetweenV',bv);
catch
    subplot 313
    display('using subplot instead of tightplot')
end
t_mae_nul=table(num2str(ss_null(:)),mae_nul(:));
t_mae_nul.Properties.VariableNames{2}='Null_hypothesis_data';
skinny_plot(t_mae_nul,repmat([0 0 0],n_ss_to_explore,1),...
    'dotted_line_flag',dotted_line_flag,...
    'yl',yl)
ylabel('Absolute error')
xlabel('Sample size')

function [a,b]=no_nans(a,b)
ix=~or(isnan(a),isnan(b));
a=a(ix);
b=b(ix);