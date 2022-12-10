function tall_table=cat_cell_tables(cell_tables)

n=size(cell_tables,1);

tall_table=cell_tables{1};
for i=2:n
    tall_table=[tall_table;cell_tables{i}];
end
