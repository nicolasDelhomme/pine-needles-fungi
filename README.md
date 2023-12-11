# Amplicon Seq

Metadata provided by Susan are in the doc folder, the xlsx file.

## Pine needles fungi

### Setup

``` bash
ln -s  /mnt/ada/projects/pine/nstreet/pine-leaf-fungi data
ln -s  /mnt/picea/projects/singularity/kogia singularity
```

The barcodes for the samples were extracted from the xlsx file, one tsv file per pool. These are stored in the doc folder.

### Processing

1.  The samples were demultiplexed (pipeline/submitDemultiplex.sh)

| File                         | Original file size | Unknown barcode file size |
|-----------------|-----------------------|--------------------------------|
| ps_376_001.ccsreads.fastq.gz | 134460210          | 47996314                  |
| ps_376_002.ccsreads.fastq.gz | 125088107          | 40099572                  |
| ps_376_003.ccsreads.fastq.gz | 114792485          | 41544462                  |
| ps_376_004.ccsreads.fastq.gz | 136726504          | 109914483                 |
| ps_376_005.ccsreads.fastq.gz | 96232818           | 41179699                  |

Clearly, something is off with the 4th pool.

2.  Assessing the forth pool barcode location

This was done using src/R/barcodeLocation.R. The interesting finding is that not only for pool 4 but also for the others, a lot of the unknown are actually reverse-complement sequences, about 54% of all sequences. Reverse-complementing and extracting them rescues a lot of data, especially for pool 4. It is still very surprising that pool4 has so much "lost" data.

| File                         | Unknown file size | Rescued rev-comp |
|------------------------------|-------------------|------------------|
| ps_376_001.ccsreads.fastq.gz | 47996314          | 44380196         |
| ps_376_002.ccsreads.fastq.gz | 40099572          | 34697736         |
| ps_376_003.ccsreads.fastq.gz | 41544462          | 35385059         |
| ps_376_004.ccsreads.fastq.gz | 109914483         | 82555784         |
| ps_376_005.ccsreads.fastq.gz | 41179699          | 27888227         |

3. The files fwd and rev-comp are then concatenated

See the script `pipeline/submitMergeDmux.sh`

4. The sample file was created for the nf-core Ampliseq run

See the R script `src/R/sampleSheetCreation.R`

5. Running nextflow Ampliseq pipeline. 

See the pipeline README.md file. As we have rev-comp'ed all sequences as compared to the design, we also swap the FW and RV primer specification.
