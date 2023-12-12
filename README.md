# Amplicon Seq

Metadata provided by Susan are in the doc folder, the xlsx file.

## Pine growth chamber

### Setup

``` bash
ln -s  /mnt/ada/projects/pine/nstreet/pine-growth-chamber gcdata
ln -s  /mnt/picea/projects/singularity/kogia singularity
```

The barcodes for the samples were extracted from the xlsx file, one tsv file per pool. These are stored in the doc folder.

### Processing

1.  The samples were demultiplexed (pipeline/submitDemultiplex.sh)

| File                         | Original file size | Unknown barcode file size |
|------------------|-----------------------|-------------------------------|
| ps_291_001.ccsreads.fastq.gz | 40847007           | 30200712                  |
| ps_291_002.ccsreads.fastq.gz | 43349534           | 27979964                  |
| ps_291_003.ccsreads.fastq.gz | 42311699           | 27091893                  |
| ps_291_004.ccsreads.fastq.gz | 45726195           | 28868989                  |
| ps_291_005.ccsreads.fastq.gz | 40631708           | 25842036                  |

All pools have high amount of unknown sequences

2.  Assessing the barcode location

This was done using src/R/barcodeLocation.R. The interesting finding is that a lot of the unknown are actually reverse-complement sequences, about 42% of all sequences. Reverse-complementing and extracting them rescues a lot of data. It is still very surprising that all pools have so much "lost" data.

| File                         | Unknown file size | Rescued rev-comp | Total    |
|---------------------------|----------------|---------------|---------------|
| ps_291_001.ccsreads.fastq.gz | 47996314          | 10432293         | 17420621 |
| ps_291_002.ccsreads.fastq.gz | 40099572          | 10493356         | 17969702 |
| ps_291_003.ccsreads.fastq.gz | 41544462          | 9923625          | 17349226 |
| ps_291_004.ccsreads.fastq.gz | 109914483         | 10943005         | 19121964 |
| ps_291_005.ccsreads.fastq.gz | 41179699          | 9810422          | 16915905 |

3.  The files fwd and rev-comp are then concatenated

See the script `pipeline/submitMergeDmux.sh`. It generates the total amount of reads in the column "Total" above.

4.  The sample file was created for the nf-core Ampliseq run

See the R script `src/R/sampleSheetCreation.R`

5.  Running nextflow Ampliseq pipeline.

See the pipeline README.md file. 
