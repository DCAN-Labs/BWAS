function template_file=select_template_from_size(r,cifti_type)

load ('row_column_cifti_table.mat')

ix1=(ismember(row_column_cifti_table.r,r));
ix2=(ismember(row_column_cifti_table.relative_path_from_templates,cifti_type));
ix=find(and(ix1,ix2));
template_file=which(row_column_cifti_table.filename{ix});
