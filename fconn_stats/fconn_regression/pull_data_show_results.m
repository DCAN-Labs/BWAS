function pull_data_show_results(performance,Weights,labels,P)


%% Preallocate memory to save p-values
n_comp=size(P,1);

pk=zeros(n_comp,4);% kolmogorov
pc=zeros(n_comp,4);% cummulative
pf=zeros(n_comp,4);% Fisher

delta=.5;
to_include=[delta 100-delta];

for i=1:n_comp
    for j=1:4
        
        try
            pk(i,j)=P{i}{j}.k;
            pc(i,j)=P{i}{j}.c;
        catch
            pf(i,j)=P{i}{j};     
        end
    end
end
%% get comparisons where median alt <= null and calculate cohen's effect size


flag=ones(n_comp,4);
d=zeros(n_comp,4);
for i=1:n_comp
    
    x1=performance{i}.alt.R;
    x2=performance{i}.null.R;
    d(i,1)=abs(computeCohen_d(x2,x1));
    
    x1=performance{i}.alt.mse;
    x2=performance{i}.null.mse;
    d(i,2)=abs(computeCohen_d(x2,x1));
    if median(x1)>median(x2)
        flag(i,2)=0;
    end
    
    
    x1=performance{i}.alt.mae;
    x2=performance{i}.null.mae;
    d(i,3)=abs(computeCohen_d(x2,x1));
    if median(x1)>median(x2)
        flag(i,3)=0;
    end
    
    x1=performance{i}.alt.mape;
    x2=performance{i}.null.mape;
    d(i,4)=abs(computeCohen_d(x2,x1));
    if median(x1)>median(x2)
        flag(i,4)=0;
    end
    
end
flag=flag==1;

%% corrections for multiple comparisons
pk_corrected=pk;
pc_corrected=pc;
pf_corrected=pf;
for j=1:4
    [h crit_p pk_corrected(:,j)]=fdr_bh(pk(:,j));
    [h crit_p pc_corrected(:,j)]=fdr_bh(pc(:,j));
    [h crit_p pf_corrected(:,j)]=fdr_bh(pf(:,j));
end

%% sort by p_value and cohen

ix_pk=cell(4,1); % pvalue kolmogorov
ix_pc=cell(4,1); % p-value cummulative
ix_pf=cell(4,1); % p-value cummulative
ix_d=cell(4,1); % d-cohen effect size
for i=1:4
    [b ix_pk{i}]=sort(pk(:,i),'ascend');
    [b ix_pc{i}]=sort(pc(:,i),'ascend');
    [b ix_pf{i}]=sort(pf(:,i),'ascend');
    [b ix_d{i}]=sort(d(:,i),'descend');
    
    if i>1
        ix_pk{i}=just_null_gt_alt(ix_pk{i},flag(:,i));
        ix_pc{i}=just_null_gt_alt(ix_pc{i},flag(:,i));
        ix_d{i}=just_null_gt_alt(ix_d{i},flag(:,i));
    end
end

%% Prep for tables

cost_function_name=fieldnames(performance{1}.alt);
make_save_tables(labels,d.*flag,'Cohen_effect_size',cost_function_name);
make_save_tables(labels,pc.*flag,'p_derived_from_cummulative',cost_function_name);
make_save_tables(labels,pk.*flag,'p_derived_from_kolmogorov',cost_function_name);
make_save_tables(labels,pf.*flag,'p_derived_from_fisher',cost_function_name);

make_save_tables(labels,pc_corrected.*flag,'p_derived_from_cummulative_corrected',cost_function_name);
make_save_tables(labels,pk_corrected.*flag,'p_derived_from_kolmogorov_corrected',cost_function_name);
make_save_tables(labels,pf_corrected.*flag,'p_derived_from_fisher_corrected',cost_function_name);
%% Make figures
cohen_intervals_greather_than_values=zeros(6,1);
cohen_intervals_greather_than_names=cell(6,1);
cohen_intervals_greather_than_values(1)=.01;
cohen_intervals_greather_than_values(2)=.2;
cohen_intervals_greather_than_values(3)=.5;
cohen_intervals_greather_than_values(4)=.8;
cohen_intervals_greather_than_values(5)=1.2;
cohen_intervals_greather_than_values(6)=2;

cohen_intervals_greather_than_names{1}='very_small';
cohen_intervals_greather_than_names{2}='small';
cohen_intervals_greather_than_names{3}='medium';
cohen_intervals_greather_than_names{4}='large';
cohen_intervals_greather_than_names{5}='very_large';
cohen_intervals_greather_than_names{6}='huge';


local_dir='cohen';
mkdir(local_dir);
cd (local_dir)

d_expanded=cohen_intervals_greather_than_values;
d_expanded(end+1)=1/0;
for i=1:length(cost_function_name)    
    part1_name=cost_function_name{i};
    for j=1:length(cohen_intervals_greather_than_names)
        part2_name=[cohen_intervals_greather_than_names{j}];
        fig_name=[part1_name '_' num2str(j) '_' part2_name];
        
        fig_name=[  num2str(j) '_' part2_name '_' part1_name];
        
        ix=find(and(d(:,i)>=d_expanded(j),d(:,i)<d_expanded(j+1)));
        ix=ix(ismember(ix,ix_d{i}));
        if length(ix)>0
            plot_cohen(d(ix,i),labels(ix),performance(ix),part1_name,fig_name)
%             plot_cohen_normalized(d(ix,i),labels(ix),performance(ix),part1_name,fig_name)
        end
        
    end
end
figure
foo{1}=randn(100,1);
foo{2}=rand(100,1);
custom_hist(foo)
legend({'null','alt'},...
'fontsize',12)
print(['for_legend'],'-dpng','-r300')
cd ..
%%
function ix=just_null_gt_alt(ix,flag)

[a b]=ismember(ix,find(flag));
ix=ix(a);


