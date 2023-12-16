#!/bin/bash -l
#SBATCH -p core -n 8
#SBATCH -t 1-00:00:00

# safe
set -eu

# helper
source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

# vars
CPU=8
DIST=3

# usage
USAGETXT=\
"
SYNOPSIS $0 [options] <singularity> <fasta> <outdir>

  Options:
    d: set the distance [$DIST]
    t: set the number of processors [$CPU]
"

# options
while getopts d:t: option
do
    case "$option" in
    d) DIST="$OPTARG";;
    t) CPU="$OPTARG";;
    \?) usage;;
  esac
done
shift `expr $OPTIND - 1`

# sanity
[[ -z ${SINGULARITY_BINDPATH:-} ]] && abort "This function relies on singularity, set the SINGULARITY_BINDPATH environment variable"

[[ $# -lt 3 ]] && abort "The script expects 3 arguments"

[[ ! -f $1 ]] && abort "The first argument needs to be an existing singularity fastqc container file"

[[ ! -f $2 ]] && abort "The ASV fasta file does not exist"

[[ ! -d $3 ]] && abort "The output directory does not exist"

# run
singularity exec $1 swarm -t $CPU -d $DIST -z \
--output-file $3/results.txt --seeds $3/seeds.fasta $2
