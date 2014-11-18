Getting and Cleaning Data. Programming Assignment
=================================================

The script consists of the following steps:

* Download data file and unzip it.

* Load all data into data frames.

* Add subject and activity fields to data frames.

* Merge training and test data frames into one big dataset.

* Filter a subset of this data, comprised only of mean and std fields (and activity + subject).

* Group data table by activity and subject and calculate the mean values for all other fields (via Dplyr).

* Output the result into the result.txt.

* Profit!