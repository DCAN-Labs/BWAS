function T=local_normalize_scores(Tt,...
    outcome,...
    reference,...
    normalization_method)

%% Find IX DX
IX=find_ix_in_header(Tt,'Diagnosis');
ix_ref=ismember(Tt{:,IX},reference);


%%
IX=find_ix_in_header(Tt,outcome);
n_outcomes=numel(IX);
r=size(Tt,1);

X=nan(r,n_outcomes);
%% Find IX outcome
T=Tt;
for i=1:n_outcomes
    j=IX(i);
    local_data=Tt{:,j};
    raised_local_data=force_ref_higher_than_others(local_data,ix_ref);
    
    switch normalization_method
        
        case 'none'
            y=raised_local_data;
            
        case 'zscore'
            
            y(ix_ref)=nanzscore(raised_local_data(ix_ref));
            i1=raised_local_data(ix_ref);
            i2=y(ix_ref);
            i3=raised_local_data(~ix_ref);
            y(~ix_ref)=project_via_polyfit(i1(:),i2(:),i3(:),2);
            
        case 'boxcox'
            %             y=boxcox_transform(raised_local_data);
            y(ix_ref)=boxcox_transform(raised_local_data(ix_ref));
            i1=raised_local_data(ix_ref);
            i2=y(ix_ref);
            i3=raised_local_data(~ix_ref);
            y(~ix_ref)=project_via_polyfit(i1(:),i2(:),i3(:),2);
    end
    
    
    
    
    X(:,i)=y;
    T{:,j}=y(:);
end
