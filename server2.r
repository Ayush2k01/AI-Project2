library(shiny)
library(caret)
library(dplyr)
library(tidyr)
library(flexdashboard)
library(shinydashboard)
library(plotly)
library(ggplot2)
data2y <- read.csv("transactions-2.csv") ## Items
print(data2y)
data0y2 <- select(data2y,fraud,income1,same_city,same_count,seller_sco,dispersao,type,V11,V12,V12.1)
##print(data0y2)
fitx  <- ctree(fraud~income1+same_city+same_count+type+seller_sco+dispersao+V11+V12+V12.1, data = data0y2) ##
shinyServer(
  function(input,output){
  
    output$myincome       <- renderText(paste("You selected the income as: ",input$income," CAD"))
    output$mycity         <- renderText(paste("You selected the buyer in the same city of the seller: ",input$city))
    output$mytype         <- renderText(paste("You selected the type of the transaction as: ",input$type))
    output$myscore        <- renderText(paste("You selected the score of the seller as: ",input$score))
    output$myvalue        <- renderText(paste("You selected the value of the transaction as: ",input$value, " CAD"))
    # Reactive expression to create data frame of all input values ----
    inputData <- reactive({
      
       
        value = (c(input$income, input$city,input$type, input$score, input$value)) ##input$recen,input$tela,input$telo,input$enrri
      
    })
    
    # Use model on input data
    
    df_5 <- reactive({
      data1 <- (inputData())
      setwd("/Curso-ML/Assignment-3/")
      data2 <- read.csv("clustered.csv") ## Items
      ##print(data2)
      
      ## income
      tincom1 <- as.numeric(data1[1])
      print(tincom1)
      
      if (tincom1 <= (1874*12)){ ## 1
        tclasse <- 5
      } ##1
      else{##2
        
        if (tincom1 > (1874*12) & tincom1<=(3748*12)){##3
          tclasse <- 4
        }##3
        else{##4
          
        if (tincom1>(3748*12) & tincom1<=(9370*12)){##5
          tclasse <- 3
        }##5
        else{##6
        if (tincom1>(9370*12) & tincom1<=(18740*12)){##7
          tclasse <- 2
        }##7
        else{##8
          tclasse <- 1
            }##8
           }##6
          }##4
         }##2
      
      ttincom1 <- tclasse
      print(ttincom1)
      print(data1[2])
      ## same city
      if (data1[2]=="Same city of the seller"){
        tcity    <- 1
        tcountry <- 1
      }

      ## same country
      if (data1[2]=="Different city but same country"){
        tcity    <- 0
        tcountry <- 1
      }
      if (data1[2]=="Different city and country"){
        tcity    <- 0
        tcountry <- 0
      }
      print(tcity)
      print(tcountry)
      
      ### Types of transactions
      print(data1[3])
      if (data1[3]=="Recurrent"){
        ttype1 <- 0
      }
      else{
        if (data1[3]=="Presential goods"){
          ttype1 <- 1
        }
        else{
          if (data1[3]=="Presential services"){
            ttype1 <- 2
          }
         else{
           if (data1[3]=="on-line goods"){
             ttype1 <- 3
           } 
           else{
             ttype1 <- 4 
           }
           
         } 
          
        }
        
      }
      print(ttype1)
      ## Normalizing 
   
      dispersion <- as.numeric(data1[5])
      print(dispersion)
      ttincom1      <- ttincom1/5
      ttcity1       <- tcity
      ttcountry1    <- tcountry
      tttype1       <- ttype1/4
      ttscore1      <- as.numeric(data1[4])/100
      ttdispersion1 <- (abs(774.2095-dispersion)/750)
      print(ttdispersion1)
      
      menor <- 10000000
      len2 <- nrow(data2)
      ##print(len2)
      contador2 <- 1
      while (contador2 <= len2){ ## nodes
        ##print(contador2)
        ttincom2       <- data2[contador2,3]
        ttcity2        <- data2[contador2,4]
        ttcountry2     <- data2[contador2,5]
        tttype2        <- data2[contador2,6]
        ttscore2       <- data2[contador2,7]
        ttdispersion2  <- data2[contador2,8]

        
        ## Subtraction section 
        
        
        ttincom3         <-  ttincom1      - ttincom2
        ttcity3          <-  ttcity1       - ttcity2
        ttcountry3       <-  ttcountry1    - ttcountry2
        tttype3          <-  tttype1       - tttype2
        ttscore3         <-  ttscore1      - ttscore2
        ttdispersion3    <-  ttdispersion1 - ttdispersion2

        
        quadrado <- ((ttincom3**2)+(ttcity3**2)+(ttcountry3**2)+(tttype3**2)+(ttscore3**2)+(ttdispersion3**2))
        
        d <- (quadrado**1/2)
        
        if (d<menor & d!=0){ ## selection of the best cluster (small distance)
          registro1 <- data2[contador2,1] 
          registro  <- contador2
          menor <- d
        }
        
        contador2 <- contador2 + 1
      } ## end loop contador 2
      
      print(data2)
   
      value1 =  data2[registro,9] ## positive percentage
      value2 =  data2[registro,10] ## negative percentage
      
      print(registro)
      print(value1)
      print(value2)
      mean4  <- 0.23
      mean5  <- 0.78
      mean6  <- 0.89
      mean7  <- 0.4901
      mean8  <- 0.03127
      mean9  <- 0.5118
      mean10 <- 0.2696
      mean11 <- 0.73
     
      pontos <-0
        if (ttincom1<= mean4){
          pontos=pontos+1
        }
        if (ttcity1<= mean5){
          pontos=pontos+1
        }
        if (ttcountry1<= mean6){
          pontos=pontos+1
        }
        if (tttype1<= mean7){
          pontos=pontos+1
        }
        if (ttscore1>= mean8){
          pontos=pontos+1
        }
        if (ttdispersion1>= mean9){
          pontos=pontos+1
        }
        if (value1>= mean10){
          pontos=pontos+1
        }
        if (value2<= mean11){
          pontos=pontos+1
        }
       print(pontos)
       df <- data.frame("N",ttincom1,ttcity1,ttcountry1,tttype1,ttscore1,ttdispersion1,value1,value2,pontos)
       df <- as.data.frame(df)
       colnames(df)<- c("fraud","income1","same_city","same_count","type","seller_sco","dispersao","V11","V12","V12.1")
       print(df)
       predicao2 <- predict(fitx, newdata=df)
       str(df)
       class(df)
       if (predicao2=="N"){
         predicao3 <- 1
         predicao2 <- "Not fraud"
       }
       else{
         predicao3 <- 2
         predicao2 <- "Fraud"
       }
       df1 <- data.frame(Item = predicao2        , Value = predicao3)
       df1 <- rbind(df1, data.frame(Item= "Income impact   ", Value=(ttincom1*100)))
       df1 <- rbind(df1, data.frame(Item = "Location       ", Value = (((ttcity1+ttcountry1)/2))*100))
       df1 <- rbind(df1, data.frame(Item = "Type           ", Value = (tttype1)*100))
       df1 <- rbind(df1, data.frame(Item = "Seller score   ", Value = (ttscore1*100)))
       df1 <- rbind(df1, data.frame(Item = "% Dispersion   ", Value = (ttdispersion1)*100))
       df1 <- rbind(df1, data.frame(Item = "% of frauds    ", Value = value1*100))
       df1 <- rbind(df1, data.frame(Item = "% of not fraud ", Value = value2*100))
       df1 <- rbind(df1, data.frame(Item = "Points         ", Value = (pontos/8)*100))
       
       print(df1)

       df1 <- as.data.frame(df1)
       colnames(df1) <- c("Item", "Value")
       print(predicao2)
       print(df1)
      
      })
    output$view   <- renderTable({df_5()})
    output$hist <-renderPlot({
      ggplot(df_5(),x= Item, y=Value, aes(Item, y = round(Value, digits = 0), fill=Item)) + 
        geom_bar(stat="identity", position = 'dodge') +
        geom_text(aes(label=round(Value, digits = 2)), position=position_dodge(width=0.9), vjust=-0.25)

      ##output$test <- renderGauge({
     
      ##gauge(round((df_5()),2), min = 0, max = 100, symbol = '%',  label = paste("Chance to be a fraud"),gaugeSectors( success = c(0, 49), warning = c(50, 79), danger = c(80, 100) ))
     
      
      })

  
 
  
})

