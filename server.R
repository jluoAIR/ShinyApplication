library(shiny)
library(ggplot2)

attach(mtcars)
data <- read.csv("Tornado1950_2015.csv")
data_year <- aggregate(data,by=list(data$Year), FUN=sum, na.rm=TRUE )
data_year <- data_year[,c(-2,-3)]
names(data_year) <- names(data)[-2]
data_ef <- aggregate(data[,3:6],by=list(as.factor(data$FSCALE)), FUN=sum, na.rm=TRUE )
names(data_ef)[names(data_ef)=="Group.1"] <- "FScale"

shinyServer(
  function(input, output) {
      output$otimePeriod1 <- renderPrint({input$timePeriod[1]})
      output$otimePeriod2 <- renderPrint({input$timePeriod[2]})

      #loss plot
      output$otrend = renderPrint({input$trend})
      observe({
      if(input$trend)
        output$LossPlot<- renderPlot({
          ggplot(data_year, aes(x=Year, y=LOSS2015))+ geom_point(shape=1) +geom_smooth(method=lm, se=TRUE) +
            xlim(input$timePeriod[1],input$timePeriod[2])+ggtitle("Treaded Loss by Year") +
            labs(x="Year",y="Loss in 2015 Value (M$)")  
       })else
        output$LossPlot<- renderPlot({
          ggplot(data_year, aes(x=Year, y=LOSS))+ geom_point(shape=1) +geom_smooth(method=lm, se=TRUE) +
            xlim(input$timePeriod[1],input$timePeriod[2])+ggtitle("Original Loss by Year") +
            labs(x="Year",y="Original Loss (M$)")   
      })
      })

      #intensity
      output$oef= renderPrint({input$ef})
      observe({
        if(input$trend)
      output$Loss_EF_Plot<- renderPlot({
        ggplot(subset(data,FSCALE%in%input$ef), aes(x=Year, y=LOSS2015, fill=as.factor(FSCALE)))+
          geom_bar(width = 1, stat = "identity") +ggtitle("Treaded Loss by Year by Intensity") +
          labs(x="Year",y="Loss in 2015 Value (M$)")  
      })else
        output$Loss_EF_Plot<- renderPlot({
          ggplot(subset(data,FSCALE%in%input$ef), aes(x=Year, y=LOSS, fill=as.factor(FSCALE)))+
            geom_bar(width = 1, stat = "identity")+ggtitle("Original Loss by Year by Intensity") +
            labs(x="Year",y="Original Loss (M$)")  
        })
      })
      
      # Injury and fatality by EF scale
      output$injuryPlot<- renderPlot({
    #    ggplot(data_ef, aes(x=input$ef, y=LOSS)) + geom_boxplot()
        ggplot(data_ef, aes(x="", y=INJURIES, fill=FScale)) + coord_polar("y", start=0)+
          geom_bar(width = 1, stat = "identity") +
          geom_text(aes(y = INJURIES/3 +c(0, cumsum(INJURIES)[-length(INJURIES)]),label = INJURIES, size=5))
        })
    output$fatalityPlot<- renderPlot({
      ggplot(data_ef, aes(x="", y=FATALITIES, fill=FScale)) + coord_polar("y", start=0)+
        geom_bar(width = 1, stat = "identity") +
        geom_text(aes(y = FATALITIES/3 +c(0, cumsum(FATALITIES)[-length(FATALITIES)]),label = FATALITIES, size=5))
    })
    output$injury_EF_Plot<- renderPlot({
      ggplot(subset(data,FSCALE%in%input$ef), aes(x=Year, y=INJURIES, fill=as.factor(FSCALE)))+
        geom_bar(width = 1, stat = "identity") +ggtitle("Injuries by Year by Intensity") +
        labs(x="Year",y="Injures")  
    })
    output$fatality_EF_Plot<- renderPlot({
      ggplot(subset(data,FSCALE%in%input$ef), aes(x=Year, y=FATALITIES, fill=as.factor(FSCALE)))+
        geom_bar(width = 1, stat = "identity") +ggtitle("Fatalites by Year by Intensity") +
        labs(x="Year",y="Injures")  
    })    
    
      
  }
)
