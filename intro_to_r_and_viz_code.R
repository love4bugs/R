#######################################################
#######################################################
############    COPYRIGHT - DATA SOCIETY   ############
#######################################################
#######################################################

## INTRO TO R AND VIZ ##

## NOTE: To run individual pieces of code, select the line of code and
##       press ctrl + enter for PCs or command + enter for Macs


#=================================================-
#### Slide 4: Directory settings and loading packages  ####

# Set `main_dir` to the location of your `skillsoft-2021` folder (for Mac/Linux).
main_dir = "~/Desktop/skillsoft-2021"
# Set `main_dir` to the location of your `skillsoft-2021` folder (for Windows).
main_dir = "C:/Users/[username]/Desktop/skillsoft-2021"

# Make `data_dir` from the `main_dir` and remainder of the path to data directory.
data_dir = paste0(main_dir, "/data")
# Make `plots_dir` from the `main_dir` and remainder of the path to plots directory.
plot_dir = paste0(main_dir, "/plots")

# Set directory to data_dir.
setwd(data_dir)
library(tidyverse)
library(nycflights13)


#=================================================-
#### Slide 5: Installing packages and loading data  ####

setwd(data_dir)
load("tidyr_tables.RData")


#=================================================-
#### Slide 7: Summarise and group_by  ####

# Check for detailed documentation
?dplyr::summarise

# Use cases for `summarise` function
summarise(df,                #<- data frame 
          summary_function1, #<- summary rule(s) 
                             #   for new column
          ...)


#=================================================-
#### Slide 8: Summarise and group_by  ####

# Check for detailed documentation
?dplyr::group_by

# Use cases for `group_by` function
group_by(df,         #<- data frame 
          variable1, #<- 1st variable to group by
          variable2, #<- 2nd variable to group by
          ...)


#=================================================-
#### Slide 9: Summarise and group_by alone  ####

# Produce a summary 
summarise(flights, delay = mean(dep_delay, na.rm = TRUE)) 
# Create `by_day` by grouping `flights` by year, month, and day.
by_day = group_by(flights, year, month, day)     
by_day


#=================================================-
#### Slide 10: Summarise and group_by together  ####

# Now use grouped `by_day` data and summarise it to see the average delay by year, month and day.
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


#=================================================-
#### Slide 12: Dplyr and the pipe: a better way  ####

delays = flights %>%                                   #<- take flights data
  group_by(dest) %>%                                   #<- group it by destination
  summarise(count = n(),                               #<- then summarize by creating count variable
            dist = mean(distance, na.rm = TRUE),       #<- and computing mean distance
            delay = mean(arr_delay, na.rm = TRUE)) %>% #<- and mean arrival delay
  filter(count > 20, dest != "HNL")                    #<- then filter it
delays


#=================================================-
#### Slide 13: Summarise and handling NAs  ####

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, 
                        na.rm = TRUE))


#=================================================-
#### Slide 15: Summarise n to count  ####

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE),  
            n = n()) #<- add a column with summary counts


#=================================================-
#### Slide 16: Summarise not needed to count  ####

flights %>% 
  count(day) #<- count number of instances of entry in `day` column


#=================================================-
#### Slide 17: Summarise rank  ####

flights %>% 
  group_by(year, month) %>% 
  summarise(first = min(dep_time, na.rm = TRUE),
            last = max(dep_time, na.rm = TRUE))


#=================================================-
#### Slide 18: Summarise position  ####

# 1. Build a subset of all flights that were not canceled.
not_cancelled = flights %>%
  filter(!is.na(dep_time))  #<- filter flights where `dep_time` was not `NA`

# 2. Group and summarize all flights that were not canceled to get desired results.
not_cancelled  %>%
  group_by(year, month, day) %>%   #<- group the not canceled flights
  summarise(first = min(dep_time), #<- then summarize them by calculating the first
            last = max(dep_time))  #<- and last flights in the `dep_time` in each group


#=================================================-
#### Slide 19: Summarise distinct values  ####

# Number of flights that take off, by day.
not_cancelled  %>%
  group_by(year, month, day) %>%
  summarise(flights_that_take_off = n_distinct(dep_time)) #<- calculate distinct departure times


#=================================================-
#### Slide 20: Remember to ungroup before you regroup  ####

# Take the same `not_canceled` data, but now group by month instead of by day.
not_cancelled %>%                                  #<- set data frame
  ungroup() %>%                                    #<- first ungroup it
  group_by(year, month) %>%                        #<- then group by year and month
  summarise(flights_by_year = n_distinct(dep_time))#<- then do the rest ...


#=================================================-
#### Slide 22: Exercise 1  ####




#=================================================-
#### Slide 25: Would analysis be easy with these datasets?  ####

key_value_country
year_country
rate_country


#=================================================-
#### Slide 26: What makes data 'tidy'?  ####

tidy_country


#=================================================-
#### Slide 29: Separating and uniting  ####

rate_country


#=================================================-
#### Slide 30: Separate  ####

?tidyr::separate

separate(df,   #<- data frame 
         col,  #<- name of column to separate 
         into) #<- name of new variables to 
               #   create as a character vector


#=================================================-
#### Slide 31: Separate  ####

# Using `rate_country` separate its `rate` column into two.
rate_country %>%                   #<- set data frame and pass it to next function with pipe           
  separate(rate,                   #<- separate `rate`
           into = c("cases",       #<- into column `cases`, and
                    "population")) #<-      column `population`


#=================================================-
#### Slide 32: Separate  ####

# Using `rate_country` separate its `rate` column into two.
rate_country %>% 
  separate(rate, 
           into = c("cases", 
                    "population"), 
           sep = "/")              #<- set the separating character to `/`


#=================================================-
#### Slide 33: Separate: sep set to index  ####

# Using `rate_country` separate its `year` column into two.
rate_country %>%
  separate(year,              #<- separate `year`
           into= c("century", #<- into two columns: `century`, and 
                   "year"),   #<-                   `year`
           sep = 2)           #<- set the separator at index = 2


#=================================================-
#### Slide 34: Separate: data type conversion  ####

# The new columns 
# are now also characters.
rate_country %>%
  separate(rate, into = c("cases", "population"))
rate_country %>%
  separate(rate, into = c("cases", "population"), convert = TRUE)


#=================================================-
#### Slide 35: Unite  ####

?tidyr::unite

unite(df,  #<- data frame 
      col, #<- name of column to unite 
      sep) #<- separator to use


#=================================================-
#### Slide 36: Unite example  ####

# Let's separate the `rate_country`'s `year` column into `century` and `year` first.
ex_table = rate_country %>% 
  separate(year, into = c("century", "year"), sep = 2)
ex_table
# Now we use `unite` to combine the two new columns back into one.
# By default, unite will combine columns using `_` so we can use `sep` to specify that we 
# do not want anything between the two columns when combined into one cell.
ex_table %>%      #<- specify the data frame to pipe into `unite`
  unite(time,     #<- set the column `time` for combined values
        century,  #<- 1st column to unite
        year,     #<- 2nd column to unite
        sep = "") #<- set the separator to an empty string 


#=================================================-
#### Slide 44: Loading the CMP dataset for EDA  ####

# Set working directory to where we store data.
setwd(data_dir)

# Read CSV file called "ChemicalManufacturingProcess.csv"
CMP = read.csv("ChemicalManufacturingProcess.csv",
               header = TRUE,
               stringsAsFactors = FALSE)


#=================================================-
#### Slide 45: About the CMP dataset  ####

# View CMP dataset in the tabular data explorer.
View(CMP)


#=================================================-
#### Slide 47: Subsetting data (cont'd)  ####

# Let's make a vector of column indices we would like to save.
column_ids = c(1:4,  #<- concatenate a range of ids
               14:16)#<- with another a range of ids
column_ids

# Let's save the subset into a new variable.
CMP_subset = CMP[ , column_ids]
str(CMP_subset)


#=================================================-
#### Slide 49: Univariate plots: boxplots  ####

summary(CMP_subset$Yield)
boxplot(CMP_subset$Yield,
        col = "orange",
        main = "Yield Summary") #<- add title 


#=================================================-
#### Slide 50: Univariate plots: histogram  ####

# Univariate plot: histogram.
hist(CMP_subset$Yield,
     col = "blue",
     xlab = "Yield",   #<- set x-axis label
     main = "Dist. of Yield") #<- set title


#=================================================-
#### Slide 51: Univariate plots: histogram (cont'd)  ####

# Histogram data without plot.
hist(CMP_subset$Yield, plot = FALSE)

# Histogram data without plot.
hist(CMP_subset$Yield, plot = FALSE)


#=================================================-
#### Slide 53: Exercise 2  ####




#######################################################
####  CONGRATULATIONS ON COMPLETING THIS MODULE!   ####
#######################################################
