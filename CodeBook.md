# CodeBook for Project 
This code book describes the project of getting and cleaning data in R.

By running the script ***run_analysis.R*** the file ***tidy_data.txt*** is generated, using as input the original data that can be download from next url https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip script execution automatically downloads the zip file.

***tidy_data.txt*** is a plain txt file, all fields are separated by ***,*** (comma)

Information about original data set can be found in next url http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


## Process
1. Load training and the test data files.
2. Merge the training and the test data sets to creating one data set.
3. Extracts only the measurements on the mean and standard deviation for each measurement.
4. Using descriptive activity names to rename the activities in the merged data set.
5. Appropriately labels the merged data set with descriptive variable names.
6. Using merged data set, is created the final, independent tidy data set with the average of each variable for each activity and each subject.
