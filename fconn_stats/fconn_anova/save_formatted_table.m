function save_formatted_table(main_table_long,within_design,fig_name)

% T=evalc('disp(main_table_long)');
%
% fileID = fopen('foo.txt','w');
% fprintf(fileID,'%s', T)
% fclose(fileID);

%%
[nrows, ncols]=size(main_table_long);
if isempty (within_design) % stupid lack of consistency in the tables matlab make
    nrows=nrows+6;
    ncols=ncols+1;
end
if ispc
    fig_size=[8 1 nrows*2.5 ncols*.9];
    fig_size=[8 1 30 nrows/2];
else
    fig_size=[8 1 nrows*2.5 ncols*1.2];
    fig_size=[8 1 30 nrows/2];
end
if nargin<3
    fig_name='main_anova_table';
end
f = figure('Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

% Get the table in string form.
TString = evalc('disp(main_table_long)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);

print(fig_name,'-dpng')
%
% %%
% c1=main_table_long.Properties.RowNames;
% c1=cat(1,{' '},c1);
%
% c2=[main_table_long.Properties.VariableNames; table2cell(main_table_long)];
%
% c=[c1 c2];
%
% [nrows, ncols]=size(c);
%
% formatSpec1='%2s';
% formatSpec2=formatSpec1;
% for i=2:ncols
%     formatSpec1=[formatSpec1 ' %8s'];
%     formatSpec2=[formatSpec2 ' %4.4f'];
% end
% formatSpec1=[formatSpec1 '\n'];
% formatSpec2=[formatSpec2 '\n'];
% % formatSpec2=formatSpec1;
% % formatSpec2(formatSpec2=='%s')='%4.2f'
%
% %%
% fileID = fopen('foo.txt','w');
% for row = 1:nrows
%     fprintf(fileID,formatSpec,c{row,:});
% end
% fclose(fileID);
