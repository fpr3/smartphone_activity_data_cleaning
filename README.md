Characteristic | Value 
---: | --- 
title: | README
author: | FPR
created: | September 23, 2015
revised: | February 21, 2022
output: | html_document

---

## Course Project for Getting and Cleaning Data ##
September 2015 Session; Johns Hopkins University via Coursera

### Overview ###
The contents of this repository represent original work in satisfaction of the requirements of the course project noted above. The project focuses on the emergence of wearable personal health and fitness monitors as an interesting real-world source of data appropriate for demonstration of the objectives of this course on *Getting and Cleaning Data*. The project objective is to collect and process data from raw sources into a tidy format appropriate for further analysis.

The following sections will briefly discuss the data and then detail the work of the related code that transforms the source/raw data into our final tidy dataset which is written to a text file so that it can be immediately ready for loading by most analytical software or easily read into other programs.

### Data Resources ###

#### Raw Data ####
The raw data is obtained from work submitted to the UCI Machine Learning Repository. The original project work is detailed in work entitled [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#). A substantial amount of material is available there describing their data which includes inertial sensor data, preprocessed time and frequency domain variables, subject and activity identifiers and descriptions, and documentation detailing the collection, filtering, and preprocessing undertaken to arrive at the data present there.

Of primary interest for our purposes are the subject identifiers, the activity code and label information, and the 561-feature dataset containing the output of their collection and preprocessing efforts. The raw inertial data is not useful for our purposes.

#### Tidy Data Output ####
The output file from the run_analysis.R code in this repository consists of 180 observations of 81 variables presented in consistent fashion with the tidy data parameters. The 180 observations corresponds to a single record for each of the 30 test subjects across each of the 6 activities studied per participant. The 81 variables presented encompass one each to identify the subject and activity, and 79 variables selected from the preprocessed measurements discussed above. 

The 79 variables included in this tidy data set each represent the mean of all values recorded for that variable by a particular subject while performing a particular activity. The activities comprise Walking, Walking Up Stairs, Walking Down Stairs, Standing, Sitting, and Laying. 

The selection criteria for the variables included were specified as only including those measurements pertaining to "mean" or "std" values in the data given. As such only those with either of those terms in the descriptive title were included. One caveat is that inclusion of the measures with meanFreq was maintained despite not being entirely clear whether this data would be useful. It can be later discarded more easily than created if necessary. None of the angle measure were included as these did not make sense in context of the rest of the data. In a typical engagement, this avenue would have been raised for discussion rather than making unilateral and somewhat arbitrary decisions. However, the full purpose of this project is satisfied with the inclusion of 79 separate variables appropriately constructed and documented.

#### Codebook ####
The repository includes a Codebook.md markdown file with specific information pertaining to each variable in the tidy data output by this project.

### Generating the Tidy Data ###
A script run_analysis.R is included to perform all necessary and sufficient steps to manipulate the raw data files into a format consistent with tidy data principles and then write that dataset to a text file for easy distribution, and in this case submission for grading. 

The script first retrieved the [master zip archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) from the repository if it is not already present in the working directory. In the process it is more conveniently named samsung.zip reflecting the origin of the data. This file is then extracted undernneath the working directory.

The activity labels are read from an activity_labels.txt file in the archive and the feature column titles are read from a features.txt file. The features.txt descriptions are all cleaned by removing the extra punctuation and separating with underscores where appropriate. This both makes for more readable variable names and ensures that the names are legal R names.These files are read up front because these parameters will be used in processing both the test and train data before the entire set is reconstituted. While the feature names are also used to identify the list of "mean" and "std" variables retained in the output data, this action is deferred until after the columns are populated in case further selection criteria should be later desired based on the contents of the variables.

The test data and training data are handled sequentially in like fashion. The subject data, the measurement data, and the activity data are retrieved from three separate files easily identified by subject, x, and y prefixes respectively in each of the test and train subdirectories. Appropriate column names are applied at this time. Next the columns of interest (mean and std related cols) are identified as keepcols so that the data portion can be pulled together. The subject, activity, and selected measurements are bound together columnwise to form each portion of the final dataset. The cbind function was used in particular to avoid potential problems with the merge function reordering the data.

Once the test and train data are separately processed, an intermediate tidy dataset is formed by using rbind to join these two sets row-wise into a single dataframe with all of the relevant data for the selected set of variables. 

Finally, dplyr functionality is used to group the data by subject and activity before calculating the mean of each variable across these groups. The result is recorded to the file "tidyoutput.txt" using the R write.table() function with parameter "row.name = FALSE" as specified to prevent any row names from appearing in the output file.

### References ###
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

UCI Machine Learning Repository; Human Activity Recognition Using Smartphones Data Set  
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)
