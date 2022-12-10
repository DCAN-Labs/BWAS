function design_object = make_design_object(resorted_T,column_name)

%%

if ~iscell(column_name)
    if ~isempty(column_name)
        
        column_name=cellstr(column_name);
    end
end

try
    [subgroup_names, n_subgroups_per_factor, header_ix]=count_subgroups(resorted_T,column_name);
    
    n_groups=size(n_subgroups_per_factor,1);
    
    design_object(n_groups).name=[];
    design_object(n_groups).subgroups=[];
    
    
    for i=1:n_groups
        
        design_object(i).name=column_name{i};
        
        clear subgroups
        subgroups(n_subgroups_per_factor(i)).name=[];
        subgroups(n_subgroups_per_factor(i)).ix=[];
        subgroups(n_subgroups_per_factor(i)).color=[];
        
        all_participants=resorted_T{:,header_ix(i)};
        
        my_color = get_my_color(n_subgroups_per_factor(i));
        
        for j=1:n_subgroups_per_factor(i)
            
            subgroups(j).name=subgroup_names{i}(j,:);
            ix_temp=find(ismember(all_participants,subgroup_names{i}(j,:),'rows'));
            subgroups(j).ix=ix_temp';
            
            subgroups(j).color=my_color(j,:);
        end
        design_object(i).subgroups=subgroups;
    end
catch
    design_object=[];
end
