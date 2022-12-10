function this_file = filter_file_by_factors(files,local_included_factors)

n_files=numel(files);
n_local_included_factors=numel(local_included_factors);

IX=zeros(n_files,n_local_included_factors);
for i=1:n_files
    for j=1:n_local_included_factors
        IX(i,j)=contains(files{i},local_included_factors{j});
    end
end
IX=prod(IX,2);
IX=find(IX);
this_file=files{IX};