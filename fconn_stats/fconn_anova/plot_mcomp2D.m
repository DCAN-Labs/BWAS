function plot_mcomp2D(results,m,gnames,stats,parcel,options,between_design)
%% Make plot table

ginfo(1).names={between_design(1).subgroups.name}';
ginfo(1).n=size(ginfo(1).names,1);


ncases=2.^nchoosek(ginfo(1).n,2);% base 2 because for each comparison there are 2 possible outcomes: significant or not significant. nchoosek(ginfo(1).n,2) calculates how many pair comparisons can be made
foo=nchoosek(ginfo(1).names,2);% made for temp saving
temp_n=size(foo,1);
arms_comp=cell(temp_n,1);


for i=1:temp_n
    arms_comp{i}=[foo{i,1} '_' foo{i,2}];
end

dummy=dec2bin(0:ncases-1);% code each comparison as significant or not
cases=zeros(size(dummy));
for i=1:size(cases,2)
    cases(:,i)=str2num(dummy(:,i));
end

bg_color=zeros(ncases,3);
gen_bg=repmat(linspace(1,0,temp_n)',1,3);

for i=0:temp_n-2
    foo=sum(cases,2)'==i;
    bg_color(foo,:)=repmat(gen_bg(i+1,:),sum(foo),1);
end
bg_color(end,:)=gen_bg(end,:);

temp_ix=find(sum(cases,2)==temp_n-1);
j=0;
for i=1:temp_n
    j=j+1;
    bg_color(temp_ix(i),:)=between_design(1).subgroups(end-j+1).color;
end
bg_color(end,:)=gen_bg(end,:);
% ln_color=repmat([0 0 0],ncases,1);
ln_color=repmat([0 0 0],ncases,1);
ln_color([1 end],:)=1;

varnames={'Number' arms_comp{:} 'shown', 'ln_color' 'bg_color'};

shown=[1:ncases]'>1;
%
part1=['ptable=table([1:ncases]'','];
part2=[];
for i=1:temp_n
    part2=[part2 'cases(:,' num2str(i) '), '];
end
part3=['shown,ln_color,bg_color,''VariableNames'',varnames)'];
to_run=[part1 part2 part3 ]
eval(to_run)
%%
fig_name=[stats.varnames{1} ' vs ' stats.varnames{2}];

fs_axis=9; %size of fonts in plots
fs_title=7;%size of fonts in title
fs_legend=10;
fs_label=12;
fig_size=[8 1 20 20];
f = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

%%

Q=table2array(ptable(:,2+(0:temp_n-1)));% section of the table that will be querried
n_parcel=size(options.resort_parcel_order,2)
% n_parcel=size(parcel,2);

tit=stats.grpnames{1};
xtl=stats.grpnames{2};
lw=3;
pth=0.05;
kk=0;
% tse=1.96;% p5%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
pth=0.05;
offset_xlim=.2;
offset_ylim=.1;

n_traces=size(xtl,1);
n_x_networks=size(stats.grpnames{1},1);
ii=1:n_traces;
for i=1:n_parcel
    for j=i:n_parcel
        k=sub2ind([n_parcel n_parcel],i,j);
        subplot(n_parcel,n_parcel,k)
        
        
        
        local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
        
        kk=kk+1;
        
        qp=zeros(1,temp_n);
        for k=1:temp_n
            unfold_arm=arms_comp{k};
            %             p1=unfold_arm(1:floor(end/2));
            %             p2=unfold_arm(ceil(end/2)+1:end);
            
            temp_p=strsplit(unfold_arm,'_');
            p1=temp_p{1};
            p2=temp_p{2};
            
            P1=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p1];
            P2=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p2];
            
            ix1=find(ismember(gnames,P1));
            ix2=find(ismember(gnames,P2));
            %             ix3=find(and(results(:,1)==ix1,results(:,2)==ix2));
            
            ix3=and(results(:,1)==ix1,results(:,2)==ix2);
            % patch for 2 groups
            if isempty(find(ix3))
                ix3=and(results(:,2)==ix1,results(:,1)==ix2);
                
            end
            qp(k)=results(ix3,end);
        end
        qp_record=qp;
        qp=qp<pth;
        
        qn=ismember(Q,qp,'rows');
        if ptable.shown(qn)
            temp=find(qp);
            for ij=1:sum(qp)
                display([char(tit(kk)) ': comparison ' char(arms_comp(temp(ij))) '; p = ' num2str(qp_record(temp(ij)))])
            end
            
            mm=m(local_ix,1);
            %             'color',parcel(options.resort_parcel_order(i)).RGB,...
            %                 'fontsize',12
            se=m(local_ix,2);
            line([ii;ii],[mm+tse*se mm-tse*se]',...
                'color',ptable.ln_color(qn,:),...
                'linewidth',lw)
            hold all
            
            plot(ii,mm,'O','color',ptable.ln_color(qn,:),...
                'LineWidth',lw,...
                'MarkerSize',6,...
                'MarkerEdgeColor',ptable.ln_color(qn,:),...
                'MarkerFaceColor',ptable.bg_color(qn,:))
            set(gca,'color',ptable.bg_color(qn,:))
            hold off
        else
            plot(ii,ii*0,'color',ptable.bg_color(qn,:))
            plot(ii,ii*0,'color',[1 1 1])
        end
        box on
        set(gca,'xtick',ii)
        set(gca,'xticklabel',[])
        if i==1
            ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                'color',parcel(options.resort_parcel_order(j)).RGB,...
                'fontsize',fs_label)
        end
        if j==n_parcel
            xlabel(parcel(options.resort_parcel_order(i)).shortname,...
                'color',parcel(options.resort_parcel_order(i)).RGB,...
                'fontsize',fs_label)
            set(gca,'xticklabel',xtl)
        end
        xlim([0 n_traces+1]);
        %         title(ginfo(2).names(kk))
        
        
        set(gca,'yticklabel',[])
        
        
        axis tight
        xl=xlim;
        dxl=abs(diff(xl));
        xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
        yl=ylim;
        dyl=abs(diff(yl));
        ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
        title(tit(kk),...
            'fontsize',fs_title)
        
        %          xlim([0 n_traces+1]);
        
    end
end

%% WIP adding color boxes
% POS=get(gca,'position');
% POS(4)=POS(2)*.5;
% POS(2)=POS(2)*.1;
%
% subplot('position',POS)
% box on
% set(gca,'color',parcel(options.resort_parcel_order(i)).RGB)
%
% text(mean(xlim),mean(ylim),parcel(options.resort_parcel_order(i)).shortname,...
%     'HorizontalAlignment','center',...
%     'fontsize',12)
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])
