## FOR CREATING DATA TABLES FROM FRAMES
if (!require("DT")) install.packages('DT')
sessionInfo()

## INSTALL PACKAGES if required
doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ROAuth", "twitteR", "streamR", "ggplot2", "stringr",
               "tm", "RCurl", "maps", "Rfacebook", "topicmodels", "library", "devtools", "httr", "ROAuth")

############################################################################
########################### TOP SOURCE STATISTICS ##########################
############################################################################

##library(MASS)

## Packages Rfacebook
library(httr)
library(httpuv)
library(rjson)
library(RCurl)
library(twitteR)
library(DT)
library(ROAuth)
library(Rfacebook)
library(dplyr)
library(data.table)
library(reshape2)

## load facebook oauth only if required
## This is used after the file is created fb_oath
## It needs to be pointed to the right directory
## < load("Authenticate/auth/fb_oauth")
## < load("Authenticate/auth/oauth_token.Rdata")

##############################################################
############# BLOCK BELOW IS NORMALLY ALL NEEDED ATM #########

## load facebook user account and access code
fb_oauth = 'EAACEdEose0cBACS0zLriJ0oFJ6K3e4p5csldyqKkpi1XZAypJXY77xZBHZC8w3O4zwFllsTItyTzu2CgZBWsb1hKRs7DixK2BQzcdPJqKTOZC2EnsZCSPoEydnZB3wzZANNumQYsVLxDW2rOLtozgIap1zOFJ0tlHR1ZBaljjO2vzHQZDZD'
## Run the following line to return facebook public information for user:
## If it works no reason to go further with OAUTH
getUsers("me", token=fb_oauth, private_info=TRUE)

##############################################################
################### LOAD TWITTER CREDENTIALS #################

## load tw_cred
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "TLoiGyoNjdO0cVJzbQCRW21VN"
consumerSecret <- "PZhT6ZXoGelh7rypBswiCP7ZwDBjmtuUZ4XUtACJTMPZvcEwt8"

tw_cred <- OAuthFactory$new(consumerKey=consumerKey,
                            consumerSecret=consumerSecret, requestURL=requestURL,
                            accessURL=accessURL, authURL=authURL)

## load twitter oauth needs to be directed to right location

accessToken = '739726747973754880-MIjR4hL72aAa10nAT9agrRkSHuFqkQn'
accessSecret = 'jZ0Z6SMcVzvj92R9lNR4CMPAEq9APnJRFPD1TSY1JngsM'

## test that it works
library(twitteR)
setup_twitter_oauth(consumer_key=consumerKey, consumer_secret=consumerSecret,
                    access_token=accessToken, access_secret=accessSecret)

searchTwitter('Uni_Newcastle', n=1)

####################################################################
############ GET DATA FROM TWITTER AND FACEBOOKTABLES ##############

## Get N number of posts from facebook and set table uon_page
uon_page <- getPage(page = "TheUniversityofNewcastleAustralia", token = fb_oauth, n = 200)

## Get N number of tweets from Twitter and set table tw_tweets
tw_timeline <- userTimeline('Uni_Newcastle', n=200)
## save to data frame
tw_tweets <- twListToDF(tw_timeline)

################### END UNSTRUCTURED DATA ##########################
####################################################################
#################### DATA TABLES CREATE ############################

## Create data table for colums likes_count, shares_count, comments_count
## load facebook data table uon_page
datatable(head(uon_page), class = 'cell-border stripe')
## Pull collumns
fb_result = uon_page[ , c( 8, 9, 10)]
## view fb result if required
dim(fb_result)

## Create data table for colums favoriteCount, retweetCount
## open data table tw_tweets
datatable(head(tw_tweets), class = 'cell-border stripe')
## gcreate table tw_resultsand add colums 3 and 12
tw_result = tw_tweets[ , c( 3, 12)]
## view TW result if required
dim(tw_result)

## Merge table for output ts_result
ts_result = merge(fb_result, tw_result)

##################### END SEMI-STRUCTURED - PASS TO SERVER.R ###############
############################################################################
#################### TO BE DONE IN SHINY SERVER ############################

## DATA NEEDS TO BE ANALYZED
## Not sure if this is the best way to do it in SHINY SERVER
library("ggplot2")
library("ggthemes") ## for theme_economist

## Convert to data.frame
saveData <- function(data){
  data <- as.data.frame.matrix(ts_result)
}

## Define load data function 
loadData <- function(){}

## view results table rows
head(ts_result)
## view results total
dim(ts_result)

library(shiny)
## this plot should not be run, until the data equations have been performed 
## then the plot needs to run on the results of the equations
pie <- ggplot(ts_result, aes(x = "",y=value, fill = origin))+  
  geom_bar(width = 1,stat="identity")+  
  coord_polar(theta = "y",start=pi/3)+  
  theme_economist()

############# stop ############# stop ############# stop ################## 
###########################################################################
############# stop ############# stop ############# stop ################## 
###########################################################################
## FIND MEAN 
## ## only used to temporarily build the tables without shiny

## create sub table from fb_result 
fb_result.sub <- fb_result[sample(nrow(fb_result), c( 8, 9, 10)), ]
## get total mean variables for each column
fb_col <- colMeans(fb_result.sub)
head(fb_col)

## create sub table from tw_results 
tw_result.sub <- tw_result[sample(nrow(tw_result), c( 3, 10)), ]
## creat column get total mean variables for each column
tw_col <- colMeans(tw_result.sub)
head(tw_col)

##########################################################################
## FIND FREQUENCY
## only used to temporarily build the tables without shiny
## load the MASS package 
library(MASS)                

fb_chart = fb_result$likes_count + fb_result$comments_count + fb_result$shares_count    
fb_chart.freq = table(fb_result)  
pie(fb_chart.freq)            
head(fb_result)

tw_chart = tw_result$favoriteCount + tw_result$retweetCount
tw_chart.freq = table(tw_result)
pie(tw_chart.freq)
head(tw_result)

###########################################################################
###########################################################################

