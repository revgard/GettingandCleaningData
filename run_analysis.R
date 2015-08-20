## Getting and Cleaning Data Course Project

##  You should create one R script called run_analysis.R that does the following. 
##  1.Merges the training and the test sets to create one data set.
##  2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3.Uses descriptive activity names to name the activities in the data set
##  4.Appropriately labels the data set with descriptive variable names. 
##  5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Step 1 - Read all file data
#
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

## Step 2
# Bind all (groups): subjects, labels, all other items
#

data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

## step 3 - Read features from file
#
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# Hold mean and standard deviation as a variable
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# Select means and standard deviations
# Skip to the 2nd line for starting the process because of column lables: subjects and labels
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## step 4 - Read (activities)
#
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

# Replace the labels with approriate label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## step 5
# Create a list of the current column names and feature names
cnames.colnames <- c("subject", "label", features.mean.std$V2)

# Clean data - Remove extraneous non-alphabetic character and converting all itmes to lowercase
cnames.colnames <- tolower(gsub("[^[:alpha:]]", "", cnames.colnames))
# Column names now ready for use
colnames(data.mean.std) <- cnames.colnames

## step 6 - compute the mean for each combination of subject and label
#
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

### Write out the table in local directory for upload
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)

