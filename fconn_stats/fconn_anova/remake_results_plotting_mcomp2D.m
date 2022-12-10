function r=remake_results_plotting_mcomp2D(results,Grp_name,options)

tse=options.bar_lengh_times_standard_error;
foo1=table2cell((results(:,1:3)));


foo1(:,2)=check_categorical(foo1(:,2));
foo1(:,3)=check_categorical(foo1(:,3));

for i=1:3
    try
        foo1(:,i)=cellfun(@cellstr,foo1(:,i));
    end
end
for i=1:2
    Grp_name(:,i)=cellfun(@cellstr,Grp_name(:,i));
end

n_comp=size(results,1);
r=zeros(n_comp,6);
n_sg=size(Grp_name,1);

for i=1:n_sg
    ix1=and(ismember(foo1(:,1),Grp_name(i,1)),ismember(foo1(:,2),Grp_name(i,2)));
    ix2=and(ismember(foo1(:,1),Grp_name(i,1)),ismember(foo1(:,3),Grp_name(i,2)));
    
    r(ix1,1)=i;
    r(ix2,2)=i;
end


m=table2array(results(:,4));
se=table2array(results(:,5));
p=table2array(results(:,6));

r(:,4)=m;
r(:,3)=m-tse*se;
r(:,4)=m+tse*se;
r(:,6)=p;


function Grp_name=check_categorical(Grp_name)
if iscategorical(Grp_name{1})
    Grp_name=cellstr(char([Grp_name{:}]'));
end
