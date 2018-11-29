# TCR Analysis using VDJ Tools input in tcR Package in R
#load all libraries
library(tcR)
library(circlize)

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = FALSE)
# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
print(args[6])
print(args[7])
print(args[8])
print(args[9])
print(args[10])
print(args[11])
print(args[12])
print(args[13])
print(args[14])
print(args[15])
print(args[16])
#print(args[17])

setwd(args[6])

#getwd()

FILENAME1 <- args[7]
FILENAME2 <- args[8]
FILENAME3 <- args[9]
FILENAME4 <- args[10]
#FILENAME5 <- args[11]
#FILENAME6 <- args[12]
#FILENAME7 <- args[13]
#FILENAME8 <- args[14]
#FILENAME9 <- args[15]
#FILENAME10 <- args[16]
#Do Dialog Boxes that ask for Input for later

#SampleNumber <-readline("How many samples do you have?")
# Write output filenames
#output <- paste(prefix = "cloneset-stats_", args[8], sep="")

# Read files
FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)
FILE3 <- parse.vdjtools(FILENAME3)
FILE4 <- parse.vdjtools(FILENAME4)
FILE5 <- parse.vdjtools(FILENAME5)
FILE6 <- parse.vdjtools(FILENAME6)
#FILE7 <- parse.vdjtools(FILENAME7)
#FILE8 <- parse.vdjtools(FILENAME8)
#FILE9 <- parse.vdjtools(FILENAME9)
#FILE10 <- parse.vdjtools(FILENAME10)

# Make a list of all files that come from one experiment
Experiment <- list("S91" = FILE1, "S92" = FILE2, "S93" = FILE3, "S4" = FILE4, "S5" = FILE5, "S6" = FILE6)
# Make one with top 100


cloneset_stats <- cloneset.stats(Experiment)
# Make a file with information about clonesets of all samples
write.table(cloneset_stats, "tcR_cloneset_stats")

############ Abundance of clonotypes ############
# How many clonotypes fill up approximatley the 25% of the sum of values in 'Read.count'
# 'Read.count' is a header (column) inside the parsed IMGT FILE
clonal_proportion <- clonal.proportion(Experiment, 20)
write.table(clonal_proportion, "tcR_clonal_proportion")

############ Top-10 clonotypes ############
# Get a proportion of the top-10 clonotypes' reads to the overall number of reads
top_proportion <- top.proportion(Experiment, 10)
top_proportion50 <- top.proportion(Experiment, 50)
# Plot this
top_proportions_plot <- vis.top.proportions(Experiment)
ggsave("tcR_top_proportions_plot.pdf", top_proportions_plot)

top_proportions50_plot <- vis.top.proportions(Experiment, c(10,20,50,100,1000, 10000,100000,1000000), .col="Read.count")
ggsave("tcR_top_proportions50_plot.pdf", top_proportions50_plot)

write.table(top_proportion, "tcR_top10_proportion")
write.table(top_proportion50, "tcR_top50_proportion")

############ Clonal space homeostasis ############
# How many space occupied by clonotypes with specific proportions?
# Compute summary space of clones, that occupy [0, .05] and [.05, 1] proportions
clonal_space <- clonal.space.homeostasis(Experiment, c(Rare = .001, Small = 0.01, Medium  = 0.1, Expanded = 1))
clonal_space_plot <- vis.clonal.space(clonal_space)
ggsave("tcR_clonal_space.pdf", clonal_space_plot)

############ Gene usage ############
# V-gene usage
vgene <- geneUsage(Experiment, MOUSE_TRBV)
vgene_plot <- vis.gene.usage(Experiment, MOUSE_TRBV, .main = 'Experiment V-usage dodge', .dodge= T)
ggsave("tcR_vgene.pdf", vgene_plot)

# J-gene usage
jgene <- geneUsage(Experiment, MOUSE_TRBJ)
jgene_plot <- vis.gene.usage(Experiment, MOUSE_TRBJ, .main = 'Experiment J-usage dodge', .dodge= T)
ggsave("tcR_jgene.pdf", jgene_plot)

############ Diversity of gene usage ############
# Entropy for V-genes
vgene_entropy <- entropy.seg(Experiment, MOUSE_TRBV)
# Jensen-Shannon meassure for V-genes
vgene_js <- js.div.seg(Experiment, MOUSE_TRBV, .verbose = F)
vgene_js_plot <- vis.radarlike(vgene_js, .ncol=2)
ggsave("tcR_vgene_js_plot.pdf", vgene_js_plot)

# Entropy for J-genes
jgene_entropy <- entropy.seg(Experiment, MOUSE_TRBJ)
# Jensen-Shannon meassure for J-genes (IMPORTANT: Change Species 'Human_ or Mouse_TRBJ')
jgene_js <- js.div.seg(Experiment, MOUSE_TRBJ, .verbose = F)
jgene_js_plot <- vis.radarlike(jgene_js, .ncol=2)
ggsave("tcR_jgene_js_plot.pdf", jgene_js_plot)

############ Repertoire overlap analysis ############
# Shared clonotypes among samples
shared_clonotypes <- repOverlap(Experiment, 'exact', .norm = F, .verbose = F)
shared_clonotypes_plot <- vis.heatmap(shared_clonotypes, .title = 'Shared Clonotypes', .labs='', .legend = "# clonotypes")
ggsave("tcR_shared_clonotypes.pdf", shared_clonotypes_plot)
write.table(shared_clonotypes, "tcR_shared_clonotypes")

############ Diversity Index Analysis ############
repDiversity(Experiment, 'inv.simp', 'read.prop')
InvSimpson <- as.data.frame(sapply(Experiment, function (x) inverse.simpson(x$Read.proportion)))
colnames(InvSimpson)[1] <- "Inverse Simpson Index"
write.table(InvSimpson, "tcR_div_InvSimpson.txt", sep="\t", col.names=TRUE, row.names=TRUE)


repDiversity(Experiment, 'div', 'read.count')
DiversityIndex <- as.data.frame(sapply(Experiment, function (x) diversity(x$Read.count)))
colnames(DiversityIndex)[1] <- "Ecological Diversity Index"
write.table(DiversityIndex, "tcR_div_EcoDivIndex.txt", sep="\t", col.names=TRUE, row.names=TRUE)


repDiversity(Experiment, 'gini.simp', 'read.prop')
GiniSimpson <- as.data.frame(sapply(Experiment, function (x) gini.simpson(x$Read.proportion)))
colnames(GiniSimpson)[1] <- "Gini-Simpson Index"
write.table(GiniSimpson, "tcR_div_GiniSimpson.txt", sep="\t", col.names=TRUE, row.names=TRUE)


repDiversity(Experiment, 'chao1', 'read.count')
ChaoIndex <- as.data.frame(sapply(Experiment, function (x) chao1(x$Read.count)))
write.table(ChaoIndex, "tcR_div_Chao.txt", sep="\t", col.names=TRUE, row.names=TRUE




########## Compare the Repertoires and make Stacked graphs (Bar and Area) #############
#Make a dataframe of all samples with just the top100 clones


#Parameter .type is a string of length 4, where:
#First character stands either for the letter 'a' for taking the "CDR3.amino.acid.sequence" column or for the letter 'n' for taking the "CDR3.nucleotide.sequence" column.
#Second character stands whether or not take the V.gene column. Possible values are '0' (zero) stands for taking no additional columns, 'v' stands for taking the "V.gene" column.
#Third character stands for using either UMIs or reads in choosing the column with numeric characterisitc (see the next letter).
#Fourth character stands for name of the column to choose as numeric characteristic of sequences. It depends on the third letter. Possible values are "c" for the "Umi.count" (if 3rd character is "u") / "Read.count" column (if 3rd character is "r"), "p" for the "Umi.proportion" / "Read.proportion" column, "r" for the "Rank" column or "i" for the "Index" column. If "Rank" or "Index" isn't in the given repertoire, than it will be created using set.rank function using "Umi.count" / "Read.count" column.
#imm.shared <- shared.repertoire(Experiment.top100, .type ='avrp', .min.ppl=1, .verbose=F)
# cut out the fileds not required (Vgene and people)
#imm.shared.cut <- imm.shared[4-6]
#imm.shared.cut <- imm.shared.cut[3-5]
#df2 <- melt(imm.shared.cut, id="CDR3.amino.acid.sequence")

#Creat the graph
#First set colors
#colors <- colours()[seq(1,length(levels(factor(df2$CDR3.amino.acid.sequence))),by=1)]
# if the legend should be removed ad '+theme(legend.position="none")'
#stackedbar <- ggplot(df2, aes(x=variable, y=value, fill=CDR3.amino.acid.sequence))+
#geom_bar(stat="identity")+
#scale_fill_manual(values=colors)+
#guides(fill=FALSE)

#Save the graph
#ggsave("stacked_bargraph.pdf", stackedbar)


############ Make a Chord Diagram using circlize ############

#Make a dataframe/matrix that includes the information
#How to plot one for each sample?
#imm1.vj <- geneUsage(Experiment, list(MOUSE_TRBV, MOUSE_TRBJ))
#Save the graph
#chordDiagram(imm1.vj)

############ Evaluate the diversity of clones by the ecological diversity index ############







############ CDR3 Length and read count distribution plot ############
# Use own script for this graph
#CDR3_plot <- vis.count.len(Experiment[[1]], .name = "CDR3 Lenghts", .col ="Read.count")
#ggsave("tcR_CDR3_plot.pdf", CDR3_plot)
