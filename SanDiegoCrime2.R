# author: @KamZardouzian
# 6 Month Crime Stats for San Diego (Oct 14, 2019)
# Data source: SANDAG, https://www.sandiego.gov/police/services/statistics, 
# Automated Regional Justice Information System (ARJIS)
# upload libraries
library(dplyr)
library(downloader)
library(data.table)
library(lubridate)
library(radiant)

# Upload Crime Data text file (in Zip format) from source, unzip, & save as crime using fread

download("http://www.sandag.org/programs/public_safety/arjis/CrimeData/crimedata.zip", dest="crimedata.zip", mode="wb") 
crime <- fread(unzip("crimedata.zip"))
# get structure of data
str(crime)

#creating crime_work as working file for crime
crime_work <- crime

# activityDate is character. Needs to be changed to data, we'll also get rid of time & just keep date.
# change activityDate from character to data & time format so we can group crime by date
crime_work$activityDate <- mdy_hms(crime_work$activityDate,tz=Sys.timezone())
crime_work$activityDate <- as.Date(crime_work$activityDate)

# Seperate out crime data for Encinitas
# enc_cri <- crime_work [ which(crime_work$community == "ENCINITAS"),]
# Try new method in dplyr using %>%
View(enc_cri <- crime_work %>%
  filter(community == "ENCINITAS") %>%
  group_by(CM_LEGEND) %>%
  arrange(CM_LEGEND))

# create pivot table for Encinitas crimes descending by most number of crimes
result <- pivotr(
  enc_cri, 
  cvars = "CM_LEGEND", 
  tabsort = "desc(n_obs)", 
  nr = Inf
)

# create dynamic data table 
dtab(result, dec = 0, pageLength = -1) %>% render()

# plot the pivot table, grouping crimes in Encinitas in descending order
plot(result)

# Create a similar pivot table for crimes in all of San Diego County, crime_work contains all data
View(crime_work %>%
       group_by(CM_LEGEND) %>%
       arrange(CM_LEGEND)
     )

# create pivot table for San Diego County crimes descending by most number of crimes
result2 <- pivotr(
  crime_work, 
  cvars = "CM_LEGEND", 
  tabsort = "desc(n_obs)", 
  nr = Inf
)

# create dynamic data table 
dtab(result2, dec = 0, pageLength = -1) %>% render()

# plot the pivot table, grouping crimes in Encinitas in descending order
plot(result2)

# create pivot table to rank communities in San Diego County by most number of crimes
View(crime_work %>%
       group_by(CM_LEGEND) %>%
       arrange(community)
)

result3 <- pivotr(
  crime_work, 
  cvars = "community", 
  tabsort = "desc(n_obs)", 
  nr = Inf
)

# create dynamic data table 
dtab(result3, dec = 0, pageLength = -1) %>% render()

# plot results is not useful