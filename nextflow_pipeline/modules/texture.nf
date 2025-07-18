// Nextflow module for texture feature extraction
process TEXTURE_CPU {
    tag { "texture_cpu" }
    conda "${params.featurization_env}"


    input:
        tuple val(patient), val(well_fov), val(featurize_with_gpu)

    output:
        stdout emit: dummy_output_ch_txt

    script:
        """
        cd ${projectDir}/../../3.cellprofiling/slurm_scripts/ || exit 1
        echo "Running CPU featurization for patient: ${patient}, well_fov: ${well_fov} use_gpu: ${featurize_with_gpu}"
        bash run_texture_child.sh ${well_fov} ${featurize_with_gpu} ${patient}
        cd ${projectDir}/ || exit 1
        """
}
