Files taken from the Human Connectome mailing list:
https://www.mail-archive.com/hcp-users%40humanconnectome.org/msg00623.html
Re: [HCP-Users] Converting/analysing preprocessed rfMRI grayordinates
Glasser, Matthew Tue, 09 Sep 2014 12:50:01 -0700
____________________________________________________
I¹d recommend option ii.

You can use the surfaces and label data in the
${StudyFolder}/${SubjectID}/MNINonLinear/fsaverage_LR32k folder together
with the dense timeseries data.  To load the data into matlab, you can use
these attached matlab functions together with wb_command and the matlab
GIFTI toolbox:

cii = ciftiopen(Œpath/to/file¹,¹path/to/wb_command¹);

CIFTIdata = cii.cdata;


Some lines of analysis code

newcii = cii;

newcii.cdata = AnalysisOutput;

ciftisave(newcii,¹path/to/newfile¹,¹path/to/wb_command¹);

Or if the data matrix is a different size from what you started with

ciftisavereset(newcii,¹path/to/newfile¹,¹path/to/wb_command¹);

And then you can view your result in Connectome Workbench¹s wb_view on the
32k standard surfaces.

Peace,