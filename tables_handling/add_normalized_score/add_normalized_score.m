function updatedT=add_normalized_score(T,header,normalization)

%% Oscar Miranda Dominguez
%
% This function add a normalized score to an existing table. 
% You need to provide the header in the table to take the raw data
% You also need to provide normalization schema: "Z" or "boxcox"

all_header_names=T.Properties.VariableNames;
ix_in_table=find(ismember(all_header_names,header));

x=T{:,ix_in_table};



switch normalization
    case 'Z'
        
        ix=~isnan(x);
        m=mean(x(ix));
        s=std(x(ix));
        z=(x-m)/s;
        
        preffix='Z_';
        
    case 'boxcox'
        z=boxcox_transform(x);
        
        preffix='boxcox_';
end

foo=table(z);
foo.Properties.VariableNames{1}=[preffix header];

updatedT=[T foo];