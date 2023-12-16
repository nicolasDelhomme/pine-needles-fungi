#! /bin/bash -l

# safe
set -eu

# vars
sif=$(realpath ../singularity)/../swarm_v3_1_4.sif
proj=u2023006
in=$(realpath ../data/swarm/ASV_seqs_sum.fasta)
out=$(dirname $in)

# apptainer
export SINGULARITY_BINDPATH=/mnt:/mnt

# submit
sbatch -A $proj -o $out.out -e $out.err \
$(realpath runSwarm.sh) -t 8 $sif $in $out
