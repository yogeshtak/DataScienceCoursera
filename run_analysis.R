ds_dir <- "UCI HAR Dataset"
ds_file <- "Dataset.zip"


subject_col <- "Subject"
activity_col <- "Activity"


verify_deps <- function(...) {
  lapply(list(...), function(lib) {
    if (!lib %in% installed.packages()) 
      install.packages(lib)
  })
}


load_file <- function(filename, ...) {
  file.path(..., filename) %>%
    read.table(header = FALSE)
}


load_train_file <- function(filename) {    #loading train files
  load_file(filename, ds_dir, "train")
}


load_test_file <- function(filename) {     #loading test files
  load_file(filename, ds_dir, "test")
}


describe_lbl_ds <- function(ds) {
  names(ds) <- activity_col  
  ds$Activity <- factor(ds$Activity, levels = activity_lbl$V1, labels = activity_lbl$V2)
  ds
}

describe_act_ds <- function(ds) {
  col_names <- gsub("-", "_", features$V2)
  col_names <- gsub("[^a-zA-Z\\d_]", "", col_names)
  names(ds) <- make.names(names = col_names, unique = TRUE, allow_ = TRUE)
  ds
}


describe_sub_ds <- function(ds) {   #adjusting to column name
  names(ds) <- subject_col
  ds
}



verify_deps("dplyr", "reshape2")   # Verify dependencies



library("dplyr")      #Loading the dependencies
library("reshape2")


if (!file.exists(ds_file)) {       #Downloading and extracting the zip file with datasets
  source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(source_url, destfile = ds_file, method = "curl")
  unzip(ds_file)
  if (!file.exists(ds_dir)) 
    stop("The downloaded dataset doesn't have the expected structure!")
}


if (!file.exists(ds_dir)) {     #Unzips file if already exists but was not unziped
  unzip(ds_file)
  if (!file.exists(ds_dir)) 
    stop("The downloaded dataset doesn't have the expected structure!")
}


features <- load_file("features.txt", ds_dir)    #Loading features as human-readable column names


activity_lbl <- load_file("activity_labels.txt", ds_dir)   #Loading activity labels

train_set <- load_train_file("X_train.txt") %>% describe_act_ds    #Using descriptive activity label names to name the activities
train_lbl <- load_train_file("y_train.txt") %>% describe_lbl_ds
train_sub <- load_train_file("subject_train.txt") %>% describe_sub_ds

test_set <- load_test_file("X_test.txt") %>% describe_act_ds
test_lbl <- load_test_file("y_test.txt") %>% describe_lbl_ds
test_sub <- load_test_file("subject_test.txt") %>% describe_sub_ds

 


merged_data <- rbind(    #Merging training and test data sets
  cbind(train_set, train_lbl, train_sub),
  cbind(test_set, test_lbl, test_sub)
) %>%
  select(
    matches("mean|std"), 
    one_of(subject_col, activity_col)
  )


id_cols <- c(subject_col, activity_col)
tidy_data <- melt(
  merged_data, 
  id = id_cols, 
  measure.vars = setdiff(colnames(merged_data), id_cols)
) %>%
  dcast(Subject + Activity ~ variable, mean)

#Creating tidy data set 
write.table(tidy_data, file = "tidy_data.txt", sep = ",", row.names = FALSE)
