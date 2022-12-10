function show_scatters_different_p(n,Y,R,ix,p_unc,p_cor,labels,output_folder)

if ~isfolder(output_folder)
    mkdir(output_folder)
end
fs=filesep;
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
            local_p_text=num2str(local_p,'%4.2f');
            if local_p<1e-2
                local_p_text=num2str(local_p,'%4.1s');
            end
            if local_p<1e-6
                local_p_text='<1e-6';
            end
            
            V=100*R(ix(k))^2;
            tit={labels{ix(k)},['\fontsize{8} R = ' num2str(R(ix(k)),'%2.2f'),', p = ' local_p_text],['(' num2format_text(V) ' % exp. Variance)']};
            title(tit)
            
            
            
            
            %         title({labels{ix(k)},['R = ' num2str(R(ix(k)),'%2.4f')]})
            xlabel('Observed')
            ylabel('Predicted')
            
%             try
%                 equal_axis()
%             catch
%                 display('Using "axis equal" instead of the prefered function equal_axis() from the toolbox plotting-tools (https://gitlab.com/ascario/plotting-tools)')
%                 axis equal
%             end
            h=lsline;
            set(h,'color','k')
            
            %             axis equal
            %             lsline
            %             yl=get(gca,'ytick');
            %             axis_label=set_axis_label(yl);
            %             set(gca,'yticklabel',axis_label)
            %
            %             xl=get(gca,'xtick');
            %             axis_label=set_axis_label(xl);
            %             set(gca,'xticklabel',axis_label)
            
            %     hold all
            %     scatter(y_null_obv_pred(:,1),y_null_obv_pred(:,2))
            %     lsline
            %     hold off
            f.InvertHardcopy = 'off';
            %     print(fig_name,'-dtiffn','-r300')
            saveas(gcf,[output_folder fs fig_name])
            
            img = getframe(gcf);
            imwrite(img.cdata, [output_folder fs fig_name, '.png']);
            %             saveas(gcf,fig_name,'png')
            %             print(fig_name,'-dpng','-r300')
            
            %%   do the dscatter
            sz=4;
            c='k';
            lw=3;
            
            yl=ylim;
            xl=xlim;
            
            dscatter(h1(:),h2(:))
            xlim(xl)
            ylim(yl)
            hold on
            dscatter(h1(:),h2(:),'plottype','contour')
            hold off
            colormap jet
            
            ds=lsline;
            ds.Color = 'k';
            ds.LineWidth = lw;
            
            title(tit)
            
            xlabel('Observed')
            ylabel('Predicted')
            
%             try
%                 equal_axis()
%             catch
%                 display('Using "axis equal" instead of the prefered function equal_axis() from the toolbox plotting-tools (https://gitlab.com/ascario/plotting-tools)')
%                 axis equal
%             end
            
            fig_name=[fig_name '_dscatter'];
            saveas(gcf,[output_folder fs fig_name])
            
            img = getframe(gcf);
            imwrite(img.cdata, [output_folder fs fig_name, '.png']);
            
            
        end
        
    end
end
% cd .