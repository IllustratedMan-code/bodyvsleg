create_txi <- function(meta_name, quant_type){
  library(tximport)
  metadata <- read.csv(file.path("data/metadata", paste(meta_name, "csv", sep=".")), header=TRUE)
  files <- file.path("data/quant", meta_name, metadata$name)
  names(files) = metadata$name
  assembly = read.table("data/assembly/assembly.tabular")
  txi <- tximport(files, type=quant_type, tx2gene=assembly)
  return(txi)
}

create_deseq <-function(meta_name, txi, design){
  library(DESeq2)
  metadata <- read.csv(file.path("data/metadata", paste(meta_name, "csv", sep=".")), header=TRUE)
  dataset <- DESeqDataSetFromTximport(txi, colData=metadata, design=design)
  deseq <- DESeq(dataset)
  return(deseq)
}

create_edgeR <- function(txi, meta){
  library(edgeR)
}
