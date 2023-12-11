#!/bin/bash -l

# variables
proj=u2023006
doc=$(realpath ../doc)
in=$(realpath ../gcdata/demultiplex)
out=$(dirname $in)/demultiplex
sif=$(realpath ../singularity/demultiplex_1.2.1.sif)

# input files
read -r -a BC <<< $(find $doc -type f -name "gc_pool*" | sort | xargs)
read -r -a FQ <<< $(find $in -type f -name "*_RevComp.ccsreads.fastq.gz" | sort | xargs)

#echo ${BC[@]}
#echo ${FQ[@]}

# singularity
export SINGULARITY_BINDPATH=/mnt:/mnt

# out dir
[[ ! -d $out ]] && mkdir -p $out

# loop on the input files
len=${#BC[@]}
for ((i=0;i<len;i++)); do
  bc=${BC[$i]}
  fq=${FQ[$i]}
  sbatch -A $proj -o $out/demultiplex$(expr $i + 1).out \
  -e $out/demultiplex$(expr $i + 1).err \
  $(realpath runDemultiplex.sh) -r -s 1 -e 9 $sif $out $bc $fq
done  
