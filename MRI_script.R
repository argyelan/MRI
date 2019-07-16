#Script to graph FD and head position

#Import displacement data
prefiltered_func_data_mcf <- read.table("~/nethome/Script/prefiltered_func_data_mcf.txt", quote="\"", comment.char="")
    #View(prefiltered_func_data_mcf)

#Find the size of the displacement data set
size_data <- dim(prefiltered_func_data_mcf)

#Initialize the vector to hold FD values
FD <- array(0, dim = c(size_data[1],1,1))
#Find the change in displacement of every value in each row and add them to find the FD value for that row
for (data_row in 2:size_data[1]){ #Exclude the first row
  for (data_col in 1:size_data[2]){
    delta_x <- prefiltered_func_data_mcf[data_row, data_col] - prefiltered_func_data_mcf[data_row - 1, data_col]
    if (data_col < 4){
    delta_x <- delta_x * 50
    }
    delta_x <- abs(delta_x)
    FD[data_row] <- FD[data_row] + delta_x
  }
}
#Plot the data
frames <- array(1:size_data[1], dim = c(size_data[1],1,1))
plot(frames, FD, type = "n", xlab = "Frames", ylab = "FD (mm)")
lines(frames, FD)