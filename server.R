library(shiny)

shinyServer(function(input, output) {
  
  #Render the top source via bar chart
  
  output$Top_Source <- renderPlot({
    
    barplot(ts_m, space = 1.5, axisnames = TRUE, col = my_cols, legend = colnames(ts_m), ylim = c(0, 100000))
  
    })
  
  #Render the sentiment via pie chart
  
 ## output$Sentiment <- ({
    
  ##  pie(negCount$freq, posCount$freq, labels = pole, radius = 1.0, main = "POS / NEG Sentiment @ UON", rep(1), col = terrain.colors(5))
 
   ##  })
  
  #Make the wordcloud drawing predictable during a session
  
  wordcloud_rep <- repeatable(wordcloud)
  
  output$buzzPlot <- renderPlot({
   
    wordcloud(tw_dm$word, max.words = 100,  tw_dm$freq, random.order=FALSE, colors=brewer.pal(7, "YlGnBu"))

    })
  
})

