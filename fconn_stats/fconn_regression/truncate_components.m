function trunctaced_components = truncate_components(cat_components,options)
trunctaced_components=cat_components;

if isfield(options,'scout_up_to')
    scout_up_to=options.scout_up_to;
    n=size(cat_components,1);
    for i=1:n
        trunctaced_components{i}(scout_up_to+1:end)=[];
    end
    
end