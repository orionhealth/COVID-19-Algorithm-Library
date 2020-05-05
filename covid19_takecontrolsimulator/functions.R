# This file defines all the functions that are used in the simulation

# ----------------------------------------------------------------------------
# SEIR function:
# ----------------------------------------------------------------------------
# Function to relate the 'clinical' and 'behavioural' parameters entered by the user into the rate parameters used by the model
# INPUT: pClin - named list of the 'clinical' and 'behavioural' parameters
# OUTPUT: named list of the model rate parameters, excluding the Betas
# EXAMPLE: 


GetParams_SEIR <-function(input){
	#  How many infections are currently in each city? (initial number of infected)
	if(input$DoNothingscenario == "Yes"){
		# Population in each city
		PS0 <- 5e6
		N <- input$initInf
		# Read simulation time
		simulation_time <- input$simulation_time
		R0 <- input$R0
		Control <- c(1, 1, 1, 1)	
		TG <- input$TG
		# Time from exposed to symptoms
		EOnsetToS <- input$EOnsetToS
		EOnsetToIsol <- 30
		# Percentage of population subclinical 
		PSub <- input$PSub/100
		# Percentage of hospitalization
		Psevere <- input$Psevere/100
		# Subclinicals infect at a lower level (50%)
		InfS <- input$InfS/100
		# Transmission rate after isolation (65%) 
		InfC <- 1
		# Calculate PRClin
		PRClin <- R0 / ((PSub * InfS) + (1 - PSub)) 
		# No control period
		level4controlperiod <- c(0,0)
		Afterlevel4controlperiod <- c(0,0)
		level2period <- c(0,0) 
		Nbrep <- 1
	}
	# Set high control periods
	# vector of 0 at level1, level4, level4
	if(input$DoNothingscenario == "No"){
		PS0 <- 5e6
		N <- input$initInf
		# Read simulation time
		simulation_time <- input$simulation_time		
		R0 <- input$R0
		# R0 during level and level 4
		TG <- input$TG
		# Time from exposed to symptoms
		EOnsetToS <- input$EOnsetToS
		# Time from symptoms to isolation
		EOnsetToIsol <- input$EOnsetToIsol
		# Percentage of population subclinical 
		PSub <- input$PSub/100
		# Percentage of hospitalization
		Psevere <- input$Psevere/100
		# Subclinicals infect at a lower level (50%)
		InfS <- input$InfS/100
		# Calculate PRClin
		PRClin <- R0/ ((PSub * InfS) + (1 - PSub)) 
		# Calulculate ratio Prclin with control / Prclin without control
		Control_level3 <- (input$LowControlR0 / ((PSub * InfS) + (1 - PSub))) / PRClin 
		Control_level4 <- (input$HighControlR0 / ((PSub * InfS) + (1 - PSub))) / PRClin
		Control_level2 <- (input$level2R0 / ((PSub * InfS) + (1 - PSub))) / PRClin
		Control <- c(1, Control_level2, Control_level3, Control_level4)
		# Transmission rate after isolation (65%) 
		InfC <- input$InfC/100
		# Control period
		level4controlperiod <- input$level4controlperiod
		Afterlevel4controlperiod <- c(level4controlperiod[2], level4controlperiod[2] + input$Afterlevel4controlperiod)
		if(input$level2period > 0){
			level2period <- c(Afterlevel4controlperiod[2], Afterlevel4controlperiod[2] + input$level2period)
		} 
		else{level2period <- c(0, 0)}
		# Number of replication
		Nbrep <- input$Nbrep
	}
		
	model_parameter <- list('simulation_time' = simulation_time, 'initInf' = N,  'PS0' = PS0, 'PRClin' = PRClin, 'Control' = Control, 'EOnsetToS' = EOnsetToS, 'EOnsetToIsol' = EOnsetToIsol, 'PSub' = PSub, 'Psevere' = Psevere, 'InfS' = InfS, 'InfC' = InfC, 'TG' = TG, 'level2period' = level2period, 'Afterlevel4controlperiod' = Afterlevel4controlperiod, 'level4controlperiod' = level4controlperiod, 'Nbrep' = Nbrep)
	return(model_parameter)
}



# ----------------------------------------------------------------------------
# Replicate SimBranching 
# ----------------------------------------------------------------------------
# Funtion to replicate the stochastic model 
ReplicateSimBranchingModel <- function(input){
	# If break the chain of transmission selected
	if(input$DoNothingscenario == "No"){
		# setup parallel backend to use many processors
		#cores <- detectCores() # Detect number of core
		#cl <- makeCluster(cores[1] - 1) # Remove 1 not to overload your computer
		#registerDoParallel(cl) # regster core
		# Parallelization
		allReplicates <- NULL
		for (replicate in seq(1,input$Nbrep)) {
			Model <- SimBranchingModel(input, replicate) 
			allReplicates <- rbind(allReplicates, Model)
		#allReplicates <- foreach(replicate = 1:input$Nbrep, .combine = rbind, .export='SimBranchingModel') %dopar% {
	  		#Model <- SimBranchingModel(input, replicate) 
	   		## return model - equivalent to allRepicates = cbind(allRepicates, Model)
			#Model
		}
		#stop cluster
		#stopCluster(cl)
		# return the number of replicate
		return(allReplicates)
	}
	else{ # if the Do-nothing option is selected
		# One replication of the do-nothing option was pre-run to not exceed the capacity of the app
		# Load the data
		doNothingData <- readRDS("donothing1-100-step1.rds")
		# Add a column with the replication number (fixed to 1)
		doNothingData <- cbind(doNothingData, rep(1, nrow(doNothingData)))
		#rename column
		names(doNothingData) <- c("Reported cases", "Pre-symptomatic", "Subclinical (asymptomatic)", "Infected cases", "Inhospital", "N", "replication")
		# Filter data based on initial number of infected
		allReplicates <- doNothingData %>% filter(N == input$initInf)
		allReplicates <- cbind(allReplicates, seq(1, nrow(allReplicates)))
		names(allReplicates) <- c("Reported cases", "Pre-symptomatic", "Subclinical (asymptomatic)", "Infected cases", "Inhospital", "N",  "replication", "timeStep")
		return(allReplicates)
	}
	
}




# ----------------------------------------------------------------------------
# SimBranching function:
# ----------------------------------------------------------------------------
# Function to simulate the spread of infection using a stochastic, branching model
# INPUT: input - structure containing all the user entered information
# OUTPUT: named datframe consisting of the timecourse of each variable, number of reported cases, number of pre-ymptomatic case, number of subclinical, number of infected cases(reported + presymptomatic + subclinical), number of hospitalization, replication number)
SimBranchingModel <- function(input, nbrep){
	if(input$DoNothingscenario == "No"){
		# Extract entry parameters
		ParamStruct <- GetParams_SEIR(input)
		N <- ParamStruct$initInf # Initial number of infected
		EOnsetToS <- ParamStruct$EOnsetToS # Time from exposure to symptoms onset
		EOnsetToIsol <- ParamStruct$EOnsetToIsol # Time from symptoms onset to isolation 
		PSub <- ParamStruct$PSub # Proportion of subclinical
		Control <- ParamStruct$Control # Transmission rate under different control level
		TEnd <- ParamStruct$simulation_time # Simulation time
		PS0 <- ParamStruct$PS0 # Number of individuals in the  population
		PRClin <- ParamStruct$PRClin # Effective RClinical
		Psevere <- ParamStruct$Psevere # Propportion of severe infections 
		PTL3 <- seq(ParamStruct$Afterlevel4controlperiod[1], ParamStruct$Afterlevel4controlperiod[2]) # Start - end date of level 3
		PTL4 <- seq(ParamStruct$level4controlperiod[1], ParamStruct$level4controlperiod[2]) # Start - end date of level 4
		PTL2 <- seq(ParamStruct$level2period[1], ParamStruct$level2period[2]) # Start -end data of level 2
		TG <- ParamStruct$TG # Generation time
		# Expose everyone in the last 10 days
		Exp <- -10 * runif(N, min = 0, max = 1)
		# Calculate an isolation date (Exposure to onset + onset to isolaton)
		Isol <- Exp + rgamma(n = N, shape = EOnsetToS, scale = 0.95) + rexp(N, rate = 1/EOnsetToIsol)
		# they cuurently have initiated no secondary infections
		Offspring <- rep(0, N)
		# Psub proportion of them are subclinical
		SubClin <- runif(n= N, min = 0, max = 1) < PSub
		D <- data.frame('exposed' = Exp, 'isolated' = Isol, 'secondaryInfection' = Offspring, 'sublinical' = SubClin, stringsAsFactors = FALSE)

		# Subclinicals infect at a lower level (50%)
		InfS <- ParamStruct$InfS
		# Transmission rate after isolation (65%) 
		InfC <- ParamStruct$InfC


		DFinished <- data.frame()
		# Extract control level
		C <- Control[1]
		for (timeStep in seq(1, TEnd)){
			if (nrow(D) > 0){
				# Reduce infection rate by current number of infecteds
				Infected <- nrow(D) + nrow(DFinished) 
			   	# Do one day
				list_infected <- OneDay(D, timeStep, C * (PS0 - Infected) / PS0, EOnsetToIsol, EOnsetToS, PRClin, PSub, TG, InfS, InfC)	
				# Add the new infections to the current infecteds
				D <- rbind(list_infected[[1]], list_infected[[2]])
				# remove people no longer infectious
				Done <- (timeStep - D$exposed) > 20
				# Add indivdiduals done with infection to a new dataframe
				DFinished <- rbind(DFinished, D[Done, ]) 
				# Remove indivdiduals done with infection from initial data frame
				D <- D[!Done, ]
				C <- Control[1]
				# Change control level on march 25th
				if (timeStep  %in% PTL4){C = Control[4]}
				# Change again on April 27th
				if (timeStep %in% PTL3){C = Control[3]}
				# Change after 28 days again
				if (timeStep %in% PTL2){C = Control[2]}
			}
		}
		D <- rbind(DFinished, D)
		# 5% of clinicals went to hospital, find hospital end date
		# (non matricial calculation)
		# element-wise multiplication
		D$HospitalEndDate <- (D$isolated + rexp(n = nrow(D), rate = 1/10)) * (as.numeric(runif(n = nrow(D), min = 0, max = 1) < Psevere) * (1 - PSub))
		D$HospitalEndDate[D$sublinical == 1] <- NA

		# Collect daily totals
		daily_tot_exposed <- D[(D$exposed > 0) & (D$exposed <= TEnd), ]
		daily_tot_isolated <- D[(D$isolated > 0) & (D$isolated <= TEnd), ]
		Model =  matrix(0, nrow=TEnd, ncol=5)
		Model[, 1] <- hist(daily_tot_isolated$isolated[(daily_tot_isolated$sublinical == FALSE)], breaks = seq(0 , TEnd), plot = FALSE)$count
		Model[, 2] <- hist(daily_tot_exposed$exposed[(daily_tot_exposed$sublinical == FALSE)], breaks = seq(0 , TEnd), plot = FALSE)$count
		Model[, 3] <- hist(daily_tot_exposed$exposed[(daily_tot_exposed$sublinical == TRUE)], breaks = seq(0 , TEnd), plot = FALSE)$count
		Model[, 4] <- hist(daily_tot_exposed$exposed, breaks = seq(0 , TEnd), plot = FALSE)$count
		for (I in seq(1, TEnd)){
			Model[I, 5] <- length(daily_tot_exposed$exposed[(daily_tot_exposed$isolated < I) & (daily_tot_exposed$HospitalEndDate >= I)])
		}	
		# Transform martic into dataframe
		Model <- as.data.frame(Model)
		# Add a column with the replication number
		Model <- cbind(Model, seq(1, nrow(Model)), rep(nbrep, nrow(Model)))
		# Rename column
		# Rename column
		names(Model) <- c("Reported cases", "Pre-symptomatic", "Subclinical (asymptomatic)", "Infected cases", "Inhospital", "timeStep", "replication")
		# return dataframe
		return(Model)
	}
	
}





	
# ----------------------------------------------------------------------------
# OnDay Function
# ----------------------------------------------------------------------------
# Function calculating the number of new infected each day
# INPUT: 	D - dataframe keeping track of the number of exposed, isolated, secondary infection, subclinical cases 
# 			timeStep, day since first cases
# 			C - Pre-clinicila R0 (change at different level of control)
#			EOnsetToIsol - time from Exposure to isolation (rate of the exponential distribution)
#			EOnsetToS - time from exposure to symptoms (shape of gamma distirbution)
#			PRClin - Transmission rate for non subclinical individuals at time timeStep 
#			PSub - Proportion of subclinical individuals in the population
# OUTPUT: 	Updated dataframe keeping track of the number of exposed, isolated, secondary infection, subclinical cases 
# 			Data frame of new cases
OneDay <- function(D, timeStep, C, EOnsetToIsol, EOnsetToS, PRClin, PSub, TG, InfS, InfC){
	# Effective RClinical given the control level  --> degree to which R0 has been reduced to 
	RClinNow <- PRClin * C
	# Not including daily imported cases at the moment
	DailyImports <- 0

	# generation time distribution 
	# (time between being infected and infecting someone)
	GenerationTimeDistribution <- dweibull(seq(1, 25, 1), shape = 2.83, scale = TG)
	# Cumulative distribution
	for(n in seq(2, length(GenerationTimeDistribution))){GenerationTimeDistribution[n] <- GenerationTimeDistribution[n] + GenerationTimeDistribution[n - 1]}

	# Find the preclinicals (fully infectious not isolated)
	# Exposed & not isolated yet & not subclinical
	# renames row so that names match the index for row selection
	rownames(D) <- seq(1, nrow(D))
	XP <- D[(D$exposed <= timeStep) & (D$isolated > timeStep) & (D$sublinical == FALSE),  ]
	# clinicals (infectious and isolated)
	XC <- D[(D$isolated <= timeStep) & ((D$exposed + 20) >= timeStep) &  (D$sublinical == FALSE),  ] 
	# subclinicals (asymptomatic, lower infection rate never isolated)
	XS <-D[(D$exposed <= timeStep) & ((D$exposed + 20) >= timeStep) &  (D$sublinical == TRUE),  ]

	# How far through the illness are they (Exposed & not isolated yet & not subclinical)
	if (nrow(XP) > 0){
		TInf <- round(timeStep - XP$exposed)	
		# What's the rate they infect at today
		PInf <- (GenerationTimeDistribution[(TInf + 1)] -  GenerationTimeDistribution[TInf ]) * RClinNow
		# How many people have they each infected
		NewInfectionsP <- rpois(length(PInf), PInf) #RclinNow was include above
		# Record these new infections
		D[as.numeric(rownames(XP)), 'secondaryInfection'] <- D[as.numeric(rownames(XP)), 'secondaryInfection'] + NewInfectionsP
	}
	else{NewInfectionsP <- 0}

	# How far through the illness are they (Not isolated & still infectious & not subclinical)
	if (nrow(XC) > 0){
		TInf <- round(timeStep - XC$exposed)	
		# What's the rate they infect at today
		PInf <- (GenerationTimeDistribution[(TInf + 1)] -  GenerationTimeDistribution[TInf]) * RClinNow * InfC
		# How many people have they each infected
		NewInfectionsC <- rpois(length(PInf), PInf) #RclinNow was include above
		# Record these new infections
		D[as.numeric(rownames(XC)), 'secondaryInfection'] <- D[as.numeric(rownames(XC)), 'secondaryInfection'] + NewInfectionsC
	}
	else{NewInfectionsC <- 0}

	# Same for subclinicals
	if (nrow(XS) > 0){
		TInf = round(timeStep - XS$exposed)
		# What's the rate they infect at today
		PInf <- (GenerationTimeDistribution[(TInf + 1)] -  GenerationTimeDistribution[TInf]) * RClinNow * InfS
		# How many people have they each infected
		NewInfectionsS <- rpois(length(PInf), PInf) #RclinNow was include above
		# Record these new infections
		D[as.numeric(rownames(XS)), 'secondaryInfection'] <- D[as.numeric(rownames(XS)), 'secondaryInfection'] + NewInfectionsS
	}
	else{NewInfectionsS <- 0}

	# How many new individuals have been infected
	NewInfections <- sum(NewInfectionsP) + sum(NewInfectionsC) + sum(NewInfectionsS)
	NewInfections 
	# CReate the newly infecteds and initialise all variables
	if (NewInfections > 0){
		# They were ifected today
		newDExp <- rep(timeStep, NewInfections)
		# They haven't infected anyone yet
		NewDOffspring <- rep(0, NewInfections)
		# Exposure to symptom time
		ExpToOnsetpop <- rgamma(n = NewInfections, shape = EOnsetToS, scale = 0.95) 
		# Symptom to isolation time
		OnsetToIsolpop <- rexp(n = NewInfections, rate = 1/EOnsetToIsol)
		# Isolation date
		NewDIsol <- timeStep + ExpToOnsetpop + OnsetToIsolpop
		# Are they subclinical
		NewDSubClin <- runif(NewInfections, min = 0, max = 1) < PSub
		# Give the subclinicals an isolation date after all infections have
		# finished
		NewDIsol[NewDSubClin] <- timeStep + 20
		NewD <- data.frame('exposed' = newDExp, 'isolated' = NewDIsol, 'secondaryInfection' = NewDOffspring, 'sublinical' = NewDSubClin, stringsAsFactors = FALSE) 
	}
	else{NewD <- NULL}	
	return(list(D, NewD))
}
