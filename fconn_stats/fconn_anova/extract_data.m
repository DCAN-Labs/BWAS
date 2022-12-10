function [factor_matrices,fieldnames,subs_per_matrix] = extract_data(mat_directory);
mat_directory='/group_shares/FAIR_LAB2/Projects/Lutein-MacaqueInfant-OHSU/matlab_code/GenerateAnovaTable/matrices';


stuff = dir(strcat(mat_directory,'/*.mat'));
nfields = max(size(strfind(stuff(1).name,'_'))) + 1;
nfiles = max(size(stuff));
fieldnames = cell(nfiles,nfields);
%use underscores within filenames to identify the different types of
%fields
for i = 1:nfiles
    for j = 1:nfields
        file_fields = strfind(stuff(i).name,'_');
        file_limit = strfind(stuff(i).name,'.');
        if j ~= nfields
            if j == 1
                fieldnames{i,j} = stuff(i).name(1:file_fields(j)-1);
            else
                fieldnames{i,j} = stuff(i).name(file_fields(j-1)+1:file_fields(j)-1);
            end
        else
            fieldnames{i,j} = stuff(i).name(file_fields(j-1)+1:file_limit-1);
        end
    end
end

number_of_factors = 0;
for i = 1:nfields
    if max(size(unique(fieldnames(:,i)))) > 1
        number_of_factors = number_of_factors + 1;
        new_fieldnames(:,number_of_factors) = fieldnames(:,i);
        factor_levels(number_of_factors) = max(size(unique(fieldnames(:,i))));
        factor_names{number_of_factors} = unique(fieldnames(:,i));
    end
end
fieldnames = new_fieldnames;

factor_matrices = cell(nfiles,1);
subs_per_matrix = zeros(nfiles,1);
for i = 1:nfiles
    factor_matrices{i} = cell2mat(struct2cell(load(strcat(mat_directory,'/',stuff(i).name))));
    subs_per_matrix(i) = size(factor_matrices{i},3);
end
