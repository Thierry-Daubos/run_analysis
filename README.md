# run_analysis
Repo for the "Getting and Cleaning Data" module Course Project

===
Analysing script for the Human Activity Recognition Using Smartphones Dataset
Version 1.0
### Thierry Daubos
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
<ol start="8">
<li> the miss-labeled features having "BodyBody" instead of just "Body" in their names are renamed using the sub command </li>
<li> descriptive column names for the complete_X_dataset are assigned using the corrected feature_names vector from step 8) </li>
<li> the column "V1" of the complete_Y_dataset is renamed as "activity" </li>
<li> the column "V1" of complete_subject_dataset is renamed as "subject_id" </li>
</ol>
## PART 3
<ol start="12">
<li>  Replacement of the complete_Y_dataset activity integer values by their explicit names using the activity_labels table</li>
</ol>

## PART 2
Note: For the selection of the features related to mean() and std(), we look for features having exactly the string "mean()" or "std()" in their names. 

Features like "fBodyAccJerk-meanFreq()-X" do not correspond to the actual mean of some observations. Instead it represents the feature "fBodyAccJerk-X" centered by substracting the meanFreq() to the data. Therefore these features are not selected to appear in the final tidy-data data.frame.

From the features_info.txt file, there are 8 features having obervations along the X,Y,Z axes and 9 features having observations on just one dimension. Therefore we expect to find: 8 * 3 + 9 = 33 features containing "mean()" and the same number of features containing "std()" => 66 features in total.

<ol start="13">
<li> creation of a logical vector to select the features names to be retained using grep function on the features table </li>
<li> creation of the complete_mean_std data.frame containing only the required observations using logical vector from step 13) </li>
</ol>

## PART 5
<ol start="15">
<li> the complete_Y_dataset of activity labels is added to the complete_mean_std data.frame using cbind </li>
<li> the complete_subject_dataset of subject_id is added to the complete_mean_std data.frame using cbind </li>
</ol>

Creation of the tidy data set of the average of each variable for each activity and each subject:
<ol start="17">
<li> Loading of the reshape2 library to use the melt and dcast functions </li>
<li> the column names from the complete_mean_std data.frame are retrieved in the list "names" </li>
<li> the tidy_data is created by melting the complete_mean_std into a "long" data.frame of just 4 columns: </li>
     <ul>
     <li> The first two columns : Activity, Subject_id are used as IDs </li>
     <li> The 3rd column holds the 66 features from the complete_mean_std data.frame as measures </li>
     <li> The 4th column contains the value measured for a given activity, subject_id and feature </li>
    </ul>
<li> The dcast function is used to compute the final tidy_data data.frame by averaging all the values for a given activity,       suject_id and feature </li>
</ol>

Note: As expected, the final dimensions of tidy_data are 180 x 68
      68 columns -> 33 features for mean() + 33 features for std() + "activity" + "subject_id"
      180 rows   -> 30 subjects * 6 different activities

<ol start="21">
<li> writing of the tidy_data table in text format, omitting the row numbering </li>
</ol>

## Automated creation of the feature's CodeBook
<ol start="22">
<li> each feature name is parsed into a descriptive string of characters using substitutions </li>
<li> the resulting description table is saved as a CodeBook text file </li>
</ol>

### End of the script
