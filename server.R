library(shiny)
library(plotrix)

shinyServer(function(input, output) {

  output$piePlot <- renderPlot({
    # Pie Chart from data frame with Appended Sample Sizes
    mytable <- table(iris$Species)
    lbls <- paste(names(mytable), "\n", mytable, sep="")
    pie(mytable, labels = lbls, 
        main="Pie Chart of Species\n (with sample sizes)")
  })

})

