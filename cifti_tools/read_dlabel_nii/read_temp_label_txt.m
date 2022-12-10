function T = read_temp_label_txt(temp_label_txt)

%% Oscar Miranda-Dominguez
% This function reads txt files made by -cifti-label-export-table

formatSpec = '%s %s %s %s %s\n';
formatSpec = '%s';
sizeA = [5 Inf];
txt_fname=temp_label_txt;
fileID = fopen(txt_fname);
C = textscan(fileID,formatSpec);
% A=fscanf(fileID,formatSpec)
% A = fscanf(fileID,formatSpec,sizeA)
fclose(fileID);
n=size(C{1},1);
n_col=6;
n_row=n/n_col;
CC=reshape(C{1},n_col,n_row)';
ROI=CC(:,1);
Label=str2double(CC(:,2));
R=str2double(CC(:,3));
G=str2double(CC(:,4));
B=str2double(CC(:,5));
alpha=str2double(CC(:,6));
T=table(ROI,Label,R,G,B,alpha);