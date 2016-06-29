library(shiny);
library(shinydashboard);


#############################
#####Textarea Function#######
#############################
textareaInput <- function(inputID, label, value="", rows=5) {
  HTML(paste0('<div class="form-group shiny-input-container">
              <label for="', inputID, '">', label,'</label>
              <textarea class="form-control" id="', inputID, 
              '" rows="', rows, '">', value, '</textarea></div>'))
}

#############################
####Google Map Function######
#############################

tags$head(includeScript("https://maps.googleapis.com/maps/api/js?key=AIzaSyCRlZnDsOnVKvB5UMOA2wYTjEakrhPvSZQ&sensor=true"))
tags$head(includeScript(system.file('www', 'initializeMap.js')))

#############################
#####Dashbaord Header########
#############################
header <- dashboardHeader(
  title = "UON Social Analytics",
  dropdownMenu(type = "notifications",
               notificationItem(
                 text = "5 new users today",
                 icon("users")
               ),
               notificationItem(
                 text = "12 items delivered",
                 icon("truck"),
                 status = "success"
               ),
               notificationItem(
                 text = "Server load at 86%",
                 icon = icon("exclamation-triangle"),
                 status = "warning"
               )
  ),
  disable = FALSE
);

#############################
#####Dashboard SideBar#######
#############################
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Analysis", tabName = "analysis", icon = icon("area-chart")),
    menuItem("Reports", tabName = "reports", icon = icon("file")),
    menuItem("About", tabName = "about", icon = icon("info"))
  )
)

body <- dashboardBody(
  tabItems(
   
    ############################
    ########Analysis############
    ############################
    tabItem(tabName = "analysis",
            h2("Analysis"),
            fluidPage(
              mainPanel(
                plotOutput('Top_Source')
              )  
              )
            ),
    
    #############################
    #####Reports Tab#######
    #############################
    tabItem(tabName = "reports",
            h2("Reports"),
            HTML(paste0('<hr style="color:black"/>'))          
            
    ),
    
    #############################
    ######About US Tab ########
    #############################
    tabItem(tabName = "about",
            h2("About Us"),
            p("The objective of the web application is to show the University what their social landscape looks like and what social channels users are using when they are dealing with and mentioning UON on various social networks."),
            p("To develop a clear and precise web application capable of displaying and explaining UoN stakeholders use of social media platforms such as Facebook, Twitter and Instagram."),
            h2("Our Team"),
            fluidRow(
              box(
                title = "Jacob Moran", status = "primary", solidHeader = TRUE,height = 210,
                column(
                  width=6,
                  img(src = "avatar_2x.png", width = 150, align = "center")
                ),
                column( 
                  width=6,
                  p(h2("Jacob Moran")),
                  p("Project Manager"),
                  p("Skills: R, Scrum")
                )
              ),
              box(
                title = "Harikrishnan", status = "primary", solidHeader = TRUE,height = 210,
                column(
                  width=6,
                  img(src = "avatar_2x.png", width = 150, align = "center")
                ),
                column( 
                  width=6,
                  p(h2("Hari krishnan")),
                  p("Front-end Developer"),
                  p("Skills: JavaScript, ASP.Net, R, Shinny")
                )
              ),
              box(
                title = "Alana", status = "primary", solidHeader = TRUE,height = 210,
                column(
                  width=6,
                  img(src = "avatar_2x.png", width = 150, align = "center")
                ),
                column( 
                  width=6,
                  p(h2("Alana")),
                  p("Back-end Developer"),
                  p("Skills: R, Shinny")
                )
              ),
              box(
                title = "Khuyen", status = "primary", solidHeader = TRUE,height = 210,
                column(
                  width=6,
                  img(src = "avatar_2x.png", width = 150, align = "center")
                ),
                column( 
                  width=6,
                  p(h2("Khuyen")),
                  p("Front-end Developer"),
                  p("Skills: JavaScript, ASP.Net, R, Shinny")
                )
              ),
              box(
                title = "Shunji", status = "primary", solidHeader = TRUE,height = 210,
                column(
                  width=6,
                  img(src = "avatar_2x.png", width = 150, align = "center")
                ),
                column( 
                  width=6,
                  p(h2("Shunji")),
                  p("Developer"),
                  p("Skills: Java, ASP.Net, R, Shinny")
                )
              )
            )
    )
   
  )
)


###server <- function(input, output) {
###set.seed(122)
###histdata <- rnorm(500)
  
###output$plot1 <- renderPlot({
###data <- histdata[seq_len(input$slider)]
###hist(data)
###})
###}

###shinyApp(ui, server)

dashboardPage(header, sidebar, body)