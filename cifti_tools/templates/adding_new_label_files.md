# Adding new label files

Label files are used to parcellate dense time series. Corresponding time series are also used to calculate connectivity matrices.

To integrate a new label file into the workflows of fconn_stats, polyneuro risk scores and other analytic tools, the following steps are needed:

1. Save the required label file
1. Define a conforming name
1. Save the label file and corresponding ptseries and pconn in the folder templates
1. Add templates to the table...
1. Make a network assignment table and save it in fconn_matrices_tools

## Save the required label file

Make a folder and clone the new label file. 

## Define a conforming name

If needed, modify the label file name to something more compact and descriptive. For example the label file `Gordon.subcortical.32k_fs_LR.dlabel.nii` has `Gordon`, the parcellation schema name as preffix followed by `.subcortical` to indicate that also includes 19 subcortical ROIs from freesurfer. `.32k_fs_LR` is used to indicate that is in the standard grayordinate space (~32k vertices per hemisphere, freesurfer, left and right hemisphere). 

## Save the label file and corresponding ptseries and pconn in the folder templates

Save the label file in `~\cifti_tools\templates\label_files\human\`
Make a parcellated timeseries and a parcellated pconn and save those files in the corresponding folders:
- ptseries: `~\cifti_tools\templates\xconn`
- pconn: `~\cifti_tools\templates\xtseries`

This can be done with the function `add_ptseries_pconn_from_label`. This function calculates the `ptseries` and `pconn` files and automatically figures out where to save them. 

This example shows how to run it:

```
path_label_file='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\label_files\human\HCP_ColeAnticevic_wSubcorGSR.dlabel.nii';
[ptseries, pconn]=add_ptseries_pconn_from_label(path_label_file)
```

## Add templates to the table

Update the table that contains 
To do this, just execute this command in Matlab:
```
update_row_column_cifti_table
```
## Make a network assignment table and save it in fconn_matrices_tools

This is a semi-automated process. First you need to read the label file (automated part), and then you need to make a parcel schema file making the assignment of each ROI to a given network. 


1. Make a folder in `~\matlab_code\fconn_matrices_tools` with the name of the parcellation schema you will use.
2. In this folder make a matlab script to read the label file as a table to identify ROIs and colors. Use this example code to read label file and save the content as a csv:

```
%% add paths
addpath(genpath('C:\Users\oscar\OneDrive\matlab_code'));

%%
wd='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\MiDB_ProbabilisticParcellation';
%%
fs=filesep;

%% PAth to label file

path_dlabel=[wd fs 'MiDB_ProbabilisticParcellation.dlabel.nii'];

%% This section reads the label file and save ROIs as text file

tidyTable_filename=[pwd fs 'MiDB_ProbabilisticParcellation_temp'];
tidyTable=dlabel_to_tidyTable(path_dlabel,tidyTable_filename);
```
3. Use the previous table to make a table with the final network assignment. This network assignment should be a table where the number of ROIs (column ix, see below) must equal the number of elements of the neuroimaging data. This table must have the following headers in the presented order:

- index
- Network name. Network name each ROI belong to.
- Newortk short name. Two or three letters' acronym to describe the network this ROI belongs to.
- R. Number from 0 to 1 to indicate the Red value for the RGB colormap.
- G. Number from 0 to 1 to indicate the Green value for the RGB colormap.
- B. Number from 0 to 1 to indicate the Blue value for the RGB colormap.

4. Once calculated, save the table as a dot mat and a dot csv file. Here is an example:
```
%% Read the final assignment
% tidyTable_filename was used by Anjani to make the corresponding
% HCP_ColeAnticevic_wSubcorGSR.csv
path_parcellation_table=[wd fs 'HCP_ColeAnticevic_wSubcorGSR.csv'];
parcel=loadParcel(path_parcellation_table);

save('HCP_ColeAnticevic_wSubcorGSR.mat','parcel')
```
5. Copy the csv and the dot mat file in the folder `~fconn_matrices_tools\parcel_schemas\`




