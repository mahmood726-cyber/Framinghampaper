# ====================================================================================
# "PRO" VERSION V8 - SELF-CONTAINED RESEARCH WORKBENCH (COMPLETED)
# Features: Embedded Dataset, Dynamic Model Building, SHAP, Model Comparison
# ====================================================================================

# -- 1. LOAD LIBRARIES --
library(shiny)
library(shinyjs)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(caret)
library(randomForest)
library(xgboost)
library(fastshap)


# -- 2. EMBEDDED DATA & PREP --

# The entire Framingham dataset is embedded directly into the script as a string.
csv_data_string <- "male,age,education,currentSmoker,cigsPerDay,BPMeds,prevalentStroke,prevalentHyp,diabetes,totChol,sysBP,diaBP,BMI,heartRate,glucose,TenYearCHD
1,39,4,0,0,0,0,0,0,195,106,70,26.97,80,77,0
0,46,2,0,0,0,0,0,0,250,121,81,28.73,95,76,0
1,48,1,1,20,0,0,0,0,245,127.5,80,25.34,75,70,0
0,61,3,1,30,0,0,1,0,225,150,95,28.58,65,103,1
0,46,3,1,23,0,0,0,0,285,130,84,23.1,85,85,0
0,43,2,0,0,0,0,1,0,228,180,110,30.3,77,99,0
0,63,1,0,0,0,0,0,0,205,138,71,33.11,60,85,1
0,45,2,1,20,0,0,0,0,313,100,71,21.68,79,78,0
1,52,1,0,0,0,0,1,0,260,141.5,89,26.36,76,79,0
1,43,1,1,30,0,0,1,0,225,162,107,23.61,93,88,0
0,50,1,0,0,0,0,0,0,254,133,76,22.91,75,76,0
0,43,2,0,0,0,0,0,0,247,131,88,27.64,72,61,0
1,46,1,1,15,0,0,1,0,294,142,94,26.31,98,64,0
0,41,3,0,0,1,0,1,0,332,124,88,31.31,65,84,0
0,39,2,1,9,0,0,0,0,226,114,64,22.35,85,NA,0
0,38,2,1,20,0,0,1,0,221,140,90,21.35,95,70,1
1,48,3,1,10,0,0,1,0,232,138,90,22.37,64,72,0
0,46,2,1,20,0,0,0,0,291,112,78,23.38,80,89,1
1,38,2,1,20,0,0,0,0,195,122,84.5,23.24,75,78,0
0,41,2,0,0,0,0,0,0,195,139,88,26.58,75,67,0
0,49,2,0,0,0,0,1,0,252,133.5,86,22.45,80,75,1
0,42,4,0,0,0,0,0,0,265,136.5,86,24.96,65,63,0
0,43,1,0,0,0,0,0,0,194,132,82,21.24,68,69,0
0,52,4,0,0,0,0,1,0,234,148,92,26.52,70,84,0
1,58,1,1,20,0,0,1,0,237,148,89,27.97,75,NA,0
1,64,1,1,30,0,0,0,0,243,126,80,24.63,75,NA,0
0,47,2,1,20,0,0,0,0,230,130,86,24.18,75,79,0
0,60,1,0,0,0,0,0,0,252,125,80,22.18,69,83,0
0,36,4,0,0,0,0,0,0,230,119,77.5,23.38,72,71,0
1,42,2,1,10,0,0,0,0,210,135,87.5,23.99,83,75,0
1,54,2,0,0,0,0,1,0,280,140,92.5,27.18,75,73,0
1,48,2,1,25,0,0,1,0,248,136,87.5,28.61,70,NA,0
0,56,1,0,0,0,0,0,0,323,124,80.5,24.13,68,96,1
1,47,1,1,20,0,0,1,0,240,142.5,91,28.69,70,68,0
0,57,3,1,15,0,0,0,0,240,123,81,22.04,65,70,0
1,60,1,0,0,0,0,0,0,261,120,77.5,24.83,70,90,0
1,58,2,0,0,0,0,1,0,270,148,88,27.36,80,75,0
0,61,1,0,0,0,0,1,0,244,142.5,87,23.63,65,80,0
0,43,1,0,0,0,0,1,0,250,147,94,27.77,65,65,0
1,63,1,1,20,0,0,1,0,195,160,100,30.33,65,65,1
0,46,1,1,10,0,0,0,0,235,127,82,23.28,75,NA,0
0,56,2,0,0,0,0,1,0,266,160,98,25.99,69,82,0
1,59,1,1,20,0,0,1,0,251,152,100,22.93,72,70,0
1,44,4,0,0,0,0,0,0,202,122.5,82.5,23.48,68,NA,0
0,48,1,0,0,0,0,1,0,223,130,80,24.77,75,75,0
1,46,1,1,20,0,0,0,0,255,130,85,27.91,72,NA,0
0,50,2,0,0,0,0,0,0,217,110,76,21.87,85,60,0
1,40,2,1,10,0,0,1,0,220,130,85,21.51,65,72,0
1,54,3,1,15,0,0,1,0,210,132.5,82.5,23.77,68,80,0
0,63,2,0,0,0,0,1,0,262,155,95,29.98,72,NA,0
1,43,1,1,15,0,0,0,0,250,115,80,26.46,72,75,0
1,64,2,1,20,0,0,1,0,254,142,92,27.42,80,79,0
1,41,1,1,25,0,0,0,0,200,121,81,24.26,80,79,0
0,53,3,0,0,0,0,0,0,288,110,74,22.5,70,72,0
0,44,2,0,0,0,0,0,0,207,110,76,24.22,65,84,0
0,63,1,0,0,0,0,1,0,296,130,83,32.96,65,74,0
1,40,2,1,20,0,0,0,0,190,112.5,75,23.51,75,82,0
0,46,1,1,9,0,0,0,0,235,122,81,25.43,85,NA,0
1,41,1,1,40,0,0,0,0,240,135,85,26.42,85,72,0
1,49,1,1,3,0,0,1,0,255,142,92,26.98,82,72,1
0,41,2,0,0,0,0,0,0,237,123,80.5,23.98,85,74,0
0,51,2,0,0,0,0,0,0,275,127,85,26.98,75,71,0
1,54,1,1,20,0,0,0,0,248,132,88,28.83,80,68,0
0,42,3,0,0,0,0,0,0,220,110,70,22.21,68,75,0
1,63,1,1,20,0,0,0,0,260,140,85,24.64,80,72,0
0,41,2,0,0,0,0,0,0,217,117.5,77.5,25.0,72,67,0
0,41,2,0,0,0,0,0,0,210,125,75,22.18,80,73,0
1,52,2,0,0,0,0,0,0,245,130,85,25.32,75,NA,0
1,54,1,1,43,0,0,1,0,292,155,97,29.94,80,63,1
0,56,3,0,0,0,0,1,1,280,140,90,26.04,75,130,1
0,45,2,1,20,0,0,1,0,252,145,86,24.58,75,NA,0
1,45,1,1,20,0,0,1,0,240,145,96,25.54,75,80,0
0,57,3,1,20,0,0,0,0,230,124,78,21.56,85,79,0
1,48,2,0,0,0,0,1,0,250,140,90,23.7,75,77,0
0,42,1,0,0,0,0,0,0,220,120,78,25.21,70,NA,0
0,59,2,0,0,0,0,1,0,260,140,90,26.45,70,81,0
0,49,2,0,0,0,0,0,0,233,126.5,80,21.39,80,70,1
0,56,1,0,0,0,0,1,0,283,142,91,24.3,65,NA,0
1,51,3,1,20,0,0,1,0,250,140,88,27.35,75,83,0
0,50,2,0,0,0,0,1,0,270,142,94,22.61,65,85,0
1,59,3,1,20,0,0,1,0,260,150,95,29.35,72,81,0
0,57,1,1,20,0,0,0,0,220,120,76,24.37,72,75,0
0,49,2,0,0,0,0,1,0,280,144,90,28.27,65,85,0
0,48,1,0,0,0,0,0,0,245,117,73,23.16,68,NA,0
1,62,1,0,0,0,0,1,0,260,155,100,26.11,70,NA,0
0,59,1,0,0,0,0,1,0,235,142,85,27.97,72,83,1
0,41,2,0,0,0,0,0,0,237,126.5,76.5,23.32,68,75,0
1,56,1,1,20,0,0,1,0,280,150,92,26.91,72,74,0
1,46,1,1,20,0,0,1,0,268,143,92,25.9,78,65,0
0,56,3,0,0,0,0,1,0,300,140,90,24.42,75,80,0"

# Use check.names = FALSE to prevent R from changing special characters in names
full_data <- read.csv(text = csv_data_string, check.names = FALSE)

# Prepare the dataset by renaming columns to match app logic and converting gender
data_with_bmi <- full_data %>%
  rename(
    Gender = male,
    Age = age,
    BMI = BMI
  ) %>%
  mutate(
    Gender = ifelse(Gender == 1, "Male", "Female")
  )

# Define choices for UI elements
predictor_choices <- c("Age", "Gender", "BMI")
outcome_choices <- c("totChol", "sysBP", "glucose")


# ====================================================================================
# -- 3. USER INTERFACE (UI) --
# ====================================================================================
ui <- tagList(
  useShinyjs(),
  navbarPage(
    "Cardiac Analysis Research Workbench (PRO)",
    theme = shinytheme("cosmo"),

    # --- TAB 1: INTERACTIVE ANALYSIS ---
    tabPanel("Analysis Workbench",
             sidebarLayout(
               sidebarPanel(
                 h4("1. Select Analysis Parameters"),
                 selectInput("outcome", "Outcome Variable:", choices = outcome_choices, selected = "totChol"),
                 checkboxGroupInput("predictors", "Predictor Variables:", choices = predictor_choices, selected = predictor_choices),
                 selectInput("model_type", "Machine Learning Model:", choices = c("Random Forest" = "rf", "XGBoost" = "xgbTree")),
                 actionButton("run_analysis_btn", "Run New Analysis", icon = icon("play-circle"), class = "btn-primary btn-lg"),
                 hr(),
                 # Add a clear history button, which will only be shown if there's history
                 uiOutput("clear_history_ui")
               ),
               mainPanel(
                 tabsetPanel(
                   id = "main_tabs",
                   tabPanel("Model Performance",
                            h3("Latest Model Performance"),
                            verbatimTextOutput("cv_results_text"),
                            hr(),
                            plotOutput("actual_vs_predicted_plot")
                   ),
                   tabPanel("Feature Importance",
                            plotOutput("feature_importance_plot")
                   ),
                   tabPanel("Model Explainability (SHAP)",
                            h4("SHAP Summary Plot"),
                            p("This plot shows the impact of each feature on the model's output. Features are ranked by importance."),
                            plotOutput("shap_summary_plot")
                   ),
                   # NEW FEATURE: Comparison Tab
                   tabPanel("Model Comparison",
                            h3("Side-by-Side Model Comparison"),
                            p("This tab compares the results of your most recent analyses. Run at least two analyses to see a comparison."),
                            hr(),
                            uiOutput("comparison_output_ui")
                   )
                 )
               )
             )
    ),

    # --- TAB 2: LIVE PREDICTION ---
    tabPanel("Live Patient Prediction",
             conditionalPanel(
               condition = "!output.model_ready",
               fluidPage(
                 style = "padding-top: 20px;",
                 h3("Prediction Engine Not Ready"),
                 p("Please go to the 'Analysis Workbench' tab and click 'Run New Analysis' to train a model first.", style = "font-size: 1.1em;")
               )
             ),
             conditionalPanel(
               condition = "output.model_ready",
               sidebarLayout(
                 sidebarPanel(
                   h4("Enter New Patient Details"),
                   uiOutput("live_predictor_controls")
                 ),
                 mainPanel(
                   h3("Prediction"),
                   div(style = "border: 1px solid #ddd; padding: 15px; border-radius: 5px; background-color: #f0f8ff;",
                       h4(textOutput("live_prediction_text"))
                   ),
                   hr(),
                   h3("Prediction Explanation (SHAP)"),
                   plotOutput("live_shap_plot")
                 )
               )
             )
    )
  )
)

# ====================================================================================
# -- 4. SERVER LOGIC --
# ====================================================================================
server <- function(input, output, session) {

  # -- Reactive Values for State Management --
  model_ready <- reactiveVal(FALSE)
  history <- reactiveVal(list()) # To store a list of analysis results

  # -- Conditional UI Rendering --
  output$model_ready <- reactive({
    return(model_ready())
  })
  outputOptions(output, 'model_ready', suspendWhenHidden = FALSE)
  
  output$clear_history_ui <- renderUI({
      if(length(history()) > 0){
          actionButton("clear_history_btn", "Clear Comparison History", icon = icon("trash-alt"), class = "btn-warning btn-sm")
      }
  })

  # -- Core Model Training Logic --
  observeEvent(input$run_analysis_btn, {
    req(input$outcome, input$predictors)

    showNotification("Running 10-fold cross-validation...", type = "message", duration = 5)

    # Use a progress indicator for a better user experience during training
    withProgress(message = 'Training Model...', value = 0, {
      
      setProgress(1/3, detail = "Preparing data...")
      
      formula_str <- paste0("`", input$outcome, "` ~ ", paste(input$predictors, collapse = " + "))
      formula <- as.formula(formula_str)

      model_data <- data_with_bmi %>%
        select(all_of(c(input$outcome, input$predictors))) %>%
        na.omit()

      validate(need(nrow(model_data) > 0, "No complete data for the selected outcome and predictors."))

      setProgress(2/3, detail = "Cross-validating...")

      train_control <- trainControl(method = "cv", number = 10, savePredictions = "final")

      model <- train(formula,
                     data = model_data,
                     method = input$model_type,
                     trControl = train_control,
                     preProcess = c("center", "scale"))

      setProgress(3/3, detail = "Calculating SHAP values...")

      X_shap <- model_data[, input$predictors, drop = FALSE]
      explainer <- fastshap::explain(model, X = X_shap, pred_wrapper = predict, nsim = 30)
      
      new_result <- list(
        model = model,
        explainer = explainer,
        outcome = input$outcome,
        predictors = input$predictors,
        timestamp = Sys.time()
      )

      # Add new result to the history
      current_history <- history()
      updated_history <- c(list(new_result), current_history)
      if (length(updated_history) > 3) { # Keep only the last 3 runs
        updated_history <- updated_history[1:3]
      }
      history(updated_history)
      model_ready(TRUE) # Set model as ready for prediction
    })
  })
  
  # Reactive expression that always points to the latest results
  analysis_results <- reactive({
      req(length(history()) > 0)
      history()[[1]]
  })
  
  # -- Clear History Logic --
  observeEvent(input$clear_history_btn, {
      history(list())
      model_ready(FALSE)
      showNotification("Comparison history has been cleared.", type = "message")
  })


  # --- RENDER ANALYSIS OUTPUTS for the LATEST run ---
  output$cv_results_text <- renderPrint({
    req(analysis_results())
    print(analysis_results()$model)
  })

  output$actual_vs_predicted_plot <- renderPlot({
    req(analysis_results())
    res <- analysis_results()
    df <- data.frame(obs = res$model$pred$obs, pred = res$model$pred$pred)
    ggplot(df, aes(x = obs, y = pred)) +
      geom_point(color = "dodgerblue", alpha = 0.7) +
      geom_abline(color = "red", linetype = "dashed") +
      labs(title = paste("Actual vs. Predicted for", res$outcome), x = "Actual Values", y = "Predicted Values") +
      theme_minimal(base_size = 16)
  })

  output$feature_importance_plot <- renderPlot({
    req(analysis_results())
    plot(varImp(analysis_results()$model), main = "Latest Model: Feature Importance")
  })

  output$shap_summary_plot <- renderPlot({
    req(analysis_results())
    plot(analysis_results()$explainer, type = "summary", main = "Latest Model: SHAP Summary Plot")
  })
  
  # --- COMPARISON TAB LOGIC ---
  output$comparison_output_ui <- renderUI({
      hist_data <- history()
      if (length(hist_data) < 2) {
          return(p("Run at least two different analyses to see a side-by-side comparison here.", style = "font-size: 1.1em; padding-top: 20px;"))
      }
      tagList(
          h4("Performance Metrics"),
          tableOutput("comparison_table"),
          hr(),
          h4("Feature Importance Comparison"),
          p("Comparing the two most recent models."),
          plotOutput("comparison_fi_plot"),
          hr(),
          h4("SHAP Summary Comparison"),
          p("Comparing the two most recent models."),
          plotOutput("comparison_shap_plot")
      )
  })

  output$comparison_table <- renderTable({
      hist_data <- history()
      req(length(hist_data) >= 1)

      summary_df <- purrr::map_dfr(rev(hist_data), function(res) {
          # Find the performance of the best tune
          best_perf <- res$model$results[which.min(res$model$results$RMSE), ]
          tibble(
              "Run Time" = format(res$timestamp, "%H:%M:%S"),
              "Model" = res$model$modelInfo$label,
              "Outcome" = res$outcome,
              "RMSE" = round(best_perf$RMSE, 2),
              "R-squared" = round(best_perf$Rsquared, 3)
          )
      })
      summary_df
  }, align = 'c')
  
  output$comparison_fi_plot <- renderPlot({
      hist_data <- history()
      req(length(hist_data) >= 2)
      
      model1 <- hist_data[[2]]$model
      model2 <- hist_data[[1]]$model
      
      par(mfrow = c(1, 2))
      plot(varImp(model1), main = paste("Older Run:", model1$modelInfo$label))
      plot(varImp(model2), main = paste("Latest Run:", model2$modelInfo$label))
      par(mfrow = c(1, 1))
  })

  output$comparison_shap_plot <- renderPlot({
      hist_data <- history()
      req(length(hist_data) >= 2)
      
      explainer1 <- hist_data[[2]]$explainer
      explainer2 <- hist_data[[1]]$explainer
      
      par(mfrow = c(1, 2))
      plot(explainer1, type = "summary", main = paste("Older Run:", hist_data[[2]]$model$modelInfo$label))
      plot(explainer2, type = "summary", main = paste("Latest Run:", hist_data[[1]]$model$modelInfo$label))
      par(mfrow = c(1, 1))
  })

  # --- LIVE PREDICTION LOGIC ---
  output$live_predictor_controls <- renderUI({
    req(analysis_results())
    predictors <- analysis_results()$predictors
    
    controls <- list()
    if ("Age" %in% predictors) controls[[1]] <- sliderInput("live_age", "Age:", min = 18, max = 90, value = 50)
    if ("Gender" %in% predictors) controls[[2]] <- selectInput("live_gender", "Gender:", choices = c("Male", "Female"))
    if ("BMI" %in% predictors) controls[[3]] <- sliderInput("live_bmi", "BMI:", min = 15, max = 50, value = 25, step = 0.1)
    
    tagList(controls, actionButton("live_predict_btn", "Predict", class = "btn-success"))
  })

  live_prediction_data <- eventReactive(input$live_predict_btn, {
    req(analysis_results())
    if ("Age" %in% analysis_results()$predictors) req(input$live_age)
    if ("Gender" %in% analysis_results()$predictors) req(input$live_gender)
    if ("BMI" %in% analysis_results()$predictors) req(input$live_bmi)

    model_info <- analysis_results()
    
    new_data_list <- list()
    if ("Age" %in% model_info$predictors) new_data_list$Age <- input$live_age
    if ("Gender" %in% model_info$predictors) new_data_list$Gender <- input$live_gender
    if ("BMI" %in% model_info$predictors) new_data_list$BMI <- input$live_bmi
    new_patient_df <- as.data.frame(new_data_list)
    
    prediction_value <- predict(model_info$model, newdata = new_patient_df)
    
    shap_explanation <- fastshap::explain(model_info$model, X = new_patient_df, pred_wrapper = predict)
    
    return(list(
      prediction = prediction_value,
      shap_explanation = shap_explanation
    ))
  })

  output$live_prediction_text <- renderText({
    req(live_prediction_data())
    pred_obj <- live_prediction_data()$prediction
    paste0("Predicted ", analysis_results()$outcome, ": ", round(pred_obj, 2))
  })

  output$live_shap_plot <- renderPlot({
    req(live_prediction_data())
    plot(live_prediction_data()$shap_explanation, type = "individual", row_num = 1)
  })
}


# ====================================================================================
# -- 5. RUN THE APP --
# ====================================================================================
shinyApp(ui = ui, server = server)
