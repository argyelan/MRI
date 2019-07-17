#Calculating pairwise correlation of 4D MRI image

file <- '/nethome/rkim/hcp_example/example3/Nodes.nii' #Import data
x <- paste0('fslstats ',file,' -R')
print(x)
range <- as.numeric(strsplit(system(x, intern = TRUE),' ')[[1]]) #Run bash command to find range of intensities

img4D <- '/nethome/rkim/hcp_example/example3/GSR_preprocessed_ses-22921_task-rest_acq-AP_run-01_bold_hp2000_clean.nii.gz'
x <- paste0('/nethome/rkim/Script/bin/corr_matrix.sh ',file,' ', img4D,' ',range[1],' ', range[2])

setwd('/nethome/rkim/Script/DataFolder')

system(x) #Run bash script to create correlation matrices

filenames <- list.files(full.names = TRUE)
dataFile <- do.call("cbind", lapply(filenames, read_csv))

pair_corr <- matrix(cor(allFiles, use = "complete.obs", method = "pearson"))
