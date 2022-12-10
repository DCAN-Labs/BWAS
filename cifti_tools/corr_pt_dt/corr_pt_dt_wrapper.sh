#!/bin/bash


usage="no usage"

if [ $# == 0 ]; then
    echo -e ${usage}
    exit $?
fi

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -h) echo -e ${usage}
            exit
            ;;
        -p) if [ -e $2 ] && [ ${2: -13} == ".ptseries.nii" ]; then
            pt_series_file=$2
            echo ${pt_series_file}
            fi
            shift
            ;;
        -d) if [ -e $2 ] && [ ${2: -13} == ".dtseries.nii" ]; then
            dt_series_file=$2
            echo ${dt_series_file}
            fi
            shift
            ;;
        -x) ix=${2}
            echo $ix
            shift
            ;;
        -o) if [ -e $(dirname ${2}) ]; then
            output_file=$2
            echo $output_file
            fi
            shift
            ;;
    esac
    shift
done

#pt_series_file=$1
#dt_series_file=$2
#ix=$3
#output_file=$4


#matlab -nodisplay -r "corr_pt_dt(${pt_series_file}, ${dt_series_file}, ${ix}, ${output_file}); quit"


#matlab -nodisplay -r "pt_series_file='/group_shares/FAIR_HCP/HCP/processed/ADHD-HumanYouth-OHSU/10050-1/20120605-SIEMENS-Nagel_K-Study/HCP_prerelease_FNL_0_1/MNINonLinear/Results/10050-1_FNL_preproc_Gordon_subcortical.ptseries.nii'; disp(pt_series_file); dt_series_file='/group_shares/FAIR_HCP/HCP/processed/ADHD-HumanYouth-OHSU/10050-1/20120605-SIEMENS-Nagel_K-Study/HCP_prerelease_FNL_0_1/MNINonLinear/Results/10050-1_FNL_preproc_Atlas.dtseries.nii'; disp(dt_series_file); ix=[1 3 350]; disp(ix); output_file='/remote_home/perronea/corr_pt_dt_test'; disp(output_file); corr_pt_dt(pt_series_file, dt_series_file, ix, output_file); quit"



