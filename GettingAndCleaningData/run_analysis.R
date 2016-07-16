##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Bharadwaj Venkateswaran
## 11/21/2014

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################
# 1. Merge the training and the test sets to create one data set.
##########################################################################################################

# Clean up workspace
rm(list=ls())

#Import library data.table
library(data.table)
library(plyr)

#Read activity_labels.txt and edit column names
dtActivityLabel<-data.table(read.table("activity_labels.txt",header=FALSE))
colnames(dtActivityLabel)=c('activityId','activityType');

#Read features.txt
dtFeatures<-data.table(read.table("features.txt",header=FALSE))

#Read subject_train.txt and edit column names
dtSubjectTrain<-data.table(read.table("train/subject_train.txt",header=FALSE))
colnames(dtSubjectTrain)=c('subjectId');

#Read y_train.txt and edit column names
dtyTrain<-data.table(read.table("train/y_train.txt",header=FALSE))
colnames(dtyTrain)="activityId";

#Read X_train.txt and edit column names; each row is a vector from feature.txt
dtXTrain<-data.table(read.table("train/X_train.txt",header=FALSE))
colnames(dtXTrain)<-as.character(dtFeatures[,V2]);

#creating a merged dataset: trainingData 
trainingData<-cbind(dtSubjectTrain,dtyTrain,dtXTrain)

############################################################################################################

#Read subject_test.txt and edit column names
dtSubjectTest<-data.table(read.table("test/subject_test.txt",header=FALSE))
colnames(dtSubjectTest)="subjectId";

#Read y_test.txt and edit column names
dtyTest<-data.table(read.table("test/y_test.txt",header=FALSE))
colnames(dtyTest)<-"activityId";

#Read X_test.txt and edit column names; each row is a vector from feature.txt
dtXTest<-data.table(read.table("test/X_test.txt",header=FALSE))
colnames(dtXTest)<-as.character(dtFeatures[,V2]);

#creating a merged dataset: testData 
testData<-cbind(dtSubjectTest,dtyTest,dtXTest)

############################################################################################################

# Combine training and test data to create a final data set
finalData = rbind(trainingData,testData);

############################################################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
############################################################################################################

#place all the column names in a colNames vector
colNames<-colnames(finalData)
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));
#logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("mean\\(\\)|std\\(\\)",colNames));
finalData<-finalData[,logicalVector,with=FALSE]

############################################################################################################
# 3. Use descriptive activity names to name the activities in the data set
############################################################################################################

#merging finalData and activity data tables
finalData = merge(finalData,dtActivityLabel,by='activityId');

############################################################################################################
# 4. Appropriately label the data set with descriptive activity names.
############################################################################################################
#replacing short names with meaningful names
colNames<-colnames(finalData)
for (i in 1:length(colNames)){ 
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std()","-StandardDeviation",colNames[i])
  colNames[i] = gsub("-mean()","-Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("Acc","Accelerometer",colNames[i])
  colNames[i] = gsub("Mag","Magnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccelerometerJerkMagnitude",colNames[i])
  colNames[i] = gsub("Jerk","Jerk",colNames[i])
 }

######################################################################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################################################################################################################

colnames(finalData) = colNames;
setkey(finalData,activityId,subjectId)
dtTidyDS <- ddply(finalData, .(activityId, subjectId), numcolwise(mean))
write.table(dtTidyDS, file="tidy.txt", sep = "\t", row.name = F)
