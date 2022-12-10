function parcel = import_parcel_from_csv(path_parcellation_table)


Dictionary_filename=which('dictionary_parcellation_schemas.csv');
[T, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,path_parcellation_table);
parcel=parcel_table2str(T);