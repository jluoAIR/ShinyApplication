library(shiny)
require(markdown)
EFScale <- c("EF scale 0" = "0",
             "EF scale 1" = "1",
             "EF scale 2" = "2",
             "EF scale 3" = "3",
             "EF scale 4" = "4",
             "EF scale 5" = "5")
shinyUI(
  navbarPage("The Analysis of Tornado Loss in USA ", 
             tabPanel("Economic Loss Data and Model",  
                      pageWithSidebar(
                        headerPanel(""),
                        sidebarPanel(
                          sliderInput('timePeriod', 'Time Period', min = 1950,max = 2015, value = c(1950, 1995)),
                          checkboxInput('trend', 'trend Loss to 2015 value'),
                          checkboxGroupInput("ef", "Intensity",choices =EFScale,selected =EFScale)
                        ),
                        mainPanel(
                          h3('Tornado-Related Economic Loss in USA'),
                          
                          h4('The Economic Loss from Tornado across the Year (with Regression Model)'),
                          plotOutput('LossPlot'),
                          
                          h4('The Economic Loss from Tornado across the Year by Intensity'),
                          plotOutput('Loss_EF_Plot'),
                          
                          h3('Parameters chosen'),
                          h4('Trend Loss to 2015 value'), #Original Loss
                          verbatimTextOutput("otrend"),
                          h4('The study time period starts from the year:'),
                          verbatimTextOutput("otimePeriod1"),
                          h4('The study time period ends at the year:'),
                          verbatimTextOutput("otimePeriod2"),
                          h4('The intensity of the tornado to be studied:'),
                          verbatimTextOutput("oef")  
                        ))),
             tabPanel("Fatalites and Injuries",
                      mainPanel(
                        h3('Tornado-Related Deaths and Injuries in USA'),
                        h4('The Fatalites from Tornado across the Year by Intensities'),
                        plotOutput('fatality_EF_Plot'),
                        h4('The Fatalites from Tornado by Intensities'),
                        plotOutput('fatalityPlot'),
                        h4('The Injuries from Tornado across the Year by Intensities'),
                        plotOutput('injury_EF_Plot'),
                        h4('The Injuries from Tornado by Intensities'),
                        plotOutput('injuryPlot')
                      )
             ),
             tabPanel("About",
                      mainPanel(
                        includeHTML("About.htm")
                      )
             ) 
  )
)
  
