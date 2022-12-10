function plot_performance_thin_lines(path_pred_results,functional_system_pair,cost_function)

%%
load(path_pred_results)

%% Define format settings



%% Find index functional system pair
ix=find(ismember(labels,functional_system_pair));

n_ix=size(ix,1);

my_color=[[251,154,153]/255;
    .90 .60 .00];

my_color=[0 0 0
    .90 .60 .00;
    ];

for i=1:n_ix
    local_performance=performance{ix};
    alt=local_performance.alt;
    null=local_performance.null;
    
    alt=getfield(alt,cost_function);
    null=getfield(null,cost_function);
    
    T=make_table(null,alt);
    T.Properties.VariableNames{2}=cost_function;
    
%     skinny_plot(T,my_color)
    skinny_plot_rotated(T,my_color)
    title('')
%     yl=ylim;
%     yl(1)=0;
%     ylim(yl);
%     view(90, 90);
    
    
end

function T = make_table(null,alt)

n_alt=size(alt,1);
n_null=size(null,1);

LABS=[repmat('Alt',n_alt,1) ;repmat('Nul',n_null,1)];
DATA=[alt;null];

T=table(LABS,DATA);
