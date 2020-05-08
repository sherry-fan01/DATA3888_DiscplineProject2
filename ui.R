library(shiny) 
library(bomrang) 
library(tidyverse)
library(limma)
library(R.utils)


ui <- fluidPage(
  titlePanel("Prediction of Acute Rejection"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "p", 
                   label = "Choose patient",
                   c("From database"="db", "My file"="mf")),
      br(),
      selectInput(inputId = "id",
                label = "Select a patient from database:",
                choice = 1:34),
      br(),
      fileInput("file1", "Alternatively, upload my csv file:",
                multiple = FALSE,
                accept = ".csv")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction Result", verbatimTextOutput("result")), 
        tabPanel("Data", 
                 column(4,verbatimTextOutput("size")),
                 column(6,
                 style = "overflow-y:scroll; max-height: 600px; position:relative;",
                 tableOutput("data"))), 
        tabPanel("Prediction Model", verbatimTextOutput("rf"))
      )
    )
  )
)