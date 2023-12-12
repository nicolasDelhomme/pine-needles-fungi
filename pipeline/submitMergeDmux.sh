#!/bin/bash -l
set -eu

# for some reason, srun hangs (probably too short jobs). Solution was to srun interactively on ioa and do the merging there
#proj=u2023006
in=$(realpath ../gcdata/demultiplex)
out=$(realpath ../gcdata)/merge
#partition=ioa

[[ ! -d $out ]] && mkdir -p $out

for f in $(find $in -name "*_RevComp_*.ccsreads.fastq.gz"); do
  #srun -A $proj -p $partition 
  cat ${f/RevComp_/} $f > $out/$(basename ${f/RevComp_/})
done

# cleanup (best would have been to adapt the find above to not cat the UNK in the first place)
find $out -name "*UNKNOWN*" -delete
