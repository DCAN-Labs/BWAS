function p=get_P(performance,options)

outcomes=fieldnames(performance.alt);
n_outcomes=length(outcomes);
p=cell(n_outcomes,1);

for i=1:n_outcomes
    x_alt=getfield(performance.alt,outcomes{i});
    x_null=getfield(performance.null,outcomes{i});
    try
        p{i}=get_P_core(x_alt,x_null);
    end
    
    %change added on Sept 17, 2018
    %http://core.ecu.edu/psyc/wuenschk/docs30/CompareCorrCoeff.pdf
    if and(numel(x_alt)==1,numel(x_null)==1)
        r1=atanh(x_alt);
        r2=atanh(x_null);
        
        n1=options.N;
        n2=options.N_Null;
        
        Z=(r1-r2)/(sqrt((1/(n1-3))+(1/(n2-3))));
        p{i}=1-normcdf(Z);
        
    end
end
