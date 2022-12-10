function p=get_P_two_samples(performance,options)

outcomes=fieldnames(performance.alt);
n_outcomes=length(outcomes);
p=cell(n_outcomes,1);

for i=1:n_outcomes
    x_alt=getfield(performance.alt,outcomes{i});
    x_null=getfield(performance.null,outcomes{i});
    try
        p{i}=get_P_core_two_samples(x_alt,x_null,outcomes{i});
    end
    
  
end
