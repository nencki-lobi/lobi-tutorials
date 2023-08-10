#!/bin/bash

# Execute: ./fmap_script.sh sub-xxx/fmap path_to_datain/datain.txt

dir=$1
datain=$(readlink -f $2)
cd $dir

# Set the log file path
log_file="fmap_script.log"

# Get the current date
current_date=$(date +"%Y-%m-%d %H:%M:%S")

if [ -e *AP_epi.nii ] && [ -e *PA_epi.nii ]; then
    echo "Running"
    fslmerge -t se_epi_merged *AP_epi.nii *PA_epi.nii
    topup --imain=se_epi_merged.nii --datain=$datain --config=b02b0.cnf --out=topup_results --fout=my_fieldmap --iout=se_epi_unwarped
    fslchfiletype NIFTI_PAIR my_fieldmap.nii fpm_my_fieldmap
else
    echo "$current_date: One or both of *AP.nii and *PA.nii files are missing in $dir" >> "$log_file"
fi

if [ -e fpm_my_fieldmap.img ]; then
    echo "Finished $dir"
else
    echo "$current_date: Something went wrong with $dir" >> "$log_file"
fi
