if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(reshape)) install.packages("reshape", repos = "http://cran.us.r-project.org")


source('functions.R')
server <- function(input, output, session) {
	

	# City included in the model
    sliderValues <- reactive({
	model_parameter <- GetParams_SEIR(input)
		data.frame(
      		Name = c("level4controlperiod", "Afterlevel4controlperiod", "level2period", "level1period"),
			begining = c(model_parameter$level4controlperiod[1], model_parameter$Afterlevel4controlperiod[1], model_parameter$level2period[1], model_parameter$level1period[1]),
			end= c(model_parameter$level4controlperiod[2], model_parameter$Afterlevel4controlperiod[2], model_parameter$level2period[2], model_parameter$level1period[2]),
     		stringsAsFactors=FALSE)
  		}) 

	# Show the values using an HTML table
  	output$table2 <- renderTable({
    		sliderValues()
  	})
	
	# Button Try it yourself
	observeEvent(input$JumptoSimulator, {
		updateTabsetPanel(session, "inTabset", selected = "Simulator")
		updateNumericInput(session, 'HighControlR0', value = input$Rlevel4) # simulator R during level 4
		updateNumericInput(session, 'LowControlR0', value = input$Rlevel3) # simulator R during level 3
		updateSliderInput(session, "level2R0", value = input$Rlevel2) # simulator R during level 2
		updateSliderInput(session, "level1R0", value = input$Rlevel1) # simulator R during level 1
    })

	#observeEvent(input$Rcalculatortab, {
	#	updateNumericInput(session, 'Rlevel1', value = 2.2) # simulator R during level 4
	#	updateNumericInput(session, 'Rlevel2', value = 1.8) # simulator R during level 3
	#	updateSliderInput(session, "Rlevel3", value = 1) # simulator R during level 2
	#	updateSliderInput(session, "Rlevel4", value = 0.4) # simulator R during level 1
    #})
    
	output$Rcalculator <- renderPlotly({
	Rvalues <- Rcalulator(input)
	Rcal <- plot_ly(
 		domain = list(x = c(0, 1), y = c(0, 0.8)),
 		value = Rvalues,
  		title = NULL,# list(text = "The reproduction number is now"),
  		type = "indicator",
  		mode = "gauge+number",
  		#delta = list(reference = 2.5),
  		gauge = list(
			axis = list(range = list(NULL, 3)),
			bar = list(color = "#2c9c91"),
			steps = list(
		  		list(range = c(0, 1), color = "white"),
		  		list(range = c(1, 3), color = "#edbb98")),
			threshold = list(line = list(color = "#e1001a", width = 4), thickness = 1, value = 1)
		)) 
		Rcal <- Rcal %>% layout(paper_bgcolor = "rgba(0, 0, 0, 0)", margin = list(l = 20, r = 30, b = -10))
	Rcal
	})
	
	# Plot timecourse of all variables
	output$plot_timecourse <- renderPlotly({
		out.list <- ReplicateSimBranchingModel(input)
		control_period <-sliderValues()
		control_period_asdate <- as.Date(c(control_period %>% filter(Name == 'level4controlperiod') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'Afterlevel4controlperiod') %>% select(end) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level2period') %>% select(end) %>% as.numeric(),
								control_period %>% filter(Name == 'level1period') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level1period') %>% select(end) %>% as.numeric()), origin = "2020-03-01")
		#a <- list(x = control_period_asdate[1], y = max(out.list$value), text = 'Level 4')
		Comb.df <- out.list #%>% mutate(timeStep = seq(1, nrow(out.list)))
		Comb.df$timeStep <- as.Date(Comb.df$timeStep, origin = "2020-03-01")
		Comb.melt <- melt(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases", "replication"), id = c("timeStep", "replication"))
		# Select one replicate to plot in bold
		Comb.melt.mean <- Comb.melt %>% filter(replication == 1)
		# Limit of y axis
		ymax <- 2000
		if(max(Comb.melt$value) < 2000){ymax <- max(Comb.melt$value)}
		if(max(Comb.melt[as.Date(Comb.melt$timeStep) < "2020-04-28", "value"]) > 2000){ymax <- max(Comb.melt[as.Date(Comb.melt$timeStep) < "2020-04-28", "value"])}
		# text to display
		nb_replicates <- max(Comb.melt$replication)
		if(input$DoNothingscenario == "Yes"){nb_outbreak <- nrow(Comb.melt[(Comb.melt$timeStep == max(Comb.melt$timeStep) & Comb.melt$value != 0),])}
		else{ nb_outbreak <- nrow(Comb.melt[(Comb.melt$timeStep == max(Comb.melt$timeStep) & Comb.melt$value != 0),]) / 2}
		text_to_display <- paste0(nb_outbreak, ' simulation(s) out of ', nb_replicates,' lead to an outbreak.')
		#melt(aggregate(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases"), list(Comb.df$timeStep), mean) %>% select("timeStep", "Reported cases", "Infected cases"), id = c("timeStep"))
		pal <- c("aquamarine3", "darkgoldenrod2")
		#p <- plot_ly(data = Comb.melt, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value), height = 600, colors = pal)
		p <- plot_ly(data = Comb.melt.mean, height = 600, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', opacity = 1, colors = pal, hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value))
		p <- p %>% add_trace(data = Comb.melt %>% group_by(replication), x = ~timeStep, y = ~value, color = ~variable, opacity =  0.3, type = 'scatter', mode = 'lines', colors = pal, hoverinfo = "none", showlegend = FALSE) 
		p <- layout(p, title = '', xaxis = list(title = ''), yaxis = list(title = 'New COVID-19 cases per day', range = c(-1, ymax)), 
			annotations = list(text = text_to_display, textposition = "bottom", font = list(size = 16), x = as.Date("2020-04-01", origin = "2020-03-01"), y = ymax - ymax*10/100, showarrow = FALSE),
			hovermode = 'compare',
			shapes = list(
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.2,
                 	x0 = control_period_asdate[1], x1 = control_period_asdate[2], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.1,
                  	x0 = control_period_asdate[2], x1 = control_period_asdate[3], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.07,
                  	x0 = control_period_asdate[4], x1 = control_period_asdate[5], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.03,
                  	x0 = control_period_asdate[6], x1 = control_period_asdate[7], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y")
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
								control_period %>% filter(Name == 'level2period') %>% select(end) %>% as.numeric(),
								control_period %>% filter(Name == 'level1period') %>% select(begining) %>% as.numeric(), 
								control_period %>% filter(Name == 'level1period') %>% select(end) %>% as.numeric()), origin = "2020-03-01")
		#a <- list(x = control_period_asdate[1], y = max(out.list$value), text = 'Level 4')
		Comb.df <- out.list #%>% mutate(timeStep = seq(1, nrow(out.list)))
		Comb.df$timeStep <- as.Date(Comb.df$timeStep, origin = "2020-03-01")
		Comb.melt <- melt(Comb.df %>% select("timeStep",  "Reported cases", "Infected cases", "replication"), id = c("timeStep", "replication"))
		# Select one replicate to plot in bold
		Comb.melt.mean <- Comb.melt %>% filter(replication == 1)
		# Limit of y axis
		ymax <- 2000
		if(max(Comb.melt$value) < 2000){ymax <- max(Comb.melt$value)}
		if(max(Comb.melt[as.Date(Comb.melt$timeStep) < "2020-04-28", "value"]) > 2000){ymax <- max(Comb.melt[as.Date(Comb.melt$timeStep) < "2020-04-28", "value"])}
		# text to display
		nb_replicates <- max(Comb.melt$replication)
		if(input$DoNothingscenario == "Yes"){nb_outbreak <- nrow(Comb.melt[(Comb.melt$timeStep == max(Comb.melt$timeStep) & Comb.melt$value != 0),])}
		else{ nb_outbreak <- nrow(Comb.melt[(Comb.melt$timeStep == max(Comb.melt$timeStep) & Comb.melt$value != 0),]) / 2}
		text_to_display <- paste0(nb_outbreak, ' simulation(s) out of ', nb_replicates,' lead to an outbreak.')
		pal <- c("aquamarine3", "darkgoldenrod2")
		#p <- plot_ly(data = Comb.melt, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value), height = 600, colors = pal)
		p <- plot_ly(data = Comb.melt.mean, height = 600, x = ~timeStep, y = ~value, color = ~variable, type = 'scatter', mode = 'lines', opacity = 1, colors = pal, hoverinfo = 'text',  text = ~paste('Day: ', timeStep,"\n", variable, ": ", value))
		p <- p %>% add_trace(data = Comb.melt %>% group_by(replication), x = ~timeStep, y = ~value, color = ~variable, opacity =  0.3, type = 'scatter', mode = 'lines', colors = pal, hoverinfo = "none", showlegend = FALSE) 
		p <- layout(p, title = '', xaxis = list(title = ''), yaxis = list(title = 'New COVID-19 cases per day', range = c(-1, ymax)), 
			annotations = list(text = text_to_display, textposition = "bottom", font = list(size = 16), x = as.Date("2020-04-01", origin = "2020-03-01"), y = ymax - ymax*10/100, showarrow = FALSE),
			hovermode = 'compare',
			shapes = list(
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.2,
                 	x0 = control_period_asdate[1], x1 = control_period_asdate[2], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.1,
                  	x0 = control_period_asdate[2], x1 = control_period_asdate[3], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.07,
                  	x0 = control_period_asdate[4], x1 = control_period_asdate[5], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y"),
				list(type = "rect",
					fillcolor = "royalblue", line = list(color = "royalblue"), opacity = 0.03,
                  	x0 = control_period_asdate[6], x1 = control_period_asdate[7], xref = "x", y0 = 0, y1 = max(Comb.melt$value), yref = "y")
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
		updateSliderInput(session, 'level1period', max = simulation_time - Level4controlperiod[2])
    })


	# Reset all parameters if the RESET button is pushed
	observeEvent(input$reset,{
		updateNumericInput(session, "initInf", value = 15)
		updateNumericInput(session, 'HighControlR0', value = 0.4) # simulator R during level 4
		updateNumericInput(session, 'LowControlR0', value = 1.0) # simulator R during level 3
		updateSliderInput(session, "level2R0", value = 1.8) # simulator R during level 2
		updateSliderInput(session, "level1R0", value = 2.2) # simulator R during level 1
		updateNumericInput(session, 'Rlevel4', value = 0.4) # R calculator during level 4
		updateNumericInput(session, 'Rlevel1', value = 1.0) # R calculator during level 3
		updateSliderInput(session, "Rlevel2", value = 1.8) # R calculator during level 2
		updateSliderInput(session, "Rlevel1", value = 2.2) # R calculator during level 1
		updateSliderInput(session, 'simulation_time', value = 140)
		simulation_time <- input$simulation_time
		updateSliderInput(session, 'level4controlperiod', value = c(25, 58), max = simulation_time)
		level4controlperiod <- input$level4controlperiod
		updateSliderInput(session, 'Afterlevel4controlperiod', max = 84, value = 28)
		updateSliderInput(session, "level2period", max = 84, value = 28) 
		updateSliderInput(session, "level1period", max = 84, value = 28) 
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

	observeEvent(input$baselinelevel, {
		if(input$baselinelevel == "L1"){
				updateSliderInput(session, 'physicaldistancing', value = 3)
				updateSliderInput(session, 'handwash', value = 20)
				updateSliderInput(session, 'isolating', value = 70)	
				updateSliderInput(session, 'quarantine', value = 70)
				updateSliderInput(session, 'winter', value = 0)
				updateRadioButtons(session, "L1PH1", selected = "L1PH1W3")
				updateRadioButtons(session, "L1PH2", selected = "L1PH2W1")
				updateRadioButtons(session, "H1", selected = "H1H1")
				updateRadioButtons(session, "I1", selected = "I1Q1")
				updateRadioButtons(session, "I2", selected = "I2Q1")
				updateRadioButtons(session, "Q1L1", selected = "Q1L1Q1")	
		}

		if(input$baselinelevel == "L2"){
				updateSliderInput(session, 'physicaldistancing', value = 20)
				updateSliderInput(session, 'handwash', value = 20)
				updateSliderInput(session, 'isolating', value = 80)	
				updateSliderInput(session, 'quarantine', value = 80)
				updateSliderInput(session, 'winter', value = 0)
				updateRadioButtons(session, "L2PH1", selected = "L2PH1W1")
				updateRadioButtons(session, "L2PH2", selected = "L2PH2W1")
				updateRadioButtons(session, "H1", selected = "H1H1")
				updateRadioButtons(session, "I1", selected = "I1Q1")
				updateRadioButtons(session, "I2", selected = "I2Q1")
				updateRadioButtons(session, "Q1L2", selected = "Q1L2Q1")	
		}
		if(input$baselinelevel == "L3"){
				updateSliderInput(session, 'physicaldistancing', value = 45)
				updateSliderInput(session, 'handwash', value = 20)
				updateSliderInput(session, 'isolating', value = 80)	
				updateSliderInput(session, 'quarantine', value = 80)
				updateSliderInput(session, 'winter', value = 0)
				updateRadioButtons(session, "L3PH1", selected = "L3PH1W1")
				updateRadioButtons(session, "L3PH2", selected = "L3PH2W1")
				updateRadioButtons(session, "L3PH3", selected = "L3PH3W1")
				updateRadioButtons(session, "H1", selected = "H1H1")
				updateRadioButtons(session, "I1", selected = "I1Q1")
				updateRadioButtons(session, "I2", selected = "I2Q1")
				updateRadioButtons(session, "Q1L3", selected = "Q1L3Q1")		
		}
		if(input$baselinelevel == "L4"){
				updateSliderInput(session, 'physicaldistancing', value = 75)
				updateSliderInput(session, 'handwash', value = 20)
				updateSliderInput(session, 'isolating', value = 90)	
				updateSliderInput(session, 'quarantine', value = 85)
				updateSliderInput(session, 'winter', value = 0)
				updateRadioButtons(session, "L4PH1", selected = "L4PH1W1")
				updateRadioButtons(session, "L4PH2", selected = "L4PH2W1")
				updateRadioButtons(session, "H1", selected = "H1H1")
				updateRadioButtons(session, "I1L4", selected = "I1L4Q1")
				updateRadioButtons(session, "I2L4", selected = "I2L4Q1")
				updateRadioButtons(session, "Q1L4", selected = "Q1L4Q1")
	}
	})

	observeEvent(input$Q1L4, { 
			if(input$Q1L4 == "Q1L4Q1"){updateSliderInput(session, 'quarantine', value = 85)	}
			if(input$Q1L4 == "Q1L4Q2"){updateSliderInput(session, 'quarantine', value = 75)	}
			if(input$Q1L4 == "Q1L4Q3"){updateSliderInput(session, 'quarantine', value = 65)	}
			if(input$Q1L4 == "Q1L4Q4"){updateSliderInput(session, 'quarantine', value = 50)	}
	})

	observeEvent(input$Q1L3, { 
			if(input$Q1L3 == "Q1L3Q1"){updateSliderInput(session, 'quarantine', value = 80)	}
			if(input$Q1L3 == "Q1L3Q2"){updateSliderInput(session, 'quarantine', value = 70)	}
			if(input$Q1L3 == "Q1L3Q3"){updateSliderInput(session, 'quarantine', value = 60)	}
			if(input$Q1L3 == "Q1L3Q4"){updateSliderInput(session, 'quarantine', value = 45)	}
		})
	observeEvent(input$Q1L2, { 
			if(input$Q1L2 == "Q1L2Q1"){updateSliderInput(session, 'quarantine', value = 80)	}
			if(input$Q1L2 == "Q1L2Q2"){updateSliderInput(session, 'quarantine', value = 70)	}
			if(input$Q1L2 == "Q1L2Q3"){updateSliderInput(session, 'quarantine', value = 60)	}
			if(input$Q1L2 == "Q1L2Q4"){updateSliderInput(session, 'quarantine', value = 45)	}
		})

	observeEvent(input$Q1L1, { 
			if(input$Q1L1 == "Q1L1Q1"){updateSliderInput(session, 'quarantine', value = 80)	}
			if(input$Q1L1 == "Q1L1Q2"){updateSliderInput(session, 'quarantine', value = 70)	}
			if(input$Q1L1 == "Q1L1Q3"){updateSliderInput(session, 'quarantine', value = 60)	}
			if(input$Q1L1 == "Q1L1Q4"){updateSliderInput(session, 'quarantine', value = 45)	}
		})


	observeEvent(input$H1, { 
		if(input$H1 == "H1H1"){updateSliderInput(session, 'handwash', value = 20)	}
		if(input$H1 == "H1H2"){updateSliderInput(session, 'handwash', value = 15)	}
		if(input$H1 == "H1H3"){updateSliderInput(session, 'handwash', value = 10)	}
		if(input$H1 == "H1H4"){updateSliderInput(session, 'handwash', value = 0)	}
	})

	observeEvent(input$I1L4, { 
			if(input$I1L4 == "I1L4Q1"){
				if(input$I2L4 == "I2L4Q1"){updateSliderInput(session, 'isolating', value = 85)	}
				if(input$I2L4 == "I2L4Q2"){updateSliderInput(session, 'isolating', value = 80)	}
				if(input$I2L4 == "I2L4Q3"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I2L4 == "I2L4Q4"){updateSliderInput(session, 'isolating', value = 65)	}			
			}
			if(input$I1L4 == "I1L4Q2"){
				if(input$I2L4 == "I2L4Q1"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I2L4 == "I2L4Q2"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I2L4 == "I2L4Q3"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I2L4 == "I2L4Q4"){updateSliderInput(session, 'isolating', value = 60)	}			
			}
			if(input$I1L4 == "I1L4Q3"){
				if(input$I2L4 == "I2L4Q1"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I2L4 == "I2L4Q2"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I2L4 == "I2L4Q3"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I2L4 == "I2L4Q4"){updateSliderInput(session, 'isolating', value = 55)	}			
			}
			if(input$I1L4 == "I1L4Q4"){
				if(input$I2L4 == "I2L4Q1"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I2L4 == "I2L4Q2"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I2L4 == "I2L4Q3"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I2L4 == "I2L4Q4"){updateSliderInput(session, 'isolating', value = 50)	}			
			}
	})

	observeEvent(input$I2L4, { 
			if(input$I2L4 == "I2L4Q1"){
				if(input$I1L4 == "I1L4Q1"){updateSliderInput(session, 'isolating', value = 85)	}
				if(input$I1L4 == "I1L4Q2"){updateSliderInput(session, 'isolating', value = 80)	}
				if(input$I1L4 == "I1L4Q3"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I1L4 == "I1L4Q4"){updateSliderInput(session, 'isolating', value = 65)	}			
			}
			if(input$I2L4 == "I2L4Q2"){
				if(input$I1L4 == "I1L4Q1"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I1L4 == "I1L4Q2"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I1L4 == "I1L4Q3"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I1L4 == "I1L4Q4"){updateSliderInput(session, 'isolating', value = 60)	}			
			}
			if(input$I2L4 == "I2L4Q3"){
				if(input$I1L4 == "I1L4Q1"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I1L4 == "I1L4Q2"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I1L4 == "I1L4Q3"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I1L4 == "I1L4Q4"){updateSliderInput(session, 'isolating', value = 55)	}			
			}
			if(input$I2L4 == "I2L4Q4"){
				if(input$I1L4 == "I1L4Q1"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I1L4 == "I1L4Q2"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I1L4 == "I1L4Q3"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I1L4 == "I1L4Q4"){updateSliderInput(session, 'isolating', value = 50)	}			
			}
	})


	observeEvent(input$I1, { 
			if(input$I1 == "I1Q1"){
				if(input$I2 == "I2Q1"){updateSliderInput(session, 'isolating', value = 80)	}
				if(input$I2 == "I2Q2"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I2 == "I2Q3"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I2 == "I2Q4"){updateSliderInput(session, 'isolating', value = 60)	}			
			}
			if(input$I1 == "I1Q2"){
				if(input$I2 == "I2Q1"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I2 == "I2Q2"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I2 == "I2Q3"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I2 == "I2Q4"){updateSliderInput(session, 'isolating', value = 55)	}			
			}
			if(input$I1 == "I1Q3"){
				if(input$I2 == "I2Q1"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I2 == "I2Q2"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I2 == "I2Q3"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I2 == "I2Q4"){updateSliderInput(session, 'isolating', value = 50)	}			
			}
			if(input$I1 == "I1Q4"){
				if(input$I2 == "I2Q1"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I2 == "I2Q2"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I2 == "I2Q3"){updateSliderInput(session, 'isolating', value = 50)	}
				if(input$I2 == "I2Q4"){updateSliderInput(session, 'isolating', value = 45)	}			
			}
	})

	observeEvent(input$I2, { 
			if(input$I2 == "I2Q1"){
				if(input$I1 == "I1Q1"){updateSliderInput(session, 'isolating', value = 80)	}
				if(input$I1 == "I1Q2"){updateSliderInput(session, 'isolating', value = 75)	}
				if(input$I1 == "I1Q3"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I1 == "I1Q4"){updateSliderInput(session, 'isolating', value = 60)	}			
			}
			if(input$I2 == "I2Q2"){
				if(input$I1 == "I1Q1"){updateSliderInput(session, 'isolating', value = 70)	}
				if(input$I1 == "I1Q2"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I1 == "I1Q3"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I1 == "I1Q4"){updateSliderInput(session, 'isolating', value = 55)	}			
			}
			if(input$I2 == "I2Q3"){
				if(input$I1 == "I1Q1"){updateSliderInput(session, 'isolating', value = 65)	}
				if(input$I1 == "I1Q2"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I1 == "I1Q3"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I1 == "I1Q4"){updateSliderInput(session, 'isolating', value = 50)	}			
			}
			if(input$I2 == "I2Q4"){
				if(input$I1 == "I1Q1"){updateSliderInput(session, 'isolating', value = 60)	}
				if(input$I1 == "I1Q2"){updateSliderInput(session, 'isolating', value = 55)	}
				if(input$I1 == "I1Q3"){updateSliderInput(session, 'isolating', value = 50)	}
				if(input$I1 == "I1Q4"){updateSliderInput(session, 'isolating', value = 45)	}			
			}
	})
	

	observeEvent(input$L4PH1, { 
		if(input$L4PH1 == "L4PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 75)	}
		if(input$L4PH1 == "L4PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 65)	}
		if(input$L4PH1 == "L4PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 55)	}
		if(input$L4PH1 == "L4PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 45)	}
	})

	observeEvent(input$L3PH1, { 
		if(input$L3PH1 == "L3PH1W1"){
			if(input$L3PH2 == "L3PH2W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 45)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 43)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 39)}
			}
			if(input$L3PH2 == "L3PH2W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH2 == "L3PH2W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH2 == "L3PH2W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
		}
		if(input$L3PH1 == "L3PH1W2"){
			if(input$L3PH2 == "L3PH2W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 49)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH2 == "L3PH2W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH2 == "L3PH2W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH2 == "L3PH2W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
		}
		if(input$L3PH1 == "L3PH1W3"){
			if(input$L3PH2 == "L3PH2W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH2 == "L3PH2W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH2 == "L3PH2W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH2 == "L3PH2W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
		}
		if(input$L3PH1 == "L3PH1W4"){
			if(input$L3PH2 == "L3PH2W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH2 == "L3PH2W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
			if(input$L3PH2 == "L3PH2W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 23)}
			}
			if(input$L3PH2 == "L3PH2W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 23)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 20)}
			}
		}
	})

	observeEvent(input$L3PH2, { 
		if(input$L3PH2 == "L3PH2W1"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 45)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 43)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 39)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
		}
		if(input$L3PH2 == "L3PH2W2"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 49)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
		}
		if(input$L3PH2 == "L3PH2W3"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
		}
		if(input$L3PH2 == "L3PH2W4"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 23)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH3 == "L3PH3W1"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH3 == "L3PH3W2"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH3 == "L3PH3W3"){updateSliderInput(session, 'physicaldistancing', value = 23)}
				if(input$L3PH3 == "L3PH3W4"){updateSliderInput(session, 'physicaldistancing', value = 20)}
			}
		}
	})

	observeEvent(input$L3PH3, { 
		if(input$L3PH3 == "L3PH3W1"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 45)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 43)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 39)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
		}
		if(input$L3PH3 == "L3PH3W2"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 41)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 49)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 35)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
		}
		if(input$L3PH3 == "L3PH3W3"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 39)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 33)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 37)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 30)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
		}
		if(input$L3PH3 == "L3PH3W4"){
			if(input$L3PH1 == "L3PH1W1"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 35)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 27)}
			}
			if(input$L3PH1 == "L3PH1W2"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 33)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 25)}
			}
			if(input$L3PH1 == "L3PH1W3"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 30)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 23)}
			}
			if(input$L3PH1 == "L3PH1W4"){
				if(input$L3PH2 == "L3PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 27)}
				if(input$L3PH2 == "L3PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 25)}
				if(input$L3PH2 == "L3PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 23)}
				if(input$L3PH2 == "L3PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 20)}
			}
		}
	})

	
	observeEvent(input$L2PH1, { 
		if(input$L2PH1 == "L2PH1W1"){
			if(input$L2PH2 == "L2PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 20)}
			if(input$L2PH2 == "L2PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 15)}
			if(input$L2PH2 == "L2PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH2 == "L2PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 9)}
		}
		if(input$L2PH1 == "L2PH1W2"){
			if(input$L2PH2 == "L2PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 15)}
			if(input$L2PH2 == "L2PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH2 == "L2PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH2 == "L2PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 6)}
		}
		if(input$L2PH1 == "L2PH1W3"){
			if(input$L2PH2 == "L2PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH2 == "L2PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH2 == "L2PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L2PH2 == "L2PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 3)}
		}
		if(input$L2PH1 == "L2PH1W4"){
			if(input$L2PH2 == "L2PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH2 == "L2PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L2PH2 == "L2PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L2PH2 == "L2PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 0)}
		}
		})

	observeEvent(input$L2PH2, { 
		if(input$L2PH2 == "L2PH2W1"){
			if(input$L2PH1 == "L2PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 20)}
			if(input$L2PH1 == "L2PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 15)}
			if(input$L2PH1 == "L2PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH1 == "L2PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 9)}
		}
		if(input$L2PH2 == "L2PH2W2"){
			if(input$L2PH1 == "L2PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 15)}
			if(input$L2PH1 == "L2PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH1 == "L2PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH1 == "L2PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 6)}
		}
		if(input$L2PH2 == "L2PH2W3"){
			if(input$L2PH1 == "L2PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 12)}
			if(input$L2PH1 == "L2PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH1 == "L2PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L2PH1 == "L2PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 3)}
		}
		if(input$L2PH2 == "L2PH2W4"){
			if(input$L2PH1 == "L2PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 9)}
			if(input$L2PH1 == "L2PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L2PH1 == "L2PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L2PH1 == "L2PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 0)}
		}
		})

	observeEvent(input$L1PH1, { 
		if(input$L1PH1 == "L1PH1W1"){
			if(input$L1PH2 == "L1PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L1PH2 == "L1PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 5)}
			if(input$L1PH2 == "L1PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH2 == "L1PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 3)}
		}
		if(input$L1PH1 == "L1PH1W2"){
			if(input$L1PH2 == "L1PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 5)}
			if(input$L1PH2 == "L1PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH2 == "L1PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH2 == "L1PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 2)}
		}
		if(input$L1PH1 == "L1PH1W3"){
			if(input$L1PH2 == "L1PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH2 == "L1PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH2 == "L1PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 2)}
			if(input$L1PH2 == "L1PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 1)}
		}
		if(input$L1PH1 == "L1PH1W4"){
			if(input$L1PH2 == "L1PH2W1"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH2 == "L1PH2W2"){updateSliderInput(session, 'physicaldistancing', value = 2)}
			if(input$L1PH2 == "L1PH2W3"){updateSliderInput(session, 'physicaldistancing', value = 1)}
			if(input$L1PH2 == "L1PH2W4"){updateSliderInput(session, 'physicaldistancing', value = 0)}
		}
		})

	observeEvent(input$L1PH2, { 
		if(input$L1PH2 == "L1PH2W1"){
			if(input$L1PH1 == "L1PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 6)}
			if(input$L1PH1 == "L1PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 5)}
			if(input$L1PH1 == "L1PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH1 == "L1PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 3)}
		}
		if(input$L1PH2 == "L1PH2W2"){
			if(input$L1PH1 == "L1PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 5)}
			if(input$L1PH1 == "L1PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH1 == "L1PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH1 == "L1PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 2)}
		}
		if(input$L1PH2 == "L1PH2W3"){
			if(input$L1PH1 == "L1PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 4)}
			if(input$L1PH1 == "L1PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH1 == "L1PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 2)}
			if(input$L1PH1 == "L1PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 1)}
		}
		if(input$L1PH2 == "L1PH2W4"){
			if(input$L1PH1 == "L1PH1W1"){updateSliderInput(session, 'physicaldistancing', value = 3)}
			if(input$L1PH1 == "L1PH1W2"){updateSliderInput(session, 'physicaldistancing', value = 2)}
			if(input$L1PH1 == "L1PH1W3"){updateSliderInput(session, 'physicaldistancing', value = 1)}
			if(input$L1PH1 == "L1PH1W4"){updateSliderInput(session, 'physicaldistancing', value = 0)}
		}
		})
	


    
}


