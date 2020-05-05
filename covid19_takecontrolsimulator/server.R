if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(reshape)) install.packages("reshape", repos = "http://cran.us.r-project.org")
if(!require(foreach)) install.packages("foreach", repos = "http://cran.us.r-project.org")
if(!require(doParallel)) install.packages("doParallel", repos = "http://cran.us.r-project.org")


source('functions.R')
server <- function(input, output, session) {
	# City included in the model
    sliderValues <- reactive({
	model_parameter <- GetParams_SEIR(input)
		data.frame(
      		Name = c("level4controlperiod", "Afterlevel4controlperiod", "level2period"),
			begining = c(model_parameter$level4controlperiod[1], model_parameter$Afterlevel4controlperiod[1], model_parameter$level2period[1]),
			end= c(model_parameter$level4controlperiod[2], model_parameter$Afterlevel4controlperiod[2], model_parameter$level2period[2]),
     		stringsAsFactors=FALSE)
  		}) 

	# Show the values using an HTML table
  	output$table2 <- renderTable({
    		sliderValues()
  	})
	
	# Button Try it yourself
	observeEvent(input$JumptoSimulator, {
		updateTabsetPanel(session, "inTabset", selected = "Simulator")
    })
    
	
	# Plot timecourse of all variables
	output$plot_timecourse <- renderPlotly({
		out.list <- ReplicateSimBranchingModel(input)
		control_period <-sliderValues()
		control_period_asdate <- as.Date(c(control_period %>% filter(Name == 'level4controlperiod') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'Afterlevel4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(end) %>% as.numeric()), origin = "2020-03-01")
		#a <- list(x = control_period_asdate[1], y = max(out.list$value), text = 'Level 4')
		Comb.df <- out.list #%>% mutate(timeStep = seq(1, nrow(out.list)))
		Comb.df$timeStep <- as.Date(Comb.df$timeStep, origin = "2020-03-01")
		Comb.melt <- melt(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases", "replication"), id = c("timeStep", "replication"))
		Comb.melt.mean <- melt(aggregate(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases"), list(Comb.df$timeStep), mean) %>% select("timeStep", "Reported cases", "Infected cases"), id = c("timeStep"))
		pal <- c("aquamarine3", "darkgoldenrod2")
		#p <- plot_ly(data = Comb.melt, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value), height = 600, colors = pal)
		p <- plot_ly(data = Comb.melt.mean, height = 600, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', opacity = 1, colors = pal, hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value))
		p <- p %>% add_trace(data = Comb.melt %>% group_by(replication), x = ~timeStep, y = ~value, color = ~variable, opacity =  0.2, type = 'scatter', mode = 'lines', colors = pal, hoverinfo = "none", showlegend = FALSE) 
		p <- layout(p, title = '', xaxis = list(title = ''), yaxis = list(title = 'New COVID-19 cases per day'), 
			#annotations = list(text =c('Level 4', 'Level 3'), textposition = "bottom", font= list(size = 16), x = c(control_period_asdate[1] + 6, control_period_asdate[2] + 6), y = c(max(Comb.melt$value), max(Comb.melt$value)), showarrow = FALSE),
			hovermode = 'compare',
			shapes = list(
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.2,
                 	x0 = control_period_asdate[1], x1 = control_period_asdate[2], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.1,
                  	x0 = control_period_asdate[2], x1 = control_period_asdate[3], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.05,
                  	x0 = control_period_asdate[4], x1 = control_period_asdate[5], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y")
		))
		p	
  		}) 


	observeEvent(input$rerun, {
      	output$plot_timecourse <- renderPlotly({
		out.list <- ReplicateSimBranchingModel(input)
		control_period <-sliderValues()
		control_period_asdate <- as.Date(c(control_period %>% filter(Name == 'level4controlperiod') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'Afterlevel4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(end) %>% as.numeric()), origin = "2020-03-01")
		#print(control_period_asdate)
		Comb.df <- out.list #%>% mutate(timeStep = seq(1, nrow(out.list)))
		Comb.df$timeStep <- as.Date(Comb.df$timeStep, origin = "2020-03-01")
		Comb.melt <- melt(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases", "replication"), id = c("timeStep", "replication"))
		Comb.melt.mean <- melt(aggregate(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases"), list(Comb.df$timeStep), mean) %>% select("timeStep", "Reported cases", "Infected cases"), id = c("timeStep"))
		pal <- c("aquamarine3", "darkgoldenrod2")
		#p <- plot_ly(data = Comb.melt, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value), height = 600, colors = pal)
		p <- plot_ly(data = Comb.melt.mean, height = 600, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', opacity = 1, colors = pal, hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value))
		p <- p %>% add_trace(data = Comb.melt %>% group_by(replication), x = ~timeStep, y = ~value, color = ~variable, opacity =  0.2, type = 'scatter', mode = 'lines', colors = pal, hoverinfo = "none", showlegend = FALSE) 
		p <- layout(p, title = '', xaxis = list(title = ''), yaxis = list(title = 'New COVID-19 cases per day'), 
			#annotations = list(text =c('Level 4', 'Level 3'), textposition = "bottom", font= list(size = 16), x = c(control_period_asdate[1] + 6, control_period_asdate[2] + 6), y = c(max(Comb.melt$value), max(Comb.melt$value)), showarrow = FALSE),
			hovermode = 'compare',
			shapes = list(
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.2,
                 	x0 = control_period_asdate[1], x1 = control_period_asdate[2], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.1,
                  	x0 = control_period_asdate[2], x1 = control_period_asdate[3], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.05,
                  	x0 = control_period_asdate[4], x1 = control_period_asdate[5], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y")
		))
		p	
  		}) 
      })

	# Afterlevel4controlperiod when level4 period is changed
	observeEvent(input$simulation_time, {
       simulation_time <- input$simulation_time
		Level4controlperiod <- input$level4controlperiod
		updateSliderInput(session, 'level4controlperiod', max = simulation_time)
		updateSliderInput(session, 'Afterlevel4controlperiod', max = simulation_time - Level4controlperiod[2])
		updateSliderInput(session, 'level2period', max = simulation_time - Level4controlperiod[2])
    })


	# Reset all parameters if the RESET button is pushed
	observeEvent(input$reset,{
		updateNumericInput(session, "initInf", value = 15)
		updateNumericInput(session, 'LowControlR0', value = 1.1)
		updateNumericInput(session, 'HighControlR0', value = 0.5)
		updateSliderInput(session, 'simulation_time', value = 140)
		simulation_time <- input$simulation_time
		updateSliderInput(session, 'level4controlperiod', value = c(25, 58), max = simulation_time)
		level4controlperiod <- input$level4controlperiod
		updateSliderInput(session, 'Afterlevel4controlperiod', max = 84, value = 28)
		updateSliderInput(session, "level2period", max = 84, value = 28) 
		updateSliderInput(session, "level2R0", value = 1.5) # R0 = 2.5 without control
		updateNumericInput(session, 'R0', value = 2.5)
		updateNumericInput(session, 'EOnsetToS', value = 5.8)
		updateNumericInput(session, "EOnsetToIsol", value = 2.18)
		updateNumericInput(session, 'PSub', value = 33)
		updateNumericInput(session, 'InfS', value = 50)
		updateNumericInput(session, "InfC", value = 65)
		updateNumericInput(session, 'TG', value = 5.67)
		updateNumericInput(session, "Psevere", value = 5.25)
		updatePrettyCheckbox(session, inputId = "AdvanceOptions", value = FALSE)
		updateNumericInput(session, "Nbrep", value = 1.0)
  })
    
}


