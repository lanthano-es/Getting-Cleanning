
# Code BOOK

> My level of English is very low, Excuse me for the mistakes will commit

## List of main data frames and description:
* df.activity: list of activities, cols desc: codActivity, nameActivity.
* df.features: list of features, cols desc: codFeature, nameFeature.

* df.test: test data set, col desc: activities + subject + see description in [features info file](https://github.com/lanthano-es/Getting-Cleanning.git/FeaturesInfoFile.txt). 
* df.testlavels:  list of lavels of test data set, col desc: X1  (code of activities)
* df.testsubject: list of subject of test data set, col desc: X1 (code of subject)

* df.train: list of lavels, col desc: activities + subject + see description in [features info file](https://github.com/lanthano-es/Getting-Cleanning.git/FeaturesInfoFile.txt). 
* df.trainlavels: list of lavels of train data set, col desc: X1  (code of activities)
* df.trainsubject: list of subject of train data set, col desc: X1  (code of subject)

* df.all: complete data set, col desc: activities + subject + see description in [features info file](https://github.com/lanthano-es/Getting-Cleanning.git/FeaturesInfoFile.txt). 

* df.partial: subset of complete data set's rows: activities + subject + only the measurements on the mean and standard deviation for each measurement.

* df.partialMean: independent tidy data set with the average of each variable for each activity and each subject.

## TRANSFORMATIONS:

### LOADING THE DATA SETS:

### Download the datafile:
> fileUrl= "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
download.file(fileUrl, destfile = "./Dataset.zip");
unzip("./Dataset.zip");

### Load the ActivityLavels:
> df.activity <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE );
names(df.activity)[1]<-"codActivity";
names(df.activity)[2]<-"nameActivity";

### Load the featuresLavels:
> df.features <- read.csv("./UCI HAR Dataset/features.txt", sep=" ", header=FALSE );
names(df.features)[1]<-"codFeature"; 
names(df.features)[2]<-"nameFeature";

### Load the test data and combine with laveles and subject data:
> df.test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep=" ", header=FALSE );
df.testlavels <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep=" ");
df.testsubject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep=" ");
names(df.test)<-df.features[,"nameFeature"];
minRows<- min(dim(df.testlavels)[1], dim(df.testsubject)[1], dim(df.test)[1] )
df.test <- cbind(activities=df.testlavels[1:minRows,],subject=df.testsubject[1:minRows,],df.test[1:minRows,])

### Load the train data and combine with laveles and subject data:
> df.train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep=" ", header=FALSE );
df.trainlavels <- read.csv("./UCI HAR Dataset/train/y_train.txt");
df.trainsubject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep=" ");
names(df.train)<-df.features[,"nameFeature"];
minRows<- min(dim(df.trainlavels)[1], dim(df.trainsubject)[1], dim(df.train)[1] )
df.train <- cbind(activities=df.trainlavels[1:minRows,],subject=df.trainsubject[1:minRows,],df.train[1:minRows,])

### 1.GOAL: Merges the training and the test sets to create one data set.
> minFeatures <- 1;
maxFeatures <- 2+dim(df.features)[1]; ##add 2 more to add activities and subject cols 
df.all <-rbind(df.train[,minFeatures:maxFeatures],df.test[,minFeatures:maxFeatures]);

### 2.GOAL: Extracts only the measurements on the mean and standard deviation for each measurement
> indexColumn <- c(grep("-mean()", names(df.all)), grep("-std()", names(df.all)))
df.partial<-df.all[,indexColumn];
names(df.partial)

## 3.GOAL: Uses descriptive activity names to name the activities in the data set
> indexColumn <- c(grep("activities", names(df.all)), grep("subject", names(df.all)),grep("-mean()", names(df.all)), grep("-std()", names(df.all)))
df.partial<-df.all[,indexColumn];
for(i in seq(1:dim(df.activity)[1])){ 
    indexactivity <- df.partial[,"activities"]==i;
    df.partial[indexactivity,][,"activities"]<-as.character(df.activity[i,"nameActivity"]);
};

### 4.GOAL: Appropriately labels the data set with descriptive variable names. 
> names(df.partial);


### 5.GOAL: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> library(dplyr);
df.partialMean <- ddply(df.partial, c("activities","subject"), numcolwise(mean, na.rm = TRUE));
write.table(df.partialMean, file = "./dataProject.csv", sep = ",", row.name=FALSE);





