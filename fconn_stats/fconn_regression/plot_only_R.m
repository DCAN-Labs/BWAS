function plot_only_R(performance,Weights,labels,P,Y)

n=size(labels,1);
local_P=zeros(n,1);

R=zeros(n,1);
R_null=zeros(n,1);
n_alt_null=zeros(n,2);

p_unc=zeros(n,1);

tails=2;
for k=1:n
    y_alt_obv_pred=[Y{k}.alt.observed Y{k}.alt.predicted];
    %     R(k)=corr(y_alt_obv_pred(:,1),y_alt_obv_pred(:,2));
    
    h1=y_alt_obv_pred(:,1:end/2);
    h2=y_alt_obv_pred(:,end/2+1:end);
    R(k)=corr(h1(:),h2(:));
    
    y_null_obv_pred=[Y{k}.null.observed Y{k}.null.predicted];
    h1=y_null_obv_pred(:,1:end/2);
    h2=y_null_obv_pred(:,end/2+1:end);
    R_null(k)=corr(h1(:),h2(:));
    
    n_alt_null(k,:)=[size(y_alt_obv_pred,1) size(y_null_obv_pred,1)];
    
    r1=R(k);
    r2=R_null(k);
    n1=n_alt_null(k,1);
    n2=n_alt_null(k,2);
    
    p_unc(k)=get_p_from_rs(r1,r2,n1,n2,tails);
end

[b ix]=sort(R,'descend');
% [b ix]=sort(p_unc,'ascend');
%% Correct for multiple comparisons
[foo foo p_cor]=fdr_bh(p_unc);

%% make summary table

R_table=table(labels(ix),R(ix),R_null(ix),p_unc(ix),p_cor(ix));
R_table.Properties.VariableNames{1}='Network_Network';
R_table.Properties.VariableNames{2}='R_alt';
R_table.Properties.VariableNames{3}='R_null';
R_table.Properties.VariableNames{4}='p_uncorrected';
R_table.Properties.VariableNames{5}='p_corrected';

writetable(R_table,['R_p_from_zscores.csv'])
%%
local_dir='R';
mkdir(local_dir);
cd (local_dir)

fig_size=[8 8 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

for k=1:n
    y_alt_obv_pred=[Y{ix(k)}.alt.observed Y{ix(k)}.alt.predicted];
    y_null_obv_pred=[Y{ix(k)}.null.observed Y{ix(k)}.null.predicted];
    
    h1=y_alt_obv_pred(:,1:end/2);
    h2=y_alt_obv_pred(:,end/2+1:end);
    
    h1_null=y_null_obv_pred(:,1:end/2);
    h2_null=y_null_obv_pred(:,end/2+1:end);
    
    if R(ix(k))>0
        
        p_to_show(1)=p_unc(ix(k));
        p_to_show(2)=p_cor(ix(k));
        
        to_append_fig_name{1}='p_uncorrected';
        to_append_fig_name{2}='p_corrected';
        
        for ijk=1:2
            
            fig_name=[num2str(k) '_R_' labels{ix(k)} '_' to_append_fig_name{ijk}];
            fig_name(fig_name==' ')='_';
            set(f,'name',fig_name);
            
            %     scatter(y_alt_obv_pred(:,1),y_alt_obv_pred(:,2))
            if numel(h1)<1e6
                scatter(h1(:),h2(:),'filled')
            else
                scatterhist(h1(:),h2(:),'Marker','.','Kernel','on')
            end
            
            %     R=corr(y_alt_obv_pred(:,1),y_alt_obv_pred(:,2));
            local_p=p_to_show(ijk);
            local_p_text=num2str(local_p,'%4.3f');
            if local_p<1e-2
                local_p_text=num2str(local_p,'%4.1s');
            end
            if local_p<1e-6
                local_p_text='<1e-6';
            end
            title({labels{ix(k)},['\fontsize{8} R = ' num2str(R(ix(k)),'%2.4f'),', p = ' local_p_text]})
            
            
            
            
            %         title({labels{ix(k)},['R = ' num2str(R(ix(k)),'%2.4f')]})
            xlabel('Observed')
            ylabel('Predicted')
            try
            equal_axis()
            catch 
                display('Using "axis equal" instead of the prefered function equal_axis() from the toolbox plotting-tools (https://gitlab.com/ascario/plotting-tools)')
                axis equal
            end
            h=lsline;
            set(h,'color','k')
            %     hold all
            %     scatter(y_null_obv_pred(:,1),y_null_obv_pred(:,2))
            %     lsline
            %     hold off
            f.InvertHardcopy = 'off';
            %     print(fig_name,'-dtiffn','-r300')
            saveas(gcf,fig_name)
            img = getframe(gcf);
            imwrite(img.cdata, [fig_name, '.png']);
        end
        
    end
end

cd ..