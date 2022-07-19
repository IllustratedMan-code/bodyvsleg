# source functions
if(Sys.getenv("scripts") != ""){
  out = Sys.getenv("scripts")
}else{
  out = ""
}
print(Sys.getenv("out"))
#source(paste(out, "scripts/analysis/import_functions.r", sep="/"))

txi = create_txi("main", "sailfish")
# compare the part of the tick (body vs leg) with the different pesticides
deseq = create_deseq("main", txi, ~part + pesticides)
deet = results(deseq, contrast=c("pesticides", "deet", "control"))
perm = results(deseq, contrast=c("pesticides", "perm", "control"))
body_leg = results(deseq, contrast=c("part", "body", "leg"))

# function for determining significance
significant = function(results, threshold){
  # which is needed to remove NA values
  return(results[which(results$padj < threshold),])
}
# returns upregulated genes
upRegulated = function(results, threshold){
  return(results[which(results$log2FoldChange < threshold),])
}
# returns downRegulated genes
downRegulated = function(results, threshold){
  return(results[which(results$log2FoldChange > threshold),])
}

# select for adjusted p value less than 0.01
body_leg = significant(body_leg, 0.01)
body =
