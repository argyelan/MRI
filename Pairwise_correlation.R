#Calculating pairwise correlation of 4D MRI image

library(data.table)
library(corrplot)

file <- '/nethome/rkim/hcp_example/example3/Nodes.nii' #Import data
x <- paste0('fslstats ',file,' -R')
print(x)
range <- as.numeric(strsplit(system(x, intern = TRUE),' ')[[1]]) #Run bash command to find range of intensities

img4D <- '/nethome/rkim/hcp_example/example3/GSR_preprocessed_ses-22921_task-rest_acq-AP_run-01_bold_hp2000_clean.nii.gz'
x <- paste0('/nethome/rkim/Script/bin/corr_matrix.sh ',file,' ', img4D,' ',range[1],' ', range[2])

setwd('/nethome/rkim/Script/DataFolder') #work directory where matrices will be stored

system(x) #Run bash script to create correlation matrices

filenames <- list.files(full.names = FALSE) #Find all matrices
info = file.info(filenames)
good = rownames(info[info$size > 0, ]) #Keep only matrices that have values in them

dataFile <- do.call("cbind", lapply(good, read.csv, header = FALSE)) #Create the data file from the csv files
oldnames <- colnames(dataFile)
oldnames <- make.unique(oldnames, sep = ".")
colnames(dataFile) <- oldnames

dataFile <- data.table(dataFile)

meanData <- dataFile[,lapply(.SD, mean)]
pair_corr <- cor(dataFile, use = "complete.obs", method = "pearson")

corrplot(pair_corr, method = "circle")te.obs", method = "pearson"))
