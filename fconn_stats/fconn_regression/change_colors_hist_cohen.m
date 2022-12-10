function change_colors_hist_cohen(path_file)
%% Define colors to use
FaceColor=[102,102,102;
    240 121 167]/255;

EdgeColor=[63,0,125;197,27,138]/255;

%% Load file

openfig(path_file);
f=filesep;
[filepath,name,ext] = fileparts(path_file);
%% Replace color
obj=get(gca);

obj.Children(2).FaceColor=FaceColor(1,:);
obj.Children(1).FaceColor=FaceColor(2,:);


obj.Children(1).EdgeColor=EdgeColor(2,:);
obj.Children(2).EdgeColor=EdgeColor(1,:);

%% Replace text

tit=get(gca,'title');
tit=tit.String;
% tit=regexprep(tit,'Fr','Fp');
% tit=regexprep(tit,'NF','Fa');
tit=regexprep(tit,'_',' vs ');
title(tit)

%% save figure
savefig(path_file);
fig_name=path_file;
fig_name=regexprep(fig_name,ext,'');

print([fig_name],'-dpng','-r300')
close(gcf)
