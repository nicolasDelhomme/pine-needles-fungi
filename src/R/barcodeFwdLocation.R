#' ---
#' title: "Locating the barcodes"
#' author: "Nicolas Delhomme"
#' date: "`r Sys.Date()`"
#' output:
#'  html_document:
#'    toc: true
#'    number_sections: true
#'    code_folding: hide
#' ---
#' 
#' # Rationale
#' 
#' A significant proportion of barcodes is not where they are meant to be located, 
#' especially for pool number 4
#' 
#' # Setup
#' 
#' * Libraries
suppressPackageStartupMessages({
  library(Biostrings)
  library(here)
  library(parallel)
  library(ShortRead)
})

#' * Helpers
source(here("UPSCb-common/src/R/percentile.R"))

#' * Function
".process" <- function(fqFile,adapter){
  sid <- sub("\\.ccsreads.*","",basename(fqFile))
  fq <- readFastq(fqFile,withIds=FALSE)
  
  pos <- regexpr(adapter,sread(fq))
  ppos <- percentile(pos)
  plot(density(pos[pos<=ppos["98%"]]),paste(sid, "forward orientation"))
  
  rpos <- regexpr(adapter,reverseComplement(sread(fq)))
  prpos <- percentile(rpos)
  plot(density(rpos[rpos<=prpos["98%"]]),paste(sid, "reverse orientation"))
  
  return(rpos)
}

".export" <- function(fqFile,sel){
  fq <- readFastq(fqFile)
  writeFastq(reverseComplement(fq[sel])
             ,sub("UNKNOWN","RevComp",fqFile),
             full=FALSE,compress=TRUE)
}

#' # Processing
#' 
#' We check and find all positions where the barcode could be located. 
#' Note that to see the plots you need to run without parallelisation ( _i.e._ 
#' `lapply` and not `mclapply`)
fqFiles <- list.files(here("gcdata/raw"),
                      pattern=".*\\.ccsreads\\.fastq\\.gz",
                      full.names=TRUE)

#' primer is TGTGARTCATCGARTCTTTG
pos.list <- mclapply(fqFiles,.process,
                     "TGTGA[A,G]TCATCGA[A,G]TCTTTG",
                     mc.cores=5L)

#' We observed that most of the unknown sequences are valid if reverse-complemented. 
#' There is about 1% of chimeric sequences, where the barcode is in the middle of 
#' the sequence, _i.e._ PacBio multiadapter reads.
#' 
#' The position is at bp 10, which means the barcode (n=9) is from bp 1 to 9 as expected
sapply(lapply(mclapply(pos.list,table,mc.cores=5L),
              sort,decreasing=TRUE),head,n=5)

#' This would rescue grep an average 36% of the forward
sapply(lapply(pos.list,"==",10),sum) / elementNROWS(pos.list)

#' # Export
dev.null <- mapply(.export,fqFiles,lapply(pos.list,"==",10))

#' # Session Info
#' ```{r session info, echo=FALSE}
#' sessionInfo()
#' ```

