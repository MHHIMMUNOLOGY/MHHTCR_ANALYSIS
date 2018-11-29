# TCR Analysis using VDJ Tools input in tcR Package in R
#load all libraries
library(tcR)

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

setwd(args[6])

#getwd()

FILENAME1 <- args[7]
FILENAME2 <- args[8]
FILENAME3 <- args[9]
FILENAME4 <- args[10]
FILENAME5 <- args[11]
FILENAME6 <- args[12]
FILENAME7 <- args[13]
FILENAME8 <- args[14]
FILENAME9 <- args[15]
FILENAME10 <- args[16]
FILENAME11 <- args[17]
FILENAME12 <- args[18]
#Do Dialog Boxes that ask for Input for later

#SampleNumber <-readline("How many samples do you have?")
# Write output filenames
#output <- paste(prefix = "cloneset-stats_", args[8], sep="")

# Read files #What to change before each run: Line 42 and line 48 (everyhwere the FILE variable is used)
FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)
FILE3 <- parse.vdjtools(FILENAME3)
FILE4 <- parse.vdjtools(FILENAME4)
FILE5 <- parse.vdjtools(FILENAME5)
FILE6 <- parse.vdjtools(FILENAME6)
FILE7 <- parse.vdjtools(FILENAME7)
FILE8 <- parse.vdjtools(FILENAME8)
FILE9 <- parse.vdjtools(FILENAME9)
FILE10 <- parse.vdjtools(FILENAME10)
FILE11 <- parse.vdjtools(FILENAME11)
FILE12 <- parse.vdjtools(FILENAME12)

# Make a list of all files that come from one experiment
Experiment <- list("1" = FILE1, "2" = FILE2, "3" = FILE3, "4" = FILE4, "5" = FILE5, "6" = FILE6, "7" = FILE7, "8" = FILE8, "9" = FILE9, "10" = FILE10, "11" = FILE11, "12" = FILE12)

cloneset_stats <- cloneset.stats(Experiment)
# Make a file with information about clonesets of all samples
write.table(cloneset_stats, "tcR_cloneset_stats")
#Make file with information about all sequences, v-genes etc used
#write.table(FILE1, "Spleen NCD",sep = "\t", row.names=FALSE)
#write.table(FILE2, "Liver NCD",sep = "\t",row.names=FALSE)
#write.table(FILE3, "Spleen HF-HC",sep = "\t",row.names=FALSE)
#write.table(FILE4, "Liver HF-HC",sep = "\t",row.names=FALSE)

############ Abundance of clonotypes ############
# How many clonotypes fill up approximatley the 25% of the sum of values in 'Read.count'
# 'Read.count' is a header (column) inside the parsed IMGT FILE
clonal_proportion <- clonal.proportion(Experiment, 20)
write.table(clonal_proportion, "tcR_clonal_proportion")

############ Top-10 clonotypes ############
# Get a proportion of the top-10 clonotypes' reads to the overall number of reads
top_proportion <- top.proportion(Experiment, 10)
# Plot this
top_proportions_plot <- vis.top.proportions(Experiment)
ggsave("tcR_top_proportions_plot.pdf", top_proportions_plot)

############ Clonal space homeostasis ############
# How many space occupied by clonotypes with specific proportions?
# Compute summary space of clones, that occupy [0, .05] and [.05, 1] proportions
clonal_space <- clonal.space.homeostasis(Experiment, c(Rare = .001, Small = .01, Medium  = .1, Expanded = 1))
clonal_space_plot <- vis.clonal.space(clonal_space)
ggsave("tcR_clonal_space.pdf", clonal_space_plot)

#Calculate the total numbers of clones that are rare, small etc:
#Make clonal space homeostasis
immdata_space <- clonal_space

#Get general info on clonestats
immdata_info <- cloneset.stats(Experiment)

#turn numeric vectors into dataframes
immdata_info_df <- data.frame(immdata_info)
immdata_space_df <- data.frame(immdata_space)

#combine the relevant columns to calculate how many clones are rare, medium, etc in diversity
immdata_combined_info <- cbind(immdata_info_df$X.Aminoacid.clonotypes, immdata_space_df)
#create new columns that include the calculations of number of clones that are rare, small etc
immdata_combined_info$RareNumber <- immdata_combined_info$`immdata_info_df$X.Aminoacid.clonotypes` * immdata_combined_info$Rare..0...X....0.001.
immdata_combined_info$SmallNumber <- immdata_combined_info$`immdata_info_df$X.Aminoacid.clonotypes` * immdata_combined_info$Small..0.001...X....0.01.
immdata_combined_info$MediumNumber <- immdata_combined_info$`immdata_info_df$X.Aminoacid.clonotypes` * immdata_combined_info$Medium..0.01...X....0.1.
immdata_combined_info$ExpandedNumber <- immdata_combined_info$`immdata_info_df$X.Aminoacid.clonotypes` * immdata_combined_info$Expanded..0.1...X....1.
#the function ceiling() will just round the numbers, as they are all decimals. You might get 
#different total clone counts due to this rounding. It just only be off by 1 clone if at all.
immdata_combined_info <- ceiling(immdata_combined_info)

#This adds a column with total clone numbers calculated from the rare, small etc clones.
immdata_combined_info$TotalClones <- immdata_combined_info$RareNumber + immdata_combined_info$SmallNumber + immdata_combined_info$MediumNumber + immdata_combined_info$ExpandedNumber

#This will put together a new dataframe with the relevant information
immdata_clonotype_numbers <- cbind(row.names(immdata_combined_info), immdata_combined_info$RareNumber,
                                   immdata_combined_info$SmallNumber,
                                   immdata_combined_info$MediumNumber,
                                   
                                   immdata_combined_info$ExpandedNumber,
                                   immdata_combined_info$TotalClones,
                                   immdata_combined_info$`immdata_info_df$X.Aminoacid.clonotypes`)

#Add column names to the new dataframe
colnames(immdata_clonotype_numbers) <- c("Sample", "RareNumber", "SmallNumber", "MediumNumber", 
                                         "ExpandedNumber", "New_RoundedTotalClones", "OldTotalClones")

write.table(immdata_clonotype_numbers, "tcR_clonotype_numbers.txt", sep="\t", col.names=TRUE, row.names=FALSE)

############ Gene usage ############
# V-gene usage
vgene <- geneUsage(Experiment, HUMAN_TRBV)
vgene_plot <- vis.gene.usage(Experiment, HUMAN_TRBV, .main = 'Experiment V-usage dodge', .dodge= T)
ggsave("tcR_vgene.pdf", vgene_plot)

# J-gene usage
jgene <- geneUsage(Experiment, HUMAN_TRBJ)
jgene_plot <- vis.gene.usage(Experiment, HUMAN_TRBJ, .main = 'Experiment J-usage dodge', .dodge= T)
ggsave("tcR_jgene.pdf", jgene_plot)

############ Diversity of gene usage ############
# Entropy for V-genes
#vgene_entropy <- entropy.seg(Experiment, HUMAN_TRBV)
# Jensen-Shannon meassure for V-genes
#vgene_js <- js.div.seg(Experiment, HUMAN_TRBV, .verbose = F)
#vgene_js_plot <- vis.radarlike(vgene_js, .ncol=2)
#ggsave("tcR_vgene_js_plot.pdf", vgene_js_plot)

# Entropy for J-genes
#jgene_entropy <- entropy.seg(Experiment, HUMAN_TRBJ)
# Jensen-Shannon meassure for J-genes (IMPORTANT: Change Species 'Human_ or Mouse_TRBJ')
#jgene_js <- js.div.seg(Experiment, HUMAN_TRBJ, .verbose = F)
#jgene_js_plot <- vis.radarlike(jgene_js, .ncol=2)
#ggsave("tcR_jgene_js_plot.pdf", jgene_js_plot)

############ Repertoire overlap analysis ############
# Shared clonotypes among samples
#shared_clonotypes <- repOverlap(Experiment, 'exact', .seq= c("aa"), .vgene = F, .norm = F, .verbose = F)
#shared_clonotypes_plot <- vis.heatmap(shared_clonotypes, .title = 'Shared Clonotypes', .labs='', .legend = "# clonotypes")
#ggsave("tcR_shared_clonotypes.pdf", shared_clonotypes_plot)
#write.table(shared_clonotypes, "tcR_shared_clonotypes")

#Above heatmap is somehow not made, here is a different way
#See all overlap between the Clones
Experiment_sharedclones <- intersectClonesets(Experiment)
#Plot that into a Heatmap
heatmap <- vis.heatmap(Experiment_sharedclones, .title = 'Shared Clonotypes', .labs = '')
ggsave("tcR_Heatmapplot.pdf", heatmap)
write.table(Experiment_sharedclones, "tcR_Heatmap")
############ Evaluate the diversity of clones by the ecological diversity index ############


############ CDR3 Length and read count distribution plot ############
# Use own script for this graph
#CDR3_plot <- vis.count.len(Experiment[[1]], .name = "CDR3 Lenghts", .col ="Read.count")
#ggsave("tcR_CDR3_plot.pdf", CDR3_plot)

########## Do a stacked bar graph with Solai's script (not tcR) #############
# Create a function that will ask the user for sample number

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
write.table(ChaoIndex, "tcR_div_Chao.txt", sep="\t", col.names=TRUE, row.names=TRUE)

