# About making figures
A figure is usually done to show that something is unexpectedly boring or outstanding. Other type of figures helps to understand the complexity of the (sometimes multidimensional) data.

Here are some recommendations that might be useful to prepare figures:

- **Figure size**. Use 8, 12 or ~16-18 cm for width and make the figure as tall as needed. If you make the figure with this size, it will be readable when printed and will also scale properly when enlarged for a poster, for example. 
- **Multipanel figures**. If possible, make the figure as close as possible to the final version using your preferred program (Matlab, R, Python, ...). If needed, you might need to assemble the panels using *powerpoint*, *gimp*, or another program. When using these other programs, keep using all the recommendations about figure size, font size, format, resolution and colors.
    - If using *Powerpont*
        - Figure size: Define figure size by doing this: In the menu, go to Design -> Slide Size -> Custom Slide Size and define the size here.
        - Resolution: Make sure you update the default resolution to export figures: https://support.microsoft.com/en-us/topic/change-the-default-resolution-for-inserting-pictures-in-office-f4aca5b4-6332-48c6-9488-bf5e0094a7d2. Also disable figure compression: https://docs.microsoft.com/en-us/office/troubleshoot/office-suite-issues/office-docuemnt-image-quality-loss
        - Format: Once having the final figure, use save as and select the format you want.

- **Font size**. Use 11 for titles, and 8-9 for legends, labels, etc. Font sizes less than 8 will be hard to read. 
- **Colors**: Use colorblind safe palletes. Here are a couple of resources to select colors:
    -[Colorbrewer](https://colorbrewer2.org/)
    -[Color Universal Design](https://jfly.uni-koeln.de/color/ )
- **Resolution**. I use 300 dpis for prototypes and 1000 for final figures.
- **Format**: png to share across co-authors, tiff for journal submission.

## Matlab specific

```Matlab
%% Creating a figure
 
wide_cm=8; % update as needed
hight_cm=6; % update as needed
 
fig_size=[1 1 wide_cm hight_cm];
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
% Make sure you include PaperPosition and position in the preamble to
% ensure size and resolution are preserved when the figure is saved
 
%% Saving a figure
 
res=300; % by using the variable res, you can define the resolution to be 300, 1000 or whatever you want
fig_name='my_figure'; % provide name (and full path if you want of the figure to save. No need to specify extension. Extension will be properly set in the following lines of code
 
save_res=['-r' num2str(res)]; % a trick to encode resolution
saveas(gcf,fig_name)% this saves the figure as a .fig object that can be edited later in Matlab
print([folder_rf filesep local_fig_name],'-dpng',save_res)% This save the figure as a png file with the requested resolution specified by res
print([folder_rf filesep local_fig_name],'-dtiffn',save_res) % This save the figure as a tiff file with the requested resolution specified by res
```

**About**: Document prepared by Oscar Miranda-Dominguez as a quick cheat sheet to make individual or multi-panel figures.