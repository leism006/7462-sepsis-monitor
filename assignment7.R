## TASK 1 SETUP

library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)
library(tictoc)

source("sepsis_monitor_functions.R")

## TASK 2 SPEED READING

#make reading time function
read_time <- function(pt_n = 50, read_fxn = "fread"){
  time_msg <- 
    {
    tic()
    makeSepsisDataset(pt_n, read_fxn)
    toc()
    }
  return(time_msg$callback_msg)
}

#make vector of fread times
fread_times = c(read_time(50, "fread"), 
                read_time(100, "fread"), 
                read_time(500, "fread"))

#make vector of read_delim times
read_delim_times = c(read_time(50, "read_delim"), 
                     read_time(100, "read_delim"), 
                     read_time(500, "read_delim"))

#make summary table
pts <- c(50, 100, 500)
all_times <- cbind(pts, fread_times, read_delim_times)
colnames(all_times) <- c("Patients", "fread data time", "read_delim data time")
all_times

## TASK 3 UPLOAD TO GOOGLE DRIVE

library(googledrive)

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

folder_link <- "https://drive.google.com/drive/folders/1i13ZSSl-Q1A0EGY8CageY83yaN_ZQOt_"

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = folder_link,
                         name = "sepsis_data.csv")

# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()


