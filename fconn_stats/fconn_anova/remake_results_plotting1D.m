function r=remake_results_plotting1D(results,options)

% tse=1.96;
tse=options.bar_lengh_times_standard_error;
foo=table2cell(unique(results(:,1),'stable'));

n=size(foo,1);
n_comp=n*(n-1)/2;
r=zeros(n_comp,6);

t1=table2cell(results(:,1));
t2=table2cell(results(:,2));

t1=check_categorical(t1);
t2=check_categorical(t2);
foo=check_categorical(foo);

% try
%    t1=cellstr(char([t1]'));
%    t2=cellstr(char([t2]'));
%    foo=cellstr(char([foo]'));
% end

k=0;


for i=1:n-1
    for j=i+1:n
        k=k+1;
        local_ix=and(ismember(t1,foo{i}),ismember(t2,foo{j}));
        r(k,1)=i;
        r(k,2)=j;
        r(k,4)=table2array(results(local_ix,3));
        se=table2array(results(local_ix,4));
        r(k,3)=r(k,4)-tse*se;
        r(k,5)=r(k,4)+tse*se;
        r(k,6)=table2array(results(local_ix,5));
        
    end
end
    
function Grp_name=check_categorical(Grp_name)
if iscategorical(Grp_name{1})
    Grp_name=cellstr(char([Grp_name{:}]'));
end
