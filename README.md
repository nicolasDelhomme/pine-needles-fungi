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
| ps_291_001.ccsreads.fastq.gz | 30200712          | 10432293         | 17420621 |
| ps_291_002.ccsreads.fastq.gz | 27979964          | 10493356         | 17969702 |
| ps_291_003.ccsreads.fastq.gz | 27091893          | 9923625          | 17349226 |
| ps_291_004.ccsreads.fastq.gz | 28868989         | 10943005         | 19121964 |
| ps_291_005.ccsreads.fastq.gz | 25842036          | 9810422          | 16915905 |

3.  The files fwd and rev-comp are then concatenated

See the script `pipeline/submitMergeDmux.sh`. It generates the total amount of reads in the column "Total" above.

4.  The sample file was created for the nf-core Ampliseq run

See the R script `src/R/sampleSheetCreation.R`

5.  Running nextflow Ampliseq pipeline.

See the pipeline README.md file. 

6. Performed the swarm clustering

The data is prepared using the `src/R/swarmInput.R`.

Swarm is then run using `pipeline/submitSwarm.sh`. Parameters are the same as in Schneider _et al._, see [there](https://github.com/andnischneider/its_workflow/blob/master/workflow/scripts/runSwarm.sh).

## Note

**Important** The demultiplexing is here problematic. A lot more data got dropped than expected from looking up the position of the primers (barcode are the 9 bp upstream of it). There should be about 78% of the data recovered, but it's rather in the 40%. It would be worth checking the barcodes, checking the sequences that are missed and possibly try another tool (_e.g._ deML).