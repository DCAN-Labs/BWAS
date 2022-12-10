function save_fig(fig_name,varargin)

%% Oscar Miranda Domínguez
% First line of code: Aug 3, 2021

%% define defaults

path_to_save =pwd;
fs=filesep;

res=300;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'res'
            res=varargin{q+1};
            q = q+1;
            
        case 'path_to_save'
            path_to_save=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end


replace_old_new={'%','percent'};
figname=title2filename({fig_name},'replace_old_new',replace_old_new);
figname=[path_to_save fs figname];
saveas(gcf,figname)

save_res=['-r' num2str(res)];
print(figname,'-dpng',save_res);
print(figname,'-dtiffn',save_res);