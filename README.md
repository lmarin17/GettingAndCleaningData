# GettingAndCleaningData
Repo for the class project

This repo contains the run_analysis.R script and the Codebook.MD describing the output variables.
------------------------------------------------------------------------------------------------

 
This script loads the test and training dataset of Samsung Galaxy phone motion detection data from 30 volunteers
doing 6 different activities.

We are interested in calculating the average of each of the mean and standard deviation measures
for each participant per activity, which will result in 180 records (30 participants and 6 activities) and 
86 different average measures.

A final <i>comma-delimited dataset</i> of these rollup data is the file <b>AnalyzedActivity.txt</b> written to the working directory.

The script assumes your working directory is set to the UCI HAR Dataset directory upon unzipping the download and does the following steps:

1. -  Creates dataframes by reading the x_test, x_train, features, y_test and y_train datasets.  
2. - Updates the x_* datasets with the appropriate column names contained in the features data.
3. - Updates the y_* datasets by replacing the numeric activity codes with the appropriate activity names.
4. - Reads in the subject_test and subject_train files as the study participant ID.
5. - Create a full dataset by combining all the data above, and from this, create a tidyset which is a subset of the full data containing only the mean and standard deviation columns we're interested in.
6. - Create more user-friendly column names, and from this, create an analyzed set of data which calculates the mean of each measure, grouping by participant and activity.
7. - Write this dataset to a comma-delimited file to the working directory, called AnalyzedActivity.txt



