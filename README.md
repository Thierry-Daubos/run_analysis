# run_analysis
Repo for the "Getting and Cleaning Data" module Course Project

Analysing script for the Human Activity Recognition Using Smartphones Dataset
### Version 1.0
### Thierry Daubos

Here are the differents steps taken by the script to analyze the data:

### PART 1
<ol>
<li> paths to the relevent folders are initialized </li>
<li> reading of the <i>features</i> file and rename column "V1" as "feature_names" </li>
<li> reading of the <i>activity_labels</i> file and rename column "V1" as "activity_labels" </li>
<li> reading of the <i>subject_train</i> and <i>subject_test</i> files</li>
<li> reading of the <i>X_train</i> and <i>X_test</i> datasets </li>
<li> readinf of the <i>Y_train</i> and <i>Y_test</i> datasets </li>
<li> the training and test datasets are combined rowwise for the X, Y and subject data frames using rbind </li>
     leading to three new concatenated datasets: <i>complete_X_dataset</i>, <i>complete_Y_dataset</i>,         <i>complete_subject_dataset</i> </li>
</ol>

**Note:** The renaming of the labels of the datasets with desciptive variables is performed prior to the extraction of measurements in order to facilitate the selection of the columns related to the mean() and std(). Therefore parts 4 and 3 are carried out before part 2.

### PART 4
<ol start="8">
<li> the miss-labeled features having "BodyBody" instead of just "Body" in their names are renamed using sub command </li>
<li> descriptive column names for the <i>complete_X_dataset</i> are assigned using the corrected feature_names vector from step 8) </li>
<li> the column "V1" of the <i>complete_Y_dataset</i> is renamed as "activity" </li>
<li> the column "V1" of <i>complete_subject_dataset</i> is renamed as "subject_id" </li>
</ol>
### PART 3
<ol start="12">
<li>  Replacement of the <i>complete_Y_dataset</i> activity integer values by their explicit names using the activity_labels table</li>
</ol>

### PART 2
**Note:** For the selection of the features related to mean() and std(), we look for features having exactly the string "mean()" or "std()" in their names. 

Features like "fBodyAccJerk-meanFreq()-X" do not correspond to the actual mean of some observations. Instead it represents the feature "fBodyAccJerk-X" centered by substracting the meanFreq() to the data. Therefore these features are not selected to appear in the final <i>tidy-data</i> data frame.

From the features_info.txt file, there are 8 features having obervations along the X,Y,Z axes and 9 features having observations on just one dimension. Therefore we expect to find: 8 * 3 + 9 = 33 features containing "mean()" and the same number of features containing "std()" => 66 features in total.

<ol start="13">
<li> creation of a logical vector to select the features names to be retained using grep function on the features table </li>
<li> creation of the <i>complete_mean_std</i> data.frame containing only the required observations using logical vector from step 13) </li>
</ol>

### PART 5
<ol start="15">
<li> the <i>complete_Y_dataset</i> of activity labels is added to the <i>complete_mean_std</i> data frame using cbind </li>
<li> the <i>complete_subject_dataset</i> of subject_id is added to the <i>complete_mean_std</i> data frame using cbind </li>
</ol>

Creation of the tidy data set of the average of each variable for each activity and each subject:
<ol start="17">
<li> Loading of the reshape2 library to use the melt and dcast functions </li>
<li> the column names from the <i>complete_mean_std</i> data frame are retrieved in the list "names" </li>
<li> the <i>tidy_data</i> is created by melting the <i>complete_mean_std</i> into a "long" data frame of just 4 columns: </li>
     <ul>
     <li> The first two columns : Activity, Subject_id are used as IDs </li>
     <li> The 3rd column holds the 66 features from the <i>complete_mean_std</i> data frame as measures </li>
     <li> The 4th column contains the value measured for a given activity, subject_id and feature </li>
    </ul>
<li> The dcast function is used to compute the final <i>tidy_data</i> data frame by averaging all the values for a given activity, suject_id and feature </li>
</ol>

**Note:** As expected, the final dimensions of <i>tidy_data</i> are 180 x 68
          <ul>
          <li> 68 columns -> 33 features for mean() + 33 features for std() + "activity" + "subject_id" </li>
          <li> 180 rows   -> 30 subjects * 6 different activities </li>
          </ul>
<ol start="21">
<li> writing of the <i>tidy_data</i> table in text format, omitting the row numbering </li>
</ol>

This is the so-called "wide form" of the tidy dataset (as opposed to the "thin form" which would have just 4 columns: activity, subject_id, measure, mean vallues) but is equally acceptable format as state by our Teaching Asistant in this thread of the discussion forum: [Tidy data and the Assignment](https://class.coursera.org/getdata-015/forum/thread?thread_id=27)

### Automated creation of the feature's CodeBook

**Note:** The CodeBook provided in this repo describes the explicit meaning of each feature present in the <i>tidy_data</i>.

<ol start="22">
<li> each feature name is parsed into a descriptive string of characters using substitutions </li>
<li> the resulting <i>description</i> table is saved as a CodeBook text file </li>
</ol>

#### End of the script
