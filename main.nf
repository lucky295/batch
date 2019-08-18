#!/usr/bin/env nextflow

// Has the run name been specified by the user?
//  this has the bonus effect of catching both -name and --name
// custom_runName = params.name
// if( !(workflow.runName ==~ /[a-z]+_[a-z]+/) ){
//  custom_runName = workflow.runName
// }


// Stage config files
//ch_multiqc_config = Channel.fromPath(params.multiqc_config)



//params.input = Channel.fromPath( '/efs/nextflow/pipeline/input/pipeline-1/fastq/*.fastq.gz' )
params.input = ( '/mnt/pipeline/input/pipeline-1/fastq/*.fastq.gz' )
params.outdir = "/mnt/srini/results"

/*
* Basic validation for the input fiile exists
*/

input_file = file(params.input)

/*
 * Create a channel for input read files
 */
/*
 * STEP 1 - FastQC
*/
process fastqc_before {
    echo true
    publishDir "${params.outdir}/pre_fastqc",
               saveAs: {filename -> filename.indexOf(".zip") > 0 ? "zips/$filename" : "$filename"}

    input:
    file(reads) from input_file

    output:
    file "*_fastqc.{zip,html}" into  preqc_results

    script:
    """
    fastqc -t 16 -q $reads
    """
}

