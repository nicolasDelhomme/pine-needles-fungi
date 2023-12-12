#' ---
#' title: "Creating the sample sheet"
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
  library(here)
  library(readr)
})

#' # Sample Sheet
#' 
#' Locate the files
file.list <- list.files(here("gcdata/merge"),pattern=".*\\.fastq\\.gz",full.names=TRUE)

#' # Export
write_tsv(data.frame(sampleID=gsub("ps_291_00[1-5]_|\\.ccsreads.*","",basename(file.list)),
                 forwardReads=file.list),
          here("nextflow/samplesheet.tsv"))

#' # Session Info
#' ```{r session info, echo=FALSE}
#' sessionInfo()
#' ```

