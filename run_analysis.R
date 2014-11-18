# Download and unpack data

if (!file.exists("Dataset.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                  method = "curl", destfile = "Dataset.zip")
}

if (!file.exists("UCI HAR Dataset")) {
    unzip("Dataset.zip")
}

# Load training and test data

XTrain <- as.data.frame(read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, blank.lines.skip = TRUE, dec = "."))
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, blank.lines.skip = TRUE)
subjTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, blank.lines.skip = TRUE)

XTest <- as.data.frame(read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, blank.lines.skip = TRUE, dec = "."))
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, blank.lines.skip = TRUE)
subjTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, blank.lines.skip = TRUE)

featureLabels <- read.table("UCI HAR Dataset/features.txt", header = FALSE, blank.lines.skip = TRUE, col.names = c("id", "label"))
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, blank.lines.skip = TRUE, col.names = c("id", "label"))

# Assign feature labels to datasets (ordered by id, to ensure correct order)
orderedFeatureLabels <- featureLabels[order(featureLabels$id), ][["label"]]
names(XTrain) <- orderedFeatureLabels
names(XTest) <- orderedFeatureLabels

# Append subject and activity label to data sets
XTrain$subject <- subjTrain[[1]]
XTrain$label <- yTrain[[1]]
XTrain$type <- 1

XTest$subject <- subjTest[[1]]
XTest$label <- yTest[[1]]
XTest$type <- 2

# Merge two datasets
completeBase <- rbind(XTrain, XTest)
completeBase$type <- factor(completeBase$type, labels = c("Train", "Test"))

orderedActivityLabels <- activityLabels[order(activityLabels$id), ][["label"]]
completeBase$label <- factor(completeBase$label, labels = orderedActivityLabels)

rm("XTrain", "XTest")

# Load dplyr and convert data to data table
library(dplyr)

compBase <- tbl_df(completeBase)
compBase <- compBase[, !duplicated(names(compBase))]
filteredBase <- compBase[, grepl("[Ss]td|[Mm]ean|label|subject", names(compBase))]
names(filteredBase) <- make.names(names(filteredBase))

# Group by activity and subject
byActivityAndSubject <- group_by(filteredBase, label, subject)

# Calculate mean value for each activity and subject
grouppedMeans <- summarise_each(byActivityAndSubject, funs(mean))

# Output the result
write.table(grouppedMeans, row.names = FALSE, file = "result.txt")
