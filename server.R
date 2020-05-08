shinyServer(function(input, output) { 
  
  rf_res = read_rds('rf_res.rds')
  patient_db = read_rds("patients_database.rds")
  selectedGene = read_rds("selectedGene.rds")
    
  output$result = renderText({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      colnames(df) = c("RNA_sequence", "Patient_values")
      if (length(df$Patient_values[df$RNA_sequence %in% selectedGene]) < length(selectedGene)) {
        outcome = "invalid" } 
      else {
        outcome = predict(rf_res,
                          df$Patient_values[df$RNA_sequence %in% selectedGene])} 
    }
    else {
      req(input$id)
      ind = as.numeric(input$id)
      Patient_values = patient_db[ind,]
      RNA_sequence = names(Patient_values)
      names(Patient_values) = NULL
      df = data.frame(RNA_sequence,Patient_values)
      outcome = predict(rf_res,df$Patient_values) }
    if (outcome == "Rejection") {
      print("Prediction of kidney transplant: \n\nAcute Cellular Rejection (ACR)")}
    else if (outcome == "invalid") {
      print("Not sufficient gene expressions to predict kidney transplant result") }
    else {print("Prediction of kidney transplant: \n\nStable after transplant") }
    })
  
  output$size = renderText({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      print(paste("Number of genes:",nrow(df))) }
    else {
      print(paste("Number of genes:",length(selectedGene))) }
  })
    
  output$data = renderTable({ 
    if (input$p == "mf") {
      req(input$file1)
      df = read.csv(input$file1$datapath)
      colnames(df) = c("RNA_sequence", "Patient_values") }
    else {
      req(input$id)
      ind = as.numeric(input$id)
      Patient_values = patient_db[ind,]
      RNA_sequence = names(Patient_values)
      names(Patient_values) = NULL
      df = data.frame(RNA_sequence,Patient_values) }
    return(df) 
    })
  
  output$rf = renderText({print("what is rf")})
})
