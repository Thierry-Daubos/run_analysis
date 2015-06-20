# run_analysis
Repo for the "Getting and Cleaning Data" module Course Project

===
Analysing script for the Human Activity Recognition Using Smartphones Dataset
Version 1.0
Thierry Daubos
===

Here are the differents steps taken by the script to analyze the data:

## PART 1
<ol>

<li> paths to the relevent folders are initialized </li>
<li> read the features file and rename column "V1" as "feature_names" </li>
<li> reading of the activity_labels file and rename column "V1" as "activity_labels" </li>
<li> reading of the subject_train and subject_test files</li>
<li> reading of the X_train and X_test datasets </li>
<li> readinf of the Y_train and Y_test datasets </li>
<li> the training and test datasets are combined rowwise for the X, Y and subject data.frames using rbind </li>
     leading to three new concatenated datasets: complete_X_dataset, complete_Y_dataset, complete_subject_dataset </li>
</ol>

Note: The renaming of the labels of the datasets with desciptive variables is performed prior to the extraction of measurements in order to facilitate the selection of the columns related to the mean() and std(). Therefore parts 4 and 3 are carried out before part 2.

## PART 4
8. the miss-labeled features having "BodyBody" instead of just "Body" in their names are renamed using the sub command
9. descriptive column names for the complete_X_dataset are assigned using the corrected feature_names vector from step 8)
10. the column "V1" of the complete_Y_dataset is renamed as "activity"
11. the column "V1" of complete_subject_dataset is renamed as "subject_id"

## PART 3
12. Replacement of the complete_Y_dataset activity integer values by their explicit names using the activity_labels table

## PART 2
Note: For the selection of the features related to mean() and std(), we look for features having exactly the string "mean()" or "std()" in their names. 

Features like "fBodyAccJerk-meanFreq()-X" do not correspond to the actual mean of some observations. Instead it represents the feature "fBodyAccJerk-X" centered by substracting the meanFreq() to the data. Therefore these features are not selected to appear in the final tidy-data data.frame.

From the features_info.txt file, there are 8 features having obervations along the X,Y,Z axes and 9 features having observations on just one dimension. Therefore we expect to find: 8 * 3 + 9 = 33 features containing "mean()" and the same number of features containing "std()" => 66 features in total.

13. creation of a logical vector to select the features names to be retained using grep function on the features table
14. creation of the complete_mean_std data.frame containing only the required observations using logical vector from step 13)

## PART 5
15. the complete_Y_dataset of activity labels is added to the complete_mean_std data.frame using cbind
16. the complete_subject_dataset of subject_id is added to the complete_mean_std data.frame using cbind

Creation of the tidy data set of the average of each variable for each activity and each subject:
17. Loading of the reshape2 library to use the melt and dcast functions
18. the column names from the complete_mean_std data.frame are retrieved in the list "names"
19. the tidy_data is created by melting the complete_mean_std into a "long" data.frame of just 4 columns:
    - The first two columns : Activity, Subject_id are used as IDs
    - The 3rd column holds the 66 features from the complete_mean_std data.frame as measures
    - The 4th column contains the value measured for a given activity, subject_id and feature
20. The dcast function is used to compute the final tidy_data data.frame by averaging all the values for a given activity,       suject_id and feature

Note: As expected, the final dimensions of tidy_data are 180 x 68
      68 columns -> 33 features for mean() + 33 features for std() + "activity" + "subject_id"
      180 rows   -> 30 subjects * 6 different activities

21. writing of the tidy_data table in text format, omitting the row numbering

## Automated creation of the feature's CodeBook
22. each feature name is parsed into a descriptive string of characters using substitutions
23. the resulting description table is saved as a CodeBook text file

### End of the script
