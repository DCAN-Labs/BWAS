
# CIFTI

Open CIFTI files (HCP dataset) with the latest versions of Matlab (2015+).

### Dependencies

The following should be installed and added to the path prior to starting Matlab:

 - [Workbench](http://www.humanconnectome.org/software/get-connectome-workbench.html)
 - [Caret](http://brainvis.wustl.edu/wiki/index.php/Caret:Download)

> **Trick:** if you just installed these and don't want to restart Matlab, you can run the following one-liner:
>
>     setenv( 'PATH', strjoin([ {workbench_path, caret_path}, strsplit(getenv('PATH'),pathsep) ],pathsep) );
>

### Mex dependencies

Ideally, you should also have Mex setup correctly to compile C sources.
If that's the case, then run `cifti_compile.m` the first time you use this library.

### Usage

Just add this folder to the Matlab path and use `[gifti_obj,xml_data] = cifti_open( cifti_filename )`.
