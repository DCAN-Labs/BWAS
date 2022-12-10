function env_2=rewrite_paths(env_1)

% this function rewrite paths between the airc and oscar's pc
% env_1 is a cell containing the paths in one system. env_2 is the
% correspoding path in the other system

if ~iscell (env_1)
    foo{1}=env_1;
    env_1=foo;
    flag_uncell=1;
else
    flag_uncell=0;
end

n_paths=length(env_1);
env_2=cell(size(env_1));


for i=1:n_paths
    
    local_path1=env_1{i};
    
    % from rushmore rose to C
    if contains(local_path1,'/mnt/rose/shared/projects/pco_branch/')
        old='/mnt/rose/shared/projects/pco_branch/';
        new='C:\Users\mirandad\Documents\rushmore\pco_branch\';
        local_path2 = strrep( local_path1 , old , new );
        old='/';
        new=filesep;
        local_path2 = strrep( local_path2 , old , new );
        env_2{i}=local_path2;
    end
    
    % PC to airc | horak
    if strcmp(local_path1(1:2),'V:')
        local_path2=['/group_shares/horaklab/bulk/' local_path1(4:end)];
        local_path2(local_path2=='\')='/';
        env_2{i}=local_path2;
    end
    
    % PC to airc | public
    if strcmp(local_path1(1:2),'P:')
        local_path2=['/public/' local_path1(4:end)];
        local_path2(local_path2=='\')='/';
        env_2{i}=local_path2;
    end
    
    % PC to airc | fair
    if strcmp(local_path1(1:2),'F:')
        local_path2=['/group_shares/fnl/bulk/' local_path1(4:end)];
        local_path2(local_path2=='\')='/';
        env_2{i}=local_path2;
    end
    
    
    % airc to PC | horak
    if strcmp(local_path1(1:28),'/group_shares/horaklab/bulk/')
        local_path2=['V:\' local_path1(29:end)];
        local_path2(local_path2=='/')='\';
        env_2{i}=local_path2;
    end
    
    % airc to | public
    if strcmp(local_path1(1:8),'/public/')
        local_path2=['P:\' local_path1(9:end)];
        local_path2(local_path2=='/')='\';
        env_2{i}=local_path2;
    end
    
    % airc to PC | fair
    if strcmp(local_path1(1:23),'/group_shares/fnl/bulk/')
        local_path2=['F:\' local_path1(24:end)];
        local_path2(local_path2=='/')='\';
        env_2{i}=local_path2;
    end
    
    
end

if flag_uncell==1
    foo=env_2{1};
    env_2=foo;
end