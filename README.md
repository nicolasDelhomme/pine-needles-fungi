# Distinct Foliar Fungal Communities in Pinus contorta Across Native and Introduced Ranges: Evidence for Context Dependency of Pathogen Release

## Citation

Please use [![DOI](https://zenodo.org/badge/729349935.svg)](https://doi.org/10.5281/zenodo.14224526) to cite the use of this repository.

## Authors

Ruirui Zhao1*, Susan J. Nuske2, Martín A. Núñez3,4, Alex Fajardo5,6, Jaime Moyano3, Anne C. S. McIntosh7, Marie-Charlotte Nilsson1, Michael J. Gundale1*

1 Department of Forest Ecology and Management, Swedish University of Agricultural Sciences, SE-90183 Umeå, Sweden.

2 EcoFutures, Brisbane 4006, Australia.

3 Grupo de Ecología de Invasiones, INIBIOMA-UNComa, CONICET, AR-8400 Bariloche, Argentina.

4 Department of Biology and Biochemistry, University of Houston, Houston, TX 77204, USA.

5 Instituto de Investigación Interdisciplinaria (I3), Vicerrectoría Académica, Universidad de Talca, Talca 3460000, Chile.

6 Instituto de Ecología y Biodiversidad (IEB), Las Palmeras 3425, Ñuñoa 7750000, Chile.

7 Science Department, Augustana Faculty, University of Alberta, Camrose, AB T4V 2R3, Canada.

\* Correspondence author: Ruirui Zhao (Ruirui.zhao@slu.se); Michael J. Gundale (Michael.Gundale@slu.se).

## Abstract

Inter-continental study systems are crucial for testing ecological hypotheses that seek to explain the superior performance of plant species when they are introduced to new regions, such as the widely cited Enemy Release Hypothesis (ERH). Pinus contorta (lodgepole pine), native to North America, has been extensively introduced to Europe and the Southern Hemisphere, making it an ideal tree species for studying invasion hypotheses from a biogeographical perspective. We compared foliar fungal communities, especially pathogens, of P. contorta across two native–introduced region pairs (NIRP): a northern NIRP (from Canada to Sweden) and a southern NIRP (from the USA to Patagonia), while also examining the differences between source plantations and invasion fronts within Patagonia. Firstly, P. contorta underwent significant fungal community shifts and experienced pathogen release during its large-scale introduction from North America to Sweden and Patagonia. These changes were more pronounced for the southern NIRP pair, where no closely related tree species to P. contorta are present in Patagonia. In Sweden, the presence of the phylogenetically related P. sylvestris and its associated local fungal community appears to play a pivotal role in influencing the foliar fungal community of P. contorta after its introduction. In Patagonia, the incomplete co-invasion of fungal taxa from the USA emerges as a principal driver of the observed variability in fungal community composition and pathogen release following the introduction of P. contorta. Secondly, in Patagonia, fungal community composition differences between source plantations and invasion fronts provided insufficient evidence that pathogen release occurs at this local scale. Integrating both biogeographical and phylogenetic perspectives, our study indicates that priority effects of the local fungi appear to be a dominant community assembly process when introduction is done in a phylogenetically similar community; whereas, co-invasion of fungal communities is the dominant process in phylogenetically distant communities.

## Methods

Metadata provided by Susan are in the doc folder, the xlsx file.

**Note** the `main` branch is for the outdoor samples. The growth chamber data is in the `growth-chamber` branch.

## Devised fragment structure

| Position (bp) | Sequence             | Description                                                                                          |
|---------------|----------------------|------------------------------------------------------------------------------------------------------|
| 1-9           |                      | see samples file                                                                                     |
| 10-29         | TCCTCCGCTTATTGATATGC | reverse PCR primer ITS4                                                                              |
|               |                      | amplicon                                                                                             |
|               | ACCWGCGGARGGATCATTA  | forward primer devised by the sequence similarity of the sequences; should be ITS1 followed by CATTA |

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
|------------------------------|--------------------|---------------------------|
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

3.  The files fwd and rev-comp are then concatenated

See the script `pipeline/submitMergeDmux.sh`

4.  The sample file was created for the nf-core Ampliseq run

See the R script `src/R/sampleSheetCreation.R`

5.  Running nextflow Ampliseq pipeline.

See the pipeline README.md file. As we have rev-comp'ed all sequences as compared to the design, we also swap the FW and RV primer specification.

6.  Performed the swarm clustering

The data is prepared using the `src/R/swarmInput.R`.

Swarm is then run using `pipeline/submitSwarm.sh`. Parameters are the same as in Schneider *et al.*, see [there](https://github.com/andnischneider/its_workflow/blob/master/workflow/scripts/runSwarm.sh).

## Note

**Important**: Because of the preprocessing, the reconstructed sequences are likely to be reverse-complemented. This does not affect annotation, clustering, _etc._ but for comparing to other dataset or for reporting, it might be worth to 2x check the sequence orientation and correct it if needed.
