#making No. of Unique sequences graph with ggplot2
library(ggplot2)

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)
# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
setwd(args[1])
plots <- Sys.glob("plot1*.txt")

# alternative to working with multiple files: files <- list.files(pattern="plot1*.txt")
#Start loop
for(plot in plots) {

#Define the output name for graph
output <- basename(file.path("uniq_", plot, fsep=".txt", ".pdf"))

#Define what the input for the plot
inputplot1 <- read.table(plot, header=T)
#Plot the graph
theplot <- ggplot(inputplot1, aes(x=Abundance, y=Count))+geom_point(color="firebrick", size=3)
#Save the graph
ggsave(output, theplot)
}
