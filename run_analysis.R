library(dplyr)

# read train data
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read data description
features <- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

## I'm giving descriptive names to columns before start working on merge to better understand the datasets read.
#3. Uses descriptive activity names to name the activities in the data set
colnames(Xtrain) = features[,2]
colnames(Xtest) = features[,2]
colnames(Ytrain) = "activityId"
colnames(Ytest) = "activityId"
colnames(Subtrain) = "subjectId"
colnames(Subtest) = "subjectId"
colnames(activities) = cbind("activityId", "activityType")

#1. Merges the training and the test sets to create one data set.
merged_train = cbind(Xtrain, Ytrain, Subtrain)
merged_test = cbind(Xtest, Ytest, Subtest)
merged_dataset = rbind(merged_train, merged_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanstd = grepl("activityId|subjectId|mean\\(\\)|std\\(\\)" , colnames(merged_dataset))
setMeanStd <- merged_dataset[ , meanstd == TRUE]

# 4. Uses descriptive activity names to name the activities in the data set
setWithActivityNames = merge(setMeanStd, activities, by='activityId', all.x=TRUE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyDataSet <- subset(setWithActivityNames, select = -activityId) %>% group_by(activityType, subjectId) %>% summarize_all(funs(mean))

write.table(tidyDataSet, file = "./tidydataset.txt", row.names = FALSE, col.names = TRUE)

