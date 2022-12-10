function M = load_dot_mat_imaging(path_imaging_dot_mat)

M=load(path_imaging_dot_mat);
fields = fieldnames(M);

if numel(fields)>1
    error('dot mat file with path_imaging  has more than one variable')
end
M=M.(fields{1});