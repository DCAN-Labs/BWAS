function show_contributions_using_showM(IX,path_parcellation_table,options, imaging_type, ind, sz,th_names,output_folder)
N=size(IX,1);
parcel=loadParcel(path_parcellation_table);
for i=1:N
    M = table2fconn(IX(i,:),options, imaging_type, ind, sz);
    %     tit=['\fontsize{8}' th_names{i}];
    %     tit{2}='\fontsize{8}(Relative contributions)';
    tit=th_names{i};
    do_show_contributions_using_showM(M,parcel,...
        'tit',tit,...
        'output_folder',output_folder)
end