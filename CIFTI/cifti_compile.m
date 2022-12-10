function cifti_compile()

    here = fileparts(mfilename('fullpath'));
    current = pwd;

    cd(fullfile(here,'@xmltree/private'));
    try
        mex xml_findstr.c
    catch
        warning('Could not compile xml_findstr.');
    end
    cd(current);
    
end