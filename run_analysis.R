##Load the test data
setwd("~/Google ドライブ/Git/datasciencecoursera/UCI HAR Dataset/test")
x <- read.table("X_test.txt")
y <- read.table("y_test.txt")
s <- read.table("subject_test.txt")

##Load the training data
setwd("~/Google ドライブ/Git/datasciencecoursera/UCI HAR Dataset/train")
xtr <- read.table("X_train.txt")
ytr <- read.table("y_train.txt")
str <- read.table("subject_train.txt")

#1. Merge the test/training data
xdf <- rbind(x, xtr) #measurement
ydf <- rbind(y, ytr) #activity
sdf <- rbind(s, str) #subject

##Get feature names
setwd("~/Google ドライブ/Git/datasciencecoursera/UCI HAR Dataset")
fd <- read.table("features.txt")
as.character(fd[,2])

##Get activity names
actname <- read.table("activity_labels.txt")
as.character(actname[,2])

#2. Extract test mean/sd data
selected <- grep("-(mean|std).*",fd[,2])

#4. Appropriately Label the data with descriptive variable name
##Select the variable name columns
selectedColN <- fd[selected,2]
#Delete the symbols and Replace mean/std with Mean/Std
selectedColN <- gsub("[()-]","",selectedColN)
selectedColN <- gsub("mean","Mean",selectedColN)
selectedColN <- gsub("std","Std",selectedColN)

#3. Name the activity in the data
##Merge the selected columns, subject, and activity
alldata <- cbind(sdf, ydf, xdf[selected])
names(alldata) <- make.names(c("subject", "activity", selectedColN))

##Replace the number with the activity names
alldata$activity <- factor(alldata$activity, levels = actname[,1], labels = actname[,2])


#5. Calculate the mean of each variable for each activity and subject
alld <- melt(alldata, id.vars = c("subject","activity"))
td <- acast(alld, subject + activity ~ variable, mean)

#5. Write a tidy data set as csv
write.csv(td, file = "tidydata.csv", quote = F)
