# Getting and Cleaning Data Course Project
#
# 9/23/2015
#
# This project collects, cleans and processes a dataset from multiple files
# to output a single tidy dataset ready for further analysis. The source data 
# is taken from the UCI machine learning repository and can be found here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
# The following operations are performed by the code below. Since the order is 
# not maintained, each step is identified in the comments both by description
# and by inclusion of its number below in parenthesis at the end of the comment
# line. All steps are completed and the output is consistent with expectations.
# 
# Required operations:
#    1. Merges the training and the test sets to create one data set.
#    2. Extracts only the measurements on the mean and standard deviation for 
#       each measurement.
#    3. Uses descriptive activity names to name the activities in the data set
#    4. Appropriately labels the data set with descriptive variable names.
#    5. From the data set in step 4, creates a second, independent tidy data 
#       set with the average of each variable for each activity and each 
#       subject.
#
#  The final dataset created is then written to a text file that is submitted.
#
###############################################################################


# Prepare files (downloading if necessary)
archivefile <- "samsung.zip"
if(!file.exists(archivefile)){
        temp <- tempfile()
        download.file(
                "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                ,temp)
        file.copy(temp,archivefile)
        unlink(temp)
        rm(temp)
}
unzip(archivefile)
rm(archivefile)

# Load common files & make preparations used by both Test and Train Data
#     Activity Labels information
activityDefs <- read.table("./UCI HAR Dataset/activity_labels.txt")
#     Features Names
measuresLabels <- read.table("./UCI HAR Dataset/features.txt")
#     Make column names more readable and descriptive
measuresLabels$V2 <- gsub("_$","", gsub("[[:punct:]]+(*)+","_",measuresLabels$V2))


# Retrieve Test Data 
# 
# Appropriately label the data set with descriptive variable names. (4)
activityData <- read.table("./UCI HAR Dataset/test/y_test.txt",
                           col.names = "ActivityCode")

# Uses descriptive activity names to name the activities in the data set (3)
# Apply Activity Labels text descriptions from file in place of codes.
activityData$ActivityLabel <- activityDefs[match(activityData$ActivityCode, 
                                                 activityDefs$V1),"V2"]
# Load subjects matching Test Data
# Appropriately label the data set with descriptive variable names. (4)
subjectData <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                          col.names = "Subject")

# Load preprocessed Testing measurements
# Appropriately label the data set with descriptive variable names. (4)
measuredData <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                           col.names = measuresLabels$V2)

# Extracts only the measurements on the mean and standard deviation for 
# each measurement. (2)
#       NOTE: Includes freqMean but not Angle measures
keepcols = c(grep("mean", names(measuredData)), 
             grep("std", names(measuredData)))

# Combine Test Data parts
testdata <- cbind( subjectData, 
                   Activity = activityData$ActivityLabel,
                   measuredData[,keepcols])
rm(activityData, measuredData, subjectData)
rm(keepcols)

# Retrieve Training Data
#
# Appropriately label the data set with descriptive variable names. (4)
activityData <- read.table("./UCI HAR Dataset/train/y_train.txt",
                           col.names = "ActivityCode")

# Uses descriptive activity names to name the activities in the data set (3)
# Applied Activity Labels text descriptions from file in place of codes.
activityData$ActivityLabel <- activityDefs[match(activityData$ActivityCode, 
                                                 activityDefs$V1),"V2"]

# Load subjects matching Training Data
# Appropriately label the data set with descriptive variable names. (4)
subjectData <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                          col.names = "Subject")

# Load preprocessed Training measurements
# Appropriately label the data set with descriptive variable names. (4)
measuredData <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                           col.names = measuresLabels$V2)

# Extract only the measurements on the mean and standard deviation for 
# each measurement. (2)  
#     NOTE: Includes freqMean but not Angle measures
keepcols = c(grep("mean", names(measuredData)), grep("std", 
                                                     names(measuredData)))

# Combine Training Data parts
traindata <- cbind(subjectData,Activity = activityData$ActivityLabel,
                   measuredData[,keepcols])
rm(activityData, measuredData, subjectData)

# Merge the training and the test sets to create one data set. (1)
tidy <- rbind(traindata,testdata)

# From the constructed data set (steps 1-4), creates a second, independent 
# tidy data set with the average of each variable for each activity and 
# each subject. (5)
library(dplyr)
tidy2 <- tidy %>% 
        group_by(Subject,Activity) %>% 
        summarise_each(funs(mean),-Subject,-Activity)

# Generate final text file to submit
write.table(tidy2, file = "tidyoutput.txt", row.name=FALSE)

# Cleanup Intermediate Variables
rm(activityDefs, measuresLabels, keepcols, testdata, traindata)
