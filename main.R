#setwd("C:/R/Trends/Megatrends")

## FOR CREATING DATA TABLES FROM FRAMES
if (!require("DT")) install.packages('DT')
sessionInfo()

## INSTALL PACKAGES if required
doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ROAuth", "twitteR", "streamR", "ggplot2", "stringr",
               "tm", "RCurl", "maps", "Rfacebook", "topicmodels", "library", "devtools", "httr", "ROAuth")


############################################################################
################################# TOP POSTS ################################
############################################################################

## Packages Rfacebook
library(httr)
library(httpuv)
library(rjson)
library(RCurl)
library(twitteR)
library(DT)

library(ROAuth)
library(Rfacebook)

## load facebook oauth
load("Authenticate/auth/fb_oauth")
load("Authenticate/auth/oauth_fb.Rdata")

fb_oauth = 'EAACEdEose0cBAIXDaXcobywEBbpGHPHFeSZAjYLnLEVgifRcWNqSkPvvRJMw62eqc8ts253kiJPzGVReiLKasVFi83XzY12pHIflg4O9mk6dNzvXNUIjDqQNRhg73URd5HwcbzLyRBRwM1eTaitG33dzlUb65xDAfZChxnRaJuqRJTnm1p'

## Run the following line to return facebook public information for user:
getUsers("me", token=fb_oauth, private_info=TRUE)

######################################################

## load tw_cred
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "TLoiGyoNjdO0cVJzbQCRW21VN"
consumerSecret <- "PZhT6ZXoGelh7rypBswiCP7ZwDBjmtuUZ4XUtACJTMPZvcEwt8"

tw_cred <- OAuthFactory$new(consumerKey=consumerKey,
                            consumerSecret=consumerSecret, requestURL=requestURL,
                            accessURL=accessURL, authURL=authURL)
## load twitter oauth
load("Authenticate/auth/oauth_tw.Rdata")

accessToken = '739726747973754880-MIjR4hL72aAa10nAT9agrRkSHuFqkQn'
accessSecret = 'jZ0Z6SMcVzvj92R9lNR4CMPAEq9APnJRFPD1TSY1JngsM'


## test that it works
library(twitteR)
setup_twitter_oauth(consumer_key=consumerKey, consumer_secret=consumerSecret,
                    access_token=accessToken, access_secret=accessSecret)

searchTwitter('Uni_Newcastle', n=1)

## See also ?fbOAuth for information on how to get a long-lived OAuth token
#############################################################################
######################### SCRAPE FACEBOOK PAGES #############################
#############################################################################

## Get posts from = to
uon_page <- getPage(page = "TheUniversityofNewcastleAustralia", token = fb_oauth, n = 200, since = "2016/05/19", until = "2016/06/19")

##############################################################################
######################### DATA FRAME = (uon_page) ############################
##############################################################################

##############################################################################
################ DOWNLOADING RECENT TWEETS FROM UON USERNAME #################
##############################################################################

## you can do this with twitteR with user name
tw_timeline <- userTimeline('Uni_Newcastle', n=20)
  
## save to data frame
tw_tweets <- twListToDF(tw_timeline)


##############################################################################
####################### DATA FRAME = (timeline) ##############################
##############################################################################
########################## BEGINE DATA TABLES ################################
##############################################################################

library(dplyr)
library(data.table)
library(reshape2)
library(DT)

## load facebook unstructured data
datatable(head(uon_page), class = 'cell-border stripe')

fb_result = uon_page[ , c( 8, 9, 10)]
## view fb result
dim(fb_result)
## save fb result
fb_result.sub <- fb_result[sample(nrow(fb_result), c( 8, 9, 10)), ]
## get total mean variables for each column
fb_col <- colMeans(fb_result.sub)
head(fb_col)

#############################################################
################# CREATE PIE CHART ##########################
#############################################################

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


## Join tables
######################################################
################### WIDGET ###########################
######################################################

