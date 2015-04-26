## COURSE: Getting and Cleaning Data
## student: lanthano, fgonzalezalonso@outlook.es
## 
## NOTE: My level of English is low, Excuse me for the mistakes will commit in the comments.
## 
## Targets:

## Here are the data for the project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Download the datafile:
fileUrl= "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
download.file(fileUrl, destfile = "./Dataset.zip");
unzip("./Dataset.zip");

## Load the ActivityLavels:
df.activity <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE );
names(df.activity)[1]<-"codActivity";
names(df.activity)[2]<-"nameActivity";

## Load the featuresLavels:
df.features <- read.csv("./UCI HAR Dataset/features.txt", sep=" ", header=FALSE );
names(df.features)[1]<-"codFeature";
names(df.features)[2]<-"nameFeature";
dim(df.features)

## Load the test data and combine with laveles and subject data:
df.test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep=" ", header=FALSE );
df.testlavels <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep=" ");
df.testsubject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep=" ");

names(df.test)<-df.features[,"nameFeature"];

minRows<- min(dim(df.testlavels)[1], dim(df.testsubject)[1], dim(df.test)[1] )
df.test <- cbind(activities=df.testlavels[1:minRows,],subject=df.testsubject[1:minRows,],df.test[1:minRows,])

dim(df.test)
names(df.test);

## Load the train data and combine with laveles and subject data:
df.train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep=" ", header=FALSE );
df.trainlavels <- read.csv("./UCI HAR Dataset/train/y_train.txt");
df.trainsubject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep=" ");

names(df.train)<-df.features[,"nameFeature"];

minRows<- min(dim(df.trainlavels)[1], dim(df.trainsubject)[1], dim(df.train)[1] )
df.train <- cbind(activities=df.trainlavels[1:minRows,],subject=df.trainsubject[1:minRows,],df.train[1:minRows,])
dim(df.train)
names(df.train);

## 1.GOAL: Merges the training and the test sets to create one data set.
minFeatures <- 1;
maxFeatures <- 2+dim(df.features)[1]; ##add 2 more to add activities and subject cols 
df.all <-rbind(df.train[,minFeatures:maxFeatures],df.test[,minFeatures:maxFeatures]);

## 2.GOAL: Extracts only the measurements on the mean and standard deviation for each measurement
indexColumn <- c(grep("-mean()", names(df.all)), grep("-std()", names(df.all)))
df.partial<-df.all[,indexColumn];
names(df.partial)

## 3.GOAL: Uses descriptive activity names to name the activities in the data set
indexColumn <- c(grep("activities", names(df.all)), grep("subject", names(df.all)),grep("-mean()", names(df.all)), grep("-std()", names(df.all)))
df.partial<-df.all[,indexColumn];

for(i in seq(1:dim(df.activity)[1])){ 
    indexactivity <- df.partial[,"activities"]==i;
    df.partial[indexactivity,][,"activities"]<-as.character(df.activity[i,"nameActivity"]);
};

## 4.GOAL: Appropriately labels the data set with descriptive variable names. 
names(df.partial);


## 5.GOAL: From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
library(dplyr);
df.partialMean <- ddply(df.partial, c("activities","subject"), numcolwise(mean, na.rm = TRUE));

## Assign the new names to columns
names(df.partialMean) <- paste("mean-",names(df.partialMean));
names(df.partialMean)[1]<- "activities";
names(df.partialMean)[2]<- "subject";
names(df.partialMean)

## Save the data set to file
write.table(df.partialMean, file = "./dataProject.csv", sep = ",", row.name=FALSE);
