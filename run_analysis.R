# getting and cleaning data

setwd("~/Desktop/Coursera/Data Analysis Specialization/Getting and Cleaning Data/Project")

trainX = read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
trainY = read.table("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
trainSubject = read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

train=cbind(trainX,trainY,trainSubject)

testX = read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testY = read.table("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testSubject = read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

test=cbind(testX,testY,testSubject)

# Merge training and test sets 
MergedData = rbind(train, test)

activityLabels = read.table("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

features = read.table("UCI HAR Dataset/features.txt", sep="", header=FALSE)

# created more readable variable names
features$V2 = gsub('-mean', 'Mean', features$V2)
features$V2 = gsub('-std', 'Std', features$V2)
features$V2 = gsub('[-()]', '', features$V2)

# Get Mean and SD data
MeanSD <- grep(".*Mean.*|.*Std.*", features$V2)

# extract Mean and SD from features
features <- features[MeanSD,]

# add subject and activity column (562,563)
MeanSD <- c(MeanSD, 562,563)

# remove unwanted columns from MergedData
MergedData <- MergedData[,MeanSD]

# add column names to MergedData
colnames(MergedData) <- c(features$V2, "Activity", "Subject")
colnames(MergedData) <- tolower(colnames(MergedData))

# summarize mean of each variable for each subject and activity 
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  MergedData$activity <- gsub(currentActivity, currentActivityLabel, MergedData$activity)
  currentActivity <- currentActivity + 1
}

MergedData$activity <- as.factor(MergedData$activity)
MergedData$subject <- as.factor(MergedData$subject)

tidy = aggregate(MergedData, by=list(activity = MergedData$activity, subject=MergedData$subject), mean)

# Remove subject and activity column (no mean)
ncol(tidy)
tidy = tidy[,-c(89,90)]

write.csv(tidy, "tidy.csv")
