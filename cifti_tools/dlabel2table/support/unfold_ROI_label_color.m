function T = unfold_ROI_label_color(cdata,T)
%%
n=numel(cdata);
index=[0:n-1]';
ROI=cell(n,1);
Label=nan(n,1);
R=nan(n,1);
G=nan(n,1);
B=nan(n,1);
alpha=nan(n,1);

%% Assign
[u,nu,ix,nix]=find_uniques(cdata);

Label_inSummary=T.Label;
for i=1:nu
    ix_in_summary=find(Label_inSummary==u(i));
    if ~isempty(ix_in_summary)
        ROI(ix{i})=T.ROI(ix_in_summary);
        Label(ix{i})=T.Label(ix_in_summary);
        R(ix{i})=T.R(ix_in_summary);
        G(ix{i})=T.G(ix_in_summary);
        B(ix{i})=T.B(ix_in_summary);
        alpha(ix{i})=T.alpha(ix_in_summary);
    end
    
end


%% Tablify

T=table(index,ROI,Label,R,G,B,alpha);