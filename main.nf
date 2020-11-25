
params.mode="nanopore"
params.reference="hg38.fa"
params.bam ="../../data/raw/D**.{bam,bam.bai}"
params.workdir="."
bam_ch = Channel
            .fromFilePairs(params.bam) {file -> file.name.replaceAll(/.bam|.bai$/,'')}



process cuteSV {
conda "environment.yml"
publishDir "results"

  input:
    tuple(val(sampleID),path(bam)) from bam_ch

  output:
    path("{sampleID}.vcf") into out

script:
"""
if( mode == 'pacbio_clr' )
        """
        --max_cluster_bias_INS		100
        --diff_ratio_merging_INS	0.3
        --max_cluster_bias_DEL	200
        --diff_ratio_merging_DEL	0.5
        """

    else if( mode == 'pacbio_hifi' )
        """
        --max_cluster_bias_INS		100
	      --diff_ratio_merging_INS	0.3
	      --max_cluster_bias_DEL	200
	      --diff_ratio_merging_DEL	0.5
        """

    else if( mode == 'nanopore' )
        """
        cuteSV ${sampleID}.bam \
        ${params.reference} \
        ${sampleID}.vcf \
        --threads  ${task.cpus} \
        --max_cluster_bias_INS		100 \
	      --diff_ratio_merging_INS	0.3 \
	      --max_cluster_bias_DEL	100 \
	      --diff_ratio_merging_DEL	0.3 \
        ${params.workdir}
        """

    else
        error "Invalid alignment mode: ${mode}"

"""



}
