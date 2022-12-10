function ciftify_scalar_anovan(main_results,path_wb_c,cifti_scalar_template,hosting_directory)

mkdir (hosting_directory)

var_names=main_results.var_names;
features = fieldnames(main_results);

n_var_names=size(var_names,1);
n_features=size(features,1);
%% Internal variables
f=filesep;
%% read template

display('Reading cifti template')
cii=ciftiopen(cifti_scalar_template,path_wb_c);
newcii=cii;

[pathstr,name,ext] = fileparts(cifti_scalar_template);
temp_name=[name,ext];
%%

for i=1:n_features
    feature=features{i};
    matrix=getfield(main_results, feature);
    if size(matrix,2)==n_var_names
        wd=[hosting_directory f feature];
        mkdir(wd);
        for j=1:n_var_names
            if sum(isnan(matrix(:,j)))~=length(matrix(:,j))
                var_name=var_names{j};
                filename=[wd f feature '_' var_name '.' temp_name]
                newcii.cdata=matrix(:,j);
                display(['Saving ' filename])
                ciftisave(newcii,filename,path_wb_c); % Making your cifti
                
                % save log10 P
                if feature=='P'
                    filename=[wd f 'minus_log10_' feature '_' var_name '.' temp_name]
                    newcii.cdata=-log10(matrix(:,j));
                    display(['Saving ' filename])
                    ciftisave(newcii,filename,path_wb_c); % Making your cifti
                    
                end
                
                
            end
        end
        
    end
end
