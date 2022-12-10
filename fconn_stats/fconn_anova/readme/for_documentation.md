- Inputs (Include links to example files)

    -Mandatory
        -**path_imaging**. Neuroimaging data. Path to neuroimaging data
            - path to a dot mat file where the last dimension corresponds to participant index
            - path to a csv file with imaging data where the number of columns dimension corresponds to participant index (check this with code run for Carla with Cortical thickness). No headers
            - path to a txt file with paths to individual files with neuroimaging data. No headers
                - dot mat
                - cifti
        - **path_demographics_Table**. Path to the demographics table saved as csv. It must have headers. Such headers will be defined as *between* or *within* factors in the group design table (**group_Design_Table**). Depending on the analysis, this table could also have the reserved headers *id* and *outcome*. You could include a column in this table to associate each participant with the its relative position in the neuroimaging data (**path_imaging** ). If provided, the column should be titled "*consecutive_number*". If not provided, it will be assumed that neuroimaging (**path_imaging**) and non-imaging data are presented in the same order.
        - **group_Design_Table** Path to group design table that indicates which elements of the **demographics_Table** will be used in this analysis. This table also will indicate if each included parameters is a *between* or *within* factor. This table must have the following headers in the presented order:
            - Variable: Column names from the **demographics_Table** that will be used in the analysis. Column names listed in the **demographics_Table** but not included here will be ignored
            - Design: Only option are *between* or *within*

    - Optional
        - **parcel**, Parcel object. If not provided it will use defaults
            - dot mat file with assignemnt of ROIs to functional networks
            - table that assigns ROIs to functional networks. The number of ROIs (column ix, see below) must equal the number of elements of the neuroimaging data (i.e. mandatory input **path_imaging**). This table must be saved as a csv file and must have the following headers in the presented order
                - index
                - Network name. Network name each ROI belong to.
                - Newortk short name. Two or three letters' acronym to describe the network this ROI belongs to.
                - R. Number from 0 to 1 to indicate the Red value for the RGB colormap.
                - G. Number from 0 to 1 to indicate the Green value for the RGB colormap.
                - B. Number from 0 to 1 to indicate the Blue value for the RGB colormap.
        - color group design table. If not provided, colors will be assigned 
        - options, an structure with the required fields or a dot m  file with the text to define this structure
        - output_folder. Path to output folder to save the results. If not provided, it will make in the current path a new folder named output_fconn_anovan

run_fconn_anovan(path_imaging,path_demographics_Table,group_Design_Table)

- To do 
    - make a txt file with paths to individual dot mat files with imaging data
        make indiidual dot math diles
    - make a txt file with paths to individual cifti files with imaging data
        - make individual citfi files
    - make a csv file with imaging data
    - Make a folder to save the data

    - When loading demographics table validate if consecutive number is provided or not to match imaging data

    - where did I use fconn_rm_anovan_truncated.m
    - check how I did partial stuff for Martina

