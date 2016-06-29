install.packages(c("tm", "SnowballC", "wordcloud", "RColorBrewer", "RCurl", "XML"))

##############################################################################
############################# TOP 10  BUZZ WORDS #############################
##############################################################################
############## TIER 1 ########### FB_COLLECT.r ############ TIER 1 ###########
##############################################################################

## install libraries
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(SnowballC)
library(RColorBrewer)
library(shiny)
library(devtools)
library(stringr)
library(RCurl)
library(XML)
library(ROAuth)

## Collect tweets containing 'Uni_Newcastle'
word_tweets = searchTwitter("Uni_Newcastle", n=400, lang="en")
## Extract text content of all the tweets
word_text = sapply(word_tweets, function(x) x$getText())
## In tm package, the documents are managed by a structure called Corpus
tw_words = Corpus(VectorSource(word_text))

  
## Create a term-document matrix from a corpus 
## ENTER STOP WORDS FILTER
tw_tdm = TermDocumentMatrix(tw_words,
                            control = list(removePunctuation = TRUE,
                                           stopwords = c("http", "amp", "httpstco.", "https", "httpstco..", "httpstco...", "Newcastle", "UniNewcastle", "Uni", "uni","text", "url", "file", "that", "all", "from", "has","was", "yes", "for", "and", "the", "that", "this", stopwords("english")),
                                           removeNumbers = TRUE, tolower = FALSE))

########################################################################
############### END TIER 2 - FILTER - RETURN TW_TDM ####################
########################################################################
############## TIER 3 ############# SERVER.R ############# TIER 3 ######
########################################################################

## Convert as matrix tw_m
tw_m = as.matrix(tw_tdm)
## Get word counts in decreasing order
word_freqs = sort(rowSums(tw_m), decreasing=TRUE) 
## Create data frame with words and their frequencies
tw_dm = data.frame(word=names(word_freqs), freq=word_freqs)

head(word_freqs, 10)

##################### PLOT ########################
## Plot wordcloud
wordcloud(tw_dm$word, tw_dm$freq, random.order=FALSE, colors=brewer.pal(7, "YlGnBu"))

## save the image in png format
png("words/UONCloud.png", width=12, height=8, units="in", res=300)
wordcloud(tw_dm$word, tw_dm$freq, random.order=FALSE, colors=brewer.pal(7, "YlGnBu"))
dev.off()

## Make the wordcloud drawing predictable during a session
wordcloud_rep <- repeatable(wordcloud)

############################ STOP ###################### STOP ################
##############################################################################
