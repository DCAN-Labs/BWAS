%% Internal use
%% File used by Oscar to anonymized data

%% Steps
% 1. load table
% 2. read IDs
% 3. identify unique ids
% 4. rename IDs in table
% 5. rename files

%%
path_demographics_Table='C:\Users\oscar\Box\CV\temp\EE_PD_imaging_Predictors_for_matching.csv';
demographics_Table=readtable(path_demographics_Table);

%%
IDs=demographics_Table.subject_id;

%%
% [new unique_new unique_old]=get_old_new_table(old,preffix,suffix)
preffix='fake_ID_';
suffix=[];
[new unique_new unique_old]=get_old_new_table(IDs,preffix,suffix)

%% 
n=size(new,1);
for i=1:n
    demographics_Table.subject_id(i)=new(i);
end

%% 
parcel{1}='HCP';
parcel{2}='Gordon';
root_path='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\parcellated_cortical_thickness';
fs=filesep;
for i=1:n
    for j=1:2 
        old_name=[root_path fs parcel{j} fs unique_old{i} '.corrThickness.' parcel{j} '.subcortical.pscalar.nii'];
        new_name=strrep(old_name,unique_old{i},unique_new{i});
        movefile(old_name,new_name);
    end
end

%%
to_rename.header='scanner_model';
to_rename.old='trio';
to_rename.new='Tr';
 demographics_Table = rename_data (demographics_Table,to_rename)


to_rename.old='Prisma';
to_rename.new='Pr';
 demographics_Table = rename_data (demographics_Table,to_rename)
% 
%% 
path_gordon=cell(n,1);
path_hcp=cell(n,1);

id=demographics_Table.subject_id;
for i=1:n
    j=1;
    path_hcp{i}=   [root_path fs parcel{j} fs id{i} '.corrThickness.' parcel{j} '.subcortical.pscalar.nii'];
    j=2;
    path_gordon{i}=[root_path fs parcel{j} fs id{i} '.corrThickness.' parcel{j} '.subcortical.pscalar.nii'];
    
end

demographics_Table=[demographics_Table table(path_hcp) table(path_gordon)];

%%
header_to_include={'subject_id','path_gordon','path_hcp','Dx','FoG','sex','Age_at_session','scanner_model','MoCA_score','Disease_duration_yrs','MDS_UPDRSIII_score','Delta_DTCgaitspeed'};
IX=find_ix_in_header(demographics_Table,header_to_include)
newT=demographics_Table(:,IX')
%% save file
new_filename='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\demographics_Table.csv';
writetable(newT,new_filename);