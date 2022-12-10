
#parcellation="Power_subcortical" # Name needs to match the parcellated time courses name

wait_time=300 #sleep time in seconds
bs=24 #batch size
matlab_template="/group_shares/FAIR_LAB2/Projects/ADHD_HCP_biomarkers/experiments/model_based/template_calc_model_batch.m"

grid_sub=${parcellation}/grid_sub
mkdir ${grid_sub}
pushd ${grid_sub}

for ((i=1 ; i<=${n_survivors} ;  i++)); do
    #echo $i
    matlab_file="${parcellation}${i}.m"
    rm -f ${matlab_file}
    touch ${matlab_file}
    echo local_i=${i}";" >> ${matlab_file}
    echo parcellation="'"${parcellation}"';" >> ${matlab_file}
    cat ${matlab_template} >> ${matlab_file}
    ${QUEUE} matlab -nodisplay -nosplash -r "${matlab_file%%.m}"
    echo job $i sent to the grid
    
    z=`expr ${i} % ${bs}`
    if [ "$z" -eq 0 ] ; then
       echo $i
       echo sleeping ${wait_time} seconds  since `date`
       sleep ${wait_time}
    fi
done
popd
