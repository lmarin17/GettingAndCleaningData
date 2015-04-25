# RUN_ANALYSIS.R 
# Laura Marin - 4/25/2015
#
# This script loads the test and training dataset of Samsung Galaxy phone motion detection data from 30 volunteers
# doing 6 different activities.
#
# We are interested in calculating the average of each of the mean and standard deviation measures
# for each participant per activity, which will result in 180 records (30 participants and 6 activities) and 
# 86 different average measures.
#
# A final comma-delimited dataset of these rollup data is the file AnalyzedActivity.txt, written to the working directory
#
# The script assumes your working directory is set to the UCI HAR Dataset directory upon unzipping the download.


# create a data frame of the observation labels
feat <- read.table("features.txt")

# create a data frame of the test and train observation data
xtest <- read.table("./test/X_test.txt")
xtrain <- read.table("./train/X_train.txt")

# now the observation labels are the features previously loaded.  So change our column names to these. 
names(xtest) <- feat$V2
names(xtrain) <- feat$V2

# y_test and y_train contain the activity associated with each of the x_test and x_train observations.
ytest <- read.table("./test/y_test.txt")
ytrain <- read.table("./train/y_train.txt")

# y_* activities are coded 1 - 6.  We need to replace these codes with the descriptive label
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

ytest$V1[ytest$V1 == 1] = "WALKING"
ytest$V1[ytest$V1 == 2] = "WALKING_UPSTAIRS"
ytest$V1[ytest$V1 == 3] = "WALKING_DOWNSTAIRS"
ytest$V1[ytest$V1 == 4] = "SITTING"
ytest$V1[ytest$V1 == 5] = "STANDING"
ytest$V1[ytest$V1 == 6] = "LAYING"
ytrain$V1[ytrain$V1 == 1] = "WALKING"
ytrain$V1[ytrain$V1 == 2] = "WALKING_UPSTAIRS"
ytrain$V1[ytrain$V1 == 3] = "WALKING_DOWNSTAIRS"
ytrain$V1[ytrain$V1 == 4] = "SITTING"
ytrain$V1[ytrain$V1 == 5] = "STANDING"
ytrain$V1[ytrain$V1 == 6] = "LAYING"


# then add this column into the x_test and x_train datasets.  Now the observations will have the correct activity associated.
xtest <- cbind.data.frame(ytest$V1,xtest)
names(xtest)[1] = "activity"
xtrain <- cbind.data.frame(ytrain$V1,xtrain)
names(xtrain)[1] = "activity"

# subject_test and subject_train list the participant ID associated with the observation.  
subtest <- read.table("./test/subject_test.txt")
subtrain <- read.table("./train/subject_train.txt")

# Add the participantID to the x_test and x_train datasets as another column.  This completes the two datasets.
xtest <- cbind.data.frame(subtest$V1,xtest)
names(xtest)[1] = "participant"
xtrain <- cbind.data.frame(subtrain$V1,xtrain)
names(xtrain)[1] = "participant"

# Now it''s time to merge the two datasets together to complete creating the final analyzed dataset.

fullset <- xtest
fullset <- rbind.data.frame(fullset,xtrain)

# Create a tidy dataset by selecting the activity, participant, and only the mean and standard deviation
# columns of measurement.  

tidyset <- subset(fullset,select=names(fullset)[grep("mean|std|participant|activity",names(fullset),ignore.case=TRUE)])

# Rename these columns to meet the tidy (but readable) data naming conventions.

clean <- names(tidyset)
clean <- sub("tBodyAcc","timeBodyAccel",clean)
clean <- sub("tGravityAcc","timeGravityAccel",clean)
clean <- sub("tBodyGyro","timeBodyGyro",clean)
clean <- sub("fBodyAcc","freqBodyAccel",clean)
clean <- sub("fBodyGyro","freqBodyGyro",clean)
clean <- sub("fGravityAcc","freqGravityAccel",clean)
clean <- sub("\\(","",clean)
clean <- sub("\\)","",clean)
clean <- sub("-","",clean)
clean <- sub("\\)","",clean)
clean <- sub("-","",clean)
clean <- sub("mean","Mean",clean)
clean <- sub("std","StdDev",clean)
clean <- sub(",g","G",clean)

names(tidyset) <- clean

# Our full dataset contains only the participant, activity and all the relevant mean and standard deviation columns
# To create the final analyzed set, we need to calculate a mean value for each column grouping by participant and activity.

analyzed <- aggregate(tidyset[,3:88],list(participant= tidyset$participant,activity= tidyset$activity),FUN = mean, na.rm=TRUE)

# Now write this analyzed set out to a text file

write.table(analyzed, file = "AnalyzedActivity.txt", row.names = FALSE, col.names = TRUE, sep = ",")
