
##############
### PART 1 ###
##############

# Defining the paths to the relevent folders (*to be edited if needed*)
path_main  = "./data/UCI HAR Dataset/"
path_train = "./data/UCI HAR Dataset/train/"
path_test  = "./data/UCI HAR Dataset/test/"

# Read the features file
file_name = "features.txt"
features <- read.table(paste(path_main, file_name, sep = ""), 
                       header = FALSE, sep = "", row.names = 1)
# Rename column "V1" as "feature_names"
names(features) <- "feature_names"

# Read the activity_labels file
file_name = "activity_labels.txt"
activity_labels <- read.table(paste(path_main, file_name, sep = ""),
                              header = FALSE, sep = "", row.names = 1)
# Rename column "V1" as "activity_labels"
names(activity_labels) <- "activity"

# Read the subject_train and subject_test files
file_name = "subject_train.txt" ; subject_train <- read.table(paste(path_train, file_name, sep = ""))
file_name = "subject_test.txt"  ; subject_test  <- read.table(paste(path_test , file_name, sep = ""))

# Read the X_train and x_test datasets
file_name = "X_train.txt" 
X_train <- read.table(paste(path_train, file_name, sep = ""), 
                      header = FALSE, dec = ".", sep = "", strip.white = TRUE, fill = TRUE)
file_name = "X_test.txt" 
X_test  <- read.table(paste(path_test , file_name, sep = ""), 
                      header = FALSE, dec = ".", sep = "", strip.white = TRUE, fill = TRUE)

# Read the Y_train and Y_test datasets
file_name = "Y_train.txt"
Y_train<- read.table(paste(path_train, file_name, sep = ""), header = FALSE)
file_name = "Y_test.txt"
Y_test <- read.table(paste(path_test , file_name, sep = ""), header = FALSE)

# Combining the training and test datasets rowwise for the X, Y and subject data.frames
complete_X_dataset       <- rbind(X_train, X_test)
complete_Y_dataset       <- rbind(Y_train, Y_test)
complete_subject_dataset <- rbind(subject_train, subject_test)

##############
### PART 4 ###
##############

# Rename the miss-labeled features having "BodyBody" instead of just "Body" in their names
features$feature_names <- sub("BodyBody","Body",features$feature_names)

# Assign descriptive column names to the complete_X_dataset using the corrected feature_names vector
colnames(complete_X_dataset) <- features$feature_names

# Rename the column "V1" in the complete_Y_dataset as "activity" 
names(complete_Y_dataset) <- "activity"

##############
### PART 3 ###
##############

# Rename the column "V1" in complete_subject_dataset as "subject_id" 
names(complete_subject_dataset) <- "subject_id"

# Replace complete_Y_dataset activity integer values by their explicit names using activity_labels
complete_Y_dataset$activity = factor(complete_Y_dataset$activity, 
                                     labels = c(as.character(activity_labels$activity)))

##############
### PART 2 ###
##############

# Selection of the features related to mean() and std()
# We look for features having exactly the string "mean()" or "std()" in their names

# From the features_info.txt file, there are 8 features having obervations along the X,Y,Z axes
# and 9 features having observations on just one dimension
# Therefore we expect to find: 8 * 3 + 9 = 33 features containing "mean()"
# and the same number of features containing "std()" => 66 features in total 

# Features like "fBodyAccJerk-meanFreq()-X" do not correspond to the actual mean of some observations 
# instead it represents the feature "fBodyAccJerk-X" centered by substracting the meanFreq() to the data
mean_std_logical <- grepl('mean()',features$feature_names, fixed = TRUE) |
                    grepl('std()' ,features$feature_names, fixed = TRUE)
                      
# Extracting the features names from the logical vector mean_std_names
mean_std_names <- features$feature_names[mean_std_logical]

# Creatind the complete_mean_std data.frame containing only the required observations
complete_mean_std <- complete_X_dataset[,c(as.character(mean_std_names))]

##############
### PART 5 ###
##############

# Add the complete_Y_dataset of activity labels to the complete_mean_std data.frame
complete_mean_std <- cbind(complete_mean_std, complete_Y_dataset)

# Add the complete_subject_dataset of subject_id to the complete_mean_std data.frame
complete_mean_std <- cbind(complete_mean_std, complete_subject_dataset)

# Creation of the tidy data set of the average of each variable for each activity and each subject

# Loading the reshape2 library for functions melt and dcast
require(reshape2)
# Retrieve the column names from the complete_mean_std data.frame
names <- colnames(complete_mean_std)

# Create the tidy_data by melting complete_mean_std into a "long" data.frame of just 4 columns
# The first two columns : Activity, Subject_id are used as IDs
# The 3rd column holds the 66 features from the complete_mean_std data.frame as measures
# The 4th column contains the value measure for a given activity, subject_id and feature
tidy_data <- melt(complete_mean_std,
                  id           = names[c(length(names)-1,length(names))],
                  measure.vars = names[c(seq(1,length(names)-2))] )

# Then dcast is used to compute the final tidy_data data.frame by averaging all the values for
# a given activity, suject_id and feature
tidy_data <- dcast(tidy_data, activity + subject_id ~ variable, mean)

# As expected, the final dimensions of tidy_data are 180 x 68
# 68 columns -> 33 features for mean() + 33 features for std() + "activity" + "subject_id"
# 180 rows   -> 30 subjects * 6 different activities

# Writing of the tidy_data table in text format, omitting the row numbering
write.table(tidy_data, file="tidy_data.txt", row.name = FALSE) 

####################################################
### Automated creation of the feature's CodeBook ###
####################################################

# Each feature name is parsed into a descriptive string of characters using substitutions
description <- names
description <- sub("activity"    , " ONE OF THE 6 TYPES OF ACTIVITIES" , description, ignore.case = FALSE)
description <- sub("subject_id"  , " SUBJECT'S IDENTIFICATION NUMBER"  , description, ignore.case = FALSE)
description <- sub("-mean\\(\\)" , " MEAN VALUE"                       , description, ignore.case = FALSE)
description <- sub("-std\\(\\)"  , " STANDARD DEVIATION VALUE"         , description, ignore.case = FALSE)
description <- sub("t"           , " TIME DOMAIN DATA"                 , description, ignore.case = FALSE)
description <- sub("f"           , " FREQUENCY DOMAIN DATA"            , description, ignore.case = FALSE)
description <- sub("Body"        , " OF THE BODY COMPONENT"            , description, ignore.case = FALSE)
description <- sub("Gravity"     , " OF THE GRAVITY COMPONENT"         , description, ignore.case = FALSE)
description <- sub("Acc"         , " FROM ACCELEROMETER FOR THE"       , description, ignore.case = FALSE)
description <- sub("Gyro"        , " FROM GYROSCOPE FOR THE"           , description, ignore.case = FALSE)
description <- sub("-X"          , " ALONG X AXIS"                     , description, ignore.case = FALSE)
description <- sub("-Y"          , " ALONG Y AXIX"                     , description, ignore.case = FALSE)
description <- sub("-Z"          , " ALONG Z AXIS"                     , description, ignore.case = FALSE)
description <- sub("Jerk"        , " JERK SIGNAL"                      , description, ignore.case = FALSE)
description <- sub("Mag"         , " MAGNITUDE"                        , description, ignore.case = FALSE)

# The resulting description table is saved as a CodeBook text file
description <- tolower(description)
codestart <- paste(names, description)
write.table(codestart, file="CodeBook.txt", row.name = FALSE, col.names = FALSE) 
