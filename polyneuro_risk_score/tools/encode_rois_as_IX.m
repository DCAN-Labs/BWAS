function [network_names, IX_networks, IX_cummulative, IX_cummulative_reversed]=encode_rois_as_IX(T_networks,T_rois,IX_p)

%%
IX_networks=IX_p;
%%
network_names=T_networks{:,1};
nu=size(T_networks,1);
n_rois=size(T_rois,2)-2;

for i=1:nu
    rows=find(ismember(T_rois.network_names,network_names{i}));
    ix=T_rois{rows,3:end};
    ix_extended=[ix repmat(i,size(ix,1),1)];
    for j=1:size(ix,1)
        try
            IX_networks(ix_extended(j,1),ix_extended(j,2),ix_extended(j,3))=1;
        catch
            IX_networks(ix_extended(j,1),ix_extended(j,2))=1;
        end
    end
end
%%
% if n_rois==2
IX_cummulative=cumsum(IX_networks,3);
IX_cummulative_reversed=cumsum(IX_networks(:,:,end:-1:1),3);
% end
%% binarize

IX_cummulative_reversed=IX_cummulative_reversed==1;
IX_cummulative=IX_cummulative==1;
IX_networks=IX_networks==1;