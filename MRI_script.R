#**************************************#
# Script to graph FD and head position #
#**************************************#

#Import displacement data
#prefiltered_func_data_mcf <- read.table("~/nethome/Script/prefiltered_func_data_mcf.txt", quote="\"", comment.char="")
prefiltered_func_data_mcf <- read.table("~/nethome/hcp_example/example3/task-rest_run-AP_01_bold_mc.par")
#View(prefiltered_func_data_mcf)

#Find the size of the displacement data set
size_data <- dim(prefiltered_func_data_mcf)

#Initialize a vector to hold FD values
FD <- matrix(0, size_data[1],1)
#Find the change in displacement of every value in each row and add them to find the FD value for that row
for (data_row in c(2:size_data[1])){ #Exclude the first row
  for (data_col in c(1:size_data[2])){
    delta_x <- prefiltered_func_data_mcf[data_row, data_col] - prefiltered_func_data_mcf[(data_row - 1), data_col]
    if (data_col < 4){
    delta_x <- delta_x * (50*2*pi)/360
    }
    delta_x <- abs(delta_x)
    FD[data_row] <- FD[data_row] + delta_x
  }
}

#Finding head position
#x <- array(0, dim = c(size_data[1],1,1))
#y <- array(0, dim = c(size_data[1],1,1))
#x <- array(0, dim = c(size_data[1],1,1))

#Plot the data
frames <- c(1:size_data[1])
plot(frames, FD, type = "n", xlab = "Frames", ylab = "FD (mm)")
lines(frames, FD)

library(ggplot2)
prefiltered_func_data_mcf$FD<-FD[,1,1]
prefiltered_func_data_mcf$time<-1:dim(prefiltered_func_data_mcf)[1]
prefiltered_func_data_mcf$id<-1:dim(prefiltered_func_data_mcf)[1]

prefiltered_func_data_mcf.long<-reshape(prefiltered_func_data_mcf, idvar='id',varying = list(1:7), v.names='mov', direction = 'long') 

ggplot(prefiltered_func_data_mcf.long,aes(x=id,y=mov,colour=factor(time)))+
  geom_point()+
  geom_line()
FD[,,1]

