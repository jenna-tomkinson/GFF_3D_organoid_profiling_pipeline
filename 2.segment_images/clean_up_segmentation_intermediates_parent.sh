#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --account=amc-general
#SBATCH --time=1:00:00
#SBATCH --output=segmentation_cleanup-%j.out

# activate segmentation environment
module load anaconda
conda init bash
conda activate GFF_segmentation

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts/ notebooks/*.ipynb

patient_array=( "NF0014" "NF0016" "NF0018" "NF0021" "SARCO219" "SARCO361" )

for patient in "${patient_array[@]}"; do
    number_of_jobs=$(squeue -u $USER | wc -l)
    while [ $number_of_jobs -gt 990 ]; do
        sleep 1s
        number_of_jobs=$(squeue -u $USER | wc -l)
    done
    echo "Cleaning up segmentation files for patient: $patient"
    sbatch clean_up_segmentation_intermediates_child.sh "$patient"

done

conda deactivate
echo "Segmentation cleanup completed"
