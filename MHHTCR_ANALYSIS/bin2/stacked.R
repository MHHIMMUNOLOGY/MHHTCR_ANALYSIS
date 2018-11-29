#Sorting in R
#load all libraries
library(ggplot2)
#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = FALSE)
# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
setwd(args[6])
#set variable names
plots <- Sys.glob("CDR3_*.txt")

#prepare color list for graph later
for(plot in plots) {
#output the files
output <- basename(file.path("stacked_", plot, fsep=".txt", ".pdf"))
#Read table as delmitted file
input <- read.delim(plot, header=T, sep="")
colors <- colours()[seq(1,length(levels(factor(input$Count))),by=1)]

#plot a stacked graph
theplot <- ggplot(input, aes(x=Length, y=Count, fill=factor(Count)))+
geom_bar(stat="identity")+
scale_fill_manual(values=colors)+
guides(fill=FALSE)+
ylab("Copies")+
xlab("CDR3 Length")
#save the output
ggsave(output, theplot)
}
