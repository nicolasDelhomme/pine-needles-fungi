# Pipeline

This directory contains the scripts used to demultiplex the data and a description in the present file on how to run the nf-core Ampliseq pipeline

## nf-core Ampliseq

1. test run
```bash
nextflow run nf-core/ampliseq -profile test,singularity --outdir pine-leaf-fungi
```

2. update the pipeline (if needed)
```bash
nextflow pull nf-core/ampliseq
```

3. actual run command (from the pipeline directory)
```bash
out=$(realpath ../gcdata)/work

[[ ! -d $out ]] && mkdir -p $out

nextflow run nf-core/ampliseq \
-profile upscb,singularity \
-c $(realpath ../nextflow/upscb.config) \
-w $(realpath ../gcdata)/work \
--input "$(realpath ../nextflow/samplesheet.tsv)" \
--pacbio --dada_ref_taxonomy "unite-fungi=9.0" \
--outdir $(realpath ../gcdata)/nextflow \
--RV_primer "TAAGCATATCAATA" \
--FW_primer "TGTGARTCATCGARTCTTTG"
```
