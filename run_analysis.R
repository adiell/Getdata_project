
# Download zip file and extract the data files
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getDataProject.zip")
# unzip("getDataProject.zip")
# setwd("UCI HAR Dataset/")

# read all the files into R

X_train <- read.table("train/X_train.txt", sep="")
y_train <- read.table("train/y_train.txt", sep="")
subject_train <-read.table("train/subject_train.txt")
X_test <- read.table("test/X_test.txt", sep="")
y_test <- read.table("test/y_test.txt", sep="")
subject_test <-read.table("test/subject_test.txt")
features <- read.table("features.txt", sep="")

# combine data + label +subject
train_set <- cbind(X_train, y_train, subject_train)
test_set <- cbind(X_test, y_test, subject_test)

# combine test + train
all_data <- rbind(train_set, test_set)

#set informative column names
colnames(all_data) <- c(as.character(features[,2]),"activity","subject")

# extracting only the mean and std related columns
ncol_all <- ncol(all_data)
mean_and_std_columns <- sort(c(grep("mean()",colnames(all_data)),grep("std()",colnames(all_data)), ncol_all-1,ncol_all))
mean_and_std_data <- all_data[,mean_and_std_columns]

# labeling the activities with meaningful names
mean_and_std_data$activity <- as.factor(mean_and_std_data$activity)
levels(mean_and_std_data$activity) <- c("WALKING", "WALKING_UPSTAIRS",  "WALKING_DOWNSTAIRS",  "SITTING",  "STANDING"  ,"LAYING")

# creating a data set with average of each variable by activity and subject
# Note that we don't need to calculate the mean of the last two columns
final_data_set<-aggregate(mean_and_std_data[,1:(ncol(mean_and_std_data)-2)], 
                          by=list(mean_and_std_data$subject, mean_and_std_data$activity), mean)
colnames(final_data_set)[1] <- "Subject"
colnames(final_data_set)[2] <- "Activity"

# write the data to a txt file
write.table(final_data_set, "coursera_get_data_project_result.txt", row.names = FALSE)