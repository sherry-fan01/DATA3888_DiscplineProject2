shinyServer(function(input, output) { 
  
  rf_res = read_rds('rds/rf_res.rds')
  patient_db = read_rds("rds/patients_database.rds")
  selectedGene = read_rds("rds/selectedGene.rds")
    
  output$result = renderText({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      colnames(df) = c("RNA_seq", "Patient_values")
      if (length(df$Patient_values[df$RNA_seq %in% selectedGene]) < length(selectedGene)) {
        outcome = "invalid" } 
      else {
        outcome = predict(rf_res,
                          df$Patient_values[df$RNA_seq %in% selectedGene])} 
    }
    else {
      req(input$id)
      ind = as.numeric(input$id)
      Patient_values = patient_db[ind,]
      RNA_seq = names(Patient_values)
      names(Patient_values) = NULL
      df = data.frame(RNA_seq,Patient_values)
      outcome = predict(rf_res,df$Patient_values) }
    if (outcome == "Rejection") {
      print("Prediction of kidney transplant: \n\nAcute Cellular Rejection (ACR)")}
    else if (outcome == "invalid") {
      print("Not sufficient RNA sequencing to predict kidney transplant result") }
    else {print("Prediction of kidney transplant: \n\nStable after transplant") }
    })
  
  output$size = renderText({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      print(paste("Number of RNA-seq:",nrow(df))) }
    else {
      print(paste("Number of RNA-seq:",length(selectedGene))) }
  })
    
  output$data = renderTable({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      colnames(df) = c("RNA_seq", "Patient_values") }
    else {
      req(input$id)
      ind = as.numeric(input$id)
      Patient_values = patient_db[ind,]
      RNA_seq = names(Patient_values)
      names(Patient_values) = NULL
      df = data.frame(RNA_seq,Patient_values) }
    return(df) 
    })
  
  output$rf = renderText({
    print("Random forest is an ensemble learning method which constructs many decision trees, and takes the majority of the results from decision trees as the final result. Since there are only 34 patients in the training dataset, random forest is a suitable classifier which could reduce the model instability by averaging multiple decision trees. For 25 repeats of 5-fold cross validation for the training dataset, random forest achives an average accuracy around 0.87.")})
})
