# 6 Month Crime Stats for San Diego (Oct 14, 2019)
# Data source: SANDAG, https://www.sandiego.gov/police/services/statistics, 
# Automated Regional Justice Information System (ARJIS)
# upload libraries
library(dplyr)
library(downloader)


# Upload Crime Data text file (in Zip format) from source, unzip, & save as crime using fread

download("http://www.sandag.org/programs/public_safety/arjis/CrimeData/crimedata.zip", dest="crimedata.zip", mode="wb") 
crime <- fread(unzip("crimedata.zip"))
# get structure of data
str(crime)

#creating crime_work as working file for crime
crime_work <- crime

# activityDate is character. Needs to be changed to data, we'll also get rid of time & just keep date.
# change activityDate from character to data & time format so we can group crime by date
library(lubridate)
crime_work$activityDate <- mdy_hms(crime_work$activityDate,tz=Sys.timezone())
crime_work$activityDate <- as.Date(crime_work$activityDate)

# Seperate out crime data for Encinitas, Zipcode of 92024
enc_cri <- crime_work [ which(crime_work$community == "ENCINITAS"),]

# group by date
enc_cri %>%
     group_by(enc_cri$activityDate)

# redo group by crime type (CM_LEGEND) for more useful table
enc_cri %>%
     group_by(enc_cri$CM_LEGEND) %>%
     arrange(CM_LEGEND)

# count Encinitas crimes by CM_LEGEND by counting rows using nrow

# export table to CSV file
write.csv(enc_cri, file = "C:/Users/Kam/Desktop/data/crimedata_2019/Encinitas_Crime_kam.csv")

# Group entire crime dataset by zip code, then by type of crime (CM_LEGEND)
# first format the date to delete time & only keep date
crime$activityDate <- charToDate(crime$activityDate)

# now group by Zip
crime %>%
     group_by(crime$ZipCode) %>%
     arrange(ZipCode)

county <- crime %>%
     select(CM_LEGEND, ZipCode, community) %>%
     group_by(ZipCode) %>%
     arrange(ZipCode)
write.csv(county, file = "C:/Users/Kam/Desktop/data/crimedata_2019/SD_County_Crime_kam.csv")
