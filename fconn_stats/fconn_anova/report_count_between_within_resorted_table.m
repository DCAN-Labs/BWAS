function [C,IDs]=report_count_between_within_resorted_table(between_design,within_design,T)

bet_names=cat(1,between_design(1).subgroups.name);
try
wit_names=cat(1,within_design(1).subgroups.name);
catch
    wit_names='na';
end

n_bet=size(bet_names,1);
n_wit=size(wit_names,1);

C=zeros(n_bet,n_wit);
IX=cell(n_bet,n_wit);
IDs=cell(n_bet,n_wit);
for i=1:n_bet
    ix_bet=between_design(1).subgroups(i).ix;
    for j=1:n_wit
        
        try
        ix_wit=within_design(1).subgroups(j).ix;
        catch
            ix_wit=ix_bet;
        end
        
        IX{i,j}=ismember(ix_bet,ix_wit);
        
        C(i,j)=sum(IX{i,j});
        
        
        IX{i,j}=ix_bet(IX{i,j});
        
        IDs{i,j}=T{IX{i,j},1};
    end
end

C=C';
IX=IX';
IDs=IDs';
C=array2table(C);
C.Properties.VariableNames =cellstr(bet_names);
C.Properties.RowNames=cellstr(wit_names);