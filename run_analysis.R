

Peer-graded Assignment: Getting and Cleaning Data Course Project.

Load the dplyr library



library(dplyr)


## Download the dataset



if(!file.exists("project")){
        dir.create("project")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = ".//project/humanActivity.zip", method = "curl")

## unzip human activity file data



unzip(".//project/humanActivity.zip") 



## Assigning all the text file in data frames


allFeatures <- read.table("UCI HAR Dataset/features.txt", col.names = c("serialNo","features"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Key", "activities"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train<- read.table("UCI HAR Dataset/train/x_train.txt", col.names = allFeatures$features)
y_train<- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "key")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test<- read.table("UCI HAR Dataset/test/x_test.txt", col.names = allFeatures$features)
y_test<- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "key")


### Merged individual table and form one


X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.



meanAndSTD <- Merged_Data %>% select(subject, key, contains("mean"), contains("std"))




dim(Merged_Data)


### colnames in the merged data




meanAndSTD$key <- activity_labels[meanAndSTD$key, 2]


### Appropriately labels the data set with descriptive variable names.


names(meanAndSTD)[2] = "activity"
names(meanAndSTD)<-gsub("Acc", "Accelerometer", names(meanAndSTD))
names(meanAndSTD)<-gsub("Gyro", "Gyroscope", names(meanAndSTD))
names(meanAndSTD)<-gsub("BodyBody", "Body", names(meanAndSTD))
names(meanAndSTD)<-gsub("Mag", "Magnitude", names(meanAndSTD))
names(meanAndSTD)<-gsub("^t", "Time", names(meanAndSTD))
names(meanAndSTD)<-gsub("^f", "Frequency", names(meanAndSTD))
names(meanAndSTD)<-gsub("tBody", "TimeBody", names(meanAndSTD))
names(meanAndSTD)<-gsub("-mean()", "Mean", names(meanAndSTD), ignore.case = TRUE)
names(meanAndSTD)<-gsub("-std()", "STD", names(meanAndSTD), ignore.case = TRUE)
names(meanAndSTD)<-gsub("-freq()", "Frequency", names(meanAndSTD), ignore.case = TRUE)
names(meanAndSTD)<-gsub("angle", "Angle", names(meanAndSTD))
names(meanAndSTD)<-gsub("gravity", "Gravity", names(meanAndSTD))




### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



FinalData <- meanAndSTD %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(FinalData, "FinalData.text", row.name=FALSE)

