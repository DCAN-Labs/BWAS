
wait_time=300 #sleep time in seconds
bs=24 #batch size

pushd grid_sub

for ((i=1 ; i<=${n_survivors} ;  i++)); do
    #echo $i
    matlab_file="Connectotype_${i}.m"
    rm -f ${matlab_file}
    touch ${matlab_file}
    echo local_i=${i}";" >> ${matlab_file}
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
