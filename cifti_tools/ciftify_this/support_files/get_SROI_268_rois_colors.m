function parcel = get_SROI_268_rois_colors(parcel)

parcel(1).RGB=[177,89,40]/255; % CER|bct
parcel(2).RGB=[0.502	0	0.502]; %CON | CiO
parcel(3).RGB=[0	0.863	0]; % DAN | DoA
parcel(4).RGB=[1	0	0]; % DFM | Def
parcel(5).RGB=[0.961	0.961	0.059]; % FrP | FrP
parcel(6).RGB=[0.502	0.502	0.502]; % OTHER | non
parcel(7).RGB=[0	0	0]; % SAL | Sal
parcel(8).RGB=[1	0.502	0]; % SSM | SMm
parcel(9).RGB=[1	1	1]; % SUB | bct
parcel(10).RGB=[0	0.502	0.502]; % VAN | VeA
parcel(11).RGB=[0	0	1]; % VIS |Vis
parcel(12).RGB=[231,41,138]/255; % SRO | subcortical ROI added to standard power

%% Gordon
% parcel(1).RGB=[1	0	1]; % Aud
% parcel(2).RGB=[0.502	0	0.502]; % CiO
% parcel(3).RGB=[0	0.427	1]; % CiP
% parcel(4).RGB=[1	0	0]; % Def
% parcel(5).RGB=[0	0.863	0]; % DoA
% parcel(6).RGB=[0.961	0.961	0.059]; % FrP
% parcel(7).RGB=[0.863	0.863	0.863]; % ReT
% parcel(8).RGB=[0	1	1]; % SMh
% parcel(9).RGB=[1	0.502	0]; % SMm
% parcel(10).RGB=[0	0	0]; % Sal
% parcel(11).RGB=[0	0.502	0.502]; % VeA
% parcel(12).RGB=[0	0	1]; % Vis
% parcel(13).RGB=[1	1	1]; % bct
% parcel(14).RGB=[0.502	0.502	0.502]; % non