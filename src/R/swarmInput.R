#' ---
#' title: "Creating the swarm input"
#' author: "Nicolas Delhomme"
#' date: "`r Sys.Date()`"
#' output:
#'  html_document:
#'    toc: true
#'    number_sections: true
#'    code_folding: hide
#' ---
#' 
#' # Setup
#' 
#' * Libraries
suppressPackageStartupMessages({
  library(Biostrings)
  library(dplyr)
  library(here)
  library(readr)
})

#' # Counts
cts <- read_tsv(here("data/nextflow/dada2/ASV_table.tsv"),show_col_types=FALSE) %>% 
  mutate(sum=rowSums(across(starts_with("pool")))) %>% 
  select(ASV_ID,sum)

#' # Sequences
seq <- readDNAStringSet(here("data/nextflow/dada2/ASV_seqs.fasta"))
stopifnot(all(names(seq)==cts$ASV_ID))
names(seq) <- paste0(cts$ASV_ID,";size=",cts$sum)

#' # Export
dir.create(here("data/swarm"),showWarnings=FALSE)
writeXStringSet(seq,here("data/swarm/ASV_seqs_sum.fasta"))

#' # Session Info
#' ```{r session info, echo=FALSE}
#' sessionInfo()
#' ```

