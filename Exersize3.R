library(stringdist)
library(stringr)
library(rlang)
library(tidyverse)
library(magrittr)

# Set the working directory - NOTE the use of backslash
setwd("C:/Users/Rob/Documents/git/Ex3")


## Get the column names from the text file, then transform them to a unnamed list
colNames <- read.table(file="./Dataset/UCI HAR Dataset/features.txt")
colNames <- as.character(unname(unlist(colNames[,2])))
colNames <- make.names(colNames, unique = TRUE) #make unnique names

tbActivity <- read.table(file="./Dataset/UCI HAR Dataset/activity_labels.txt", 
                        col.names = c("ActivityLabel", "ActivityName"))


# List with the 2 txt files,including sub-folders path
list_of_files <- list.files(path = ".", recursive = TRUE,
                            pattern = "*_train.txt|*_test.txt",  full.names = TRUE)

list_of_files <- list.files(path = ".", recursive = TRUE,
                            pattern = "^[X|y]_train.txt|^[X,y]_test.txt|^subject",  full.names = TRUE)

####
# list of participants
inputFile <- list_of_files[1]
DataTestSubject <- read.table(inputFile, header=FALSE, col.names = "Paricipant")
inputFile <- list_of_files[4]
DataTrainSubject <- read.table(inputFile, header=FALSE, col.names = "Paricipant")

theSubjects <- bind_rows(DataTrainSubject, DataTestSubject)

# list of Activities
inputFile <- list_of_files[3]
DataTestActivity <- read.table(inputFile, header=FALSE, col.names = "ActivityLabel")
inputFile <- list_of_files[6]
DataTrainActivity <- read.table(inputFile, header=FALSE, col.names = "ActivityLabel")

theActivity <- bind_rows(DataTrainActivity, DataTestActivity)
theActivity <- merge(theActivity, tbActivity, by = "ActivityLabel", sort = FALSE)

# join participants and subjects
theActSubjects <- bind_cols(theActivity, theSubjects)



####################################################################
# Read in and Merge the train and test data sets

inputFile <- list_of_files[2]
DataTest <- read.table(inputFile,header=FALSE,col.names = colNames)

inputFile <- list_of_files[5]
DataTrain <- read.table(inputFile,header=FALSE,col.names = colNames)

theData <- bind_rows(DataTrain, DataTest)

#####################################################################
# 

## make a mean and std deviation for each measurement... really?


#############################################################################################
#This approach is garbage, but I could not figure out how to change the size of the dataframe 
#and fill it with data, I'm pretty confident I'm missunderstanding the statement
#"make a mean and std-dev" for each measurement, but practice is good anyway
# 

df_mean <- as.data.frame(lapply(theData,  mean))
df_mean_row <- df_mean
p <- progress_estimated(nrow(theData))

for (i in 1:(nrow(theData)-1)) {
  df_mean <- bind_rows(df_mean, df_mean_row)
  p$tick()$print()
}

  
#create new "mean" column names
varname_ls <- character(length(theData))

for(i in 1:length(theData)) {
  varname <- paste("mean", colNames[i], sep="_")
  varname_ls[i] <- varname
}
varname_ls <- as.vector(varname_ls)

#change the names for the data
df_mean <- set_names(df_mean, varname_ls)


###############################################################################################
# I've left this unfinished untill I get clarity on the instructions




