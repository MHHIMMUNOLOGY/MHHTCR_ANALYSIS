#R script to get the number of overlapping clones

#Filter out all overlapping clonotypes with x frequency
#This version uses 100% of Input sample to be compared with 0.1% preDLI
library(tcR)

#Set Working Directory so input files can be read
args <- commandArgs(trailingOnly = TRUE)

print(args[1])
print(args[2])
print(args[3])
print(args[4])

setwd(args[1])

FILENAME1 <- args[2]
FILENAME2 <- args[3]
FILENAME3 <- args[4]

FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)
FILE3 <- parse.vdjtools(FILENAME3)

#Make a function that will extract all rows with frequency >= 0.001
CUTOFF <- function(x){x[apply(x[2],1,function(row) {all(row >= 0.001)}),]}

FILE1_CUTOFF <- FILE1
FILE2_CUTOFF <- CUTOFF(FILE2)
FILE3_CUTOFF <- CUTOFF(FILE3)
# Make a list of all files that come from one experiment
Experiment <- list("1Input001" = FILE1_CUTOFF,"preDLI001" = FILE2_CUTOFF, "3placeholder" = FILE3_CUTOFF)

shared_clonotypes <- repOverlap(Experiment, 'exact', .norm = F, .verbose = F)
shared_clonotypes_plot <- vis.heatmap(shared_clonotypes, .title = 'Shared Clonotypes', .labs='', .legend = "# clonotypes")
ggsave("FilterOverlap_allofINPUT.pdf", shared_clonotypes_plot)
write.table(shared_clonotypes, "FilterOverlap_allofINPUT.txt")
