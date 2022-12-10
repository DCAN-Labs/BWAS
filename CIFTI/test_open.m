function test_open( name )
%
% Import example datasets:
% 
% rsync -P user@jalapeno00:/vols/Scratch/HCP/Diffusion/Q123/214423/MNINonLinear/Results/Tractography/Parcellated/214423.aparc.a2009s.32k_fs_LR_sep.dlabel.nii .
% rsync -P user@jalapeno00:/vols/Scratch/HCP/Diffusion/Q123/100307/MNINonLinear/Results/Tractography/Parcellated/100307.aparc.32k_fs_LR_sep_subctx.dlabel.nii .
% 
% Test the results of new vs old cifti_open:
% 
% test_open( '100307.aparc.32k_fs_LR_sep_subctx.dlabel.nii' );
% 
% JH

    [c1,d1] = cifti_open_old(name);
    [c2,d2] = cifti_open(name);
    
    assert( all(c1.cdata == c2.cdata), 'Different cdata.' );
    compare_xml(d1,d2);
    
end

function compare_xml( x1, x2 )
        
    n = numel(x1);
    assert( numel(x2) == n, 'Size mismatch.' );

    for i = 1:n
        compare_struct( x1{i}, x2{i} );
    end

end

function compare_struct( s1, s2 )

    assert( isstruct(s1) && isstruct(s2), 'Inputs should be structures.' );

    f = fieldnames(s1);
    for i = 1:numel(f)
        
        v1 = s1.(f{i});
        v2 = s2.(f{i});
        
        if isstruct(v1)
            compare_struct(v1,v2);
        elseif ischar(v1)
            assert( ischar(v2), 'Both values should be strings.' );
            assert( strcmp(v1,v2), 'String value mismatch.' );
        elseif isnumeric(v1)
            assert( isnumeric(v2), 'Both values should be numeric.' );
            assert( all(v1(:)==v2(:)), 'Numeric value mismatch.' );
        else
            warning('Dont know how to compare fields "%s".',f{i});
        end
        
    end

end