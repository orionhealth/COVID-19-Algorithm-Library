if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(shinyjs)) install.packages("shinyjs", repos = "http://cran.us.r-project.org")
if(!require(shinyBS)) install.packages("shinyBS", repos = "http://cran.us.r-project.org")

ui <- fluidPage(
	#tags$head(tags$style(HTML('.red-tooltip + .tooltip > .tooltip-inner {background-color:#f00;} .red-tooltip + .tooltip > .tooltip-arrow { border-bottom-color:#f00; }'))),
	theme = shinytheme("flatly"),
	titlePanel("COVID-19 Take Control simulator"),
	hr(),
	p(div(HTML("<h5><b>Disclaimer</b>: This simulator is intended for <b>research and educational purposes</b> only, <b>not</b> for decision-making. It simulates the natural course of a COVID-19 epidemic in Aotearoa, New Zealand. This work is licensed under the <a href=https://www.gnu.org/licenses/gpl-3.0.en.html> GNU General Public License v3.0 (GNU GPLv3)</a></h5>"))),
	navbarPage(" ", id = "inTabset",
		#### Introduction page ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		tabPanel("Introduction",
				shinyjs::useShinyjs(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<center> <h1>COVID-19, <b>Take control</b></h1> </center>"),
                 	shiny::HTML("<h4><br>This simulator illustrates the effects of hygiene and physical distancing measures that each and every kiwi is doing to take control of COVID-19. It allows you, the user, to see the effects higher and lower collective cooperation with policies aimed at breaking the chain of transmission.</br><br>The more we each do our part to wash our hands and reduce physical contact at every Alert Level the greater our chances of eliminating COVID-19. The quicker we eliminate the virus, the sooner we can return to a safer new normal.</br><br>In short, the COVID-19 Take Control simulator shows kiwis that <b>the power is in our hands</b>, quite literally.</br><br><br><b>What if we did nothing?</b></br><br>If Aotearoa, New Zealand had chosen a Do Nothing policy, each person who carries COVID-19 would infect 2-3 others on average, whether at home, work, school, or in day-to-day interactions. Some ‘super-spreaders’ would infect far more, especially when attending <a href=https://www.stuff.co.nz/national/health/coronavirus/120781038/coronavirus-matamata-cluster-at-45-cases-all-linked-to-bar>gatherings</a> outside <a href=https://www.stuff.co.nz/national/health/coronavirus/120902484/coronavirus-how-beautiful-bluff-wedding-became-major-covid19-cluster>their community</a>. Some <a href=https://www.npr.org/sections/goatsandsoda/2020/04/13/831883560/can-a-coronavirus-patient-who-isnt-showing-symptoms-infect-others>‘silent spreaders’</a> won’t even know they were infected.</br><br>This virus spreads when an infected person <a href=https://thespinoff.co.nz/society/06-04-2020/siouxsie-wiles-toby-morris-should-we-all-be-wearing-face-masks-to-prevent-covid-19-spread/>coughs or sneezes onto, or touches a surface, then someone else touches that surface then their face</a> before <a href=https://www.youtube.com/watch?v=2eqhw6yZk-c&feature=youtu.be>washing their hands</a>. The virus can live on hard surfaces (plastic, steel, etc.) for up to 3 days, and on softer surfaces (paper, cardboard) for up to 1 day. Many infections <a href=https://thespinoff.co.nz/covid-19/03-04-2020/siouxsie-wiles-toby-morris-a-note-on-apartments-and-bubbles/>spread by people who are infected</a> but don’t yet, or might never, show <a href=https://thespinoff.co.nz/science/18-03-2020/siouxsie-wiles-how-testing-for-covid-19-works/>symptoms</a>.</br><br>This means that staying home when sick, <a href=https://thespinoff.co.nz/politics/22-03-2020/siouxsie-wiles-toby-morris-what-does-level-two-mean-and-why-does-it-matter/>reducing our physical contact with others</a>, coughing and sneezing into a tissue or an elbow, <a href=https://www.youtube.com/watch?v=pMtrbcYz2TU/>cleaning surfaces</a>, washing hands often, and avoiding touching our faces are all critical. They are crucial <b>even when we feel no symptoms</b>.Together they can take us a long way in breaking the chain of transmission.</br></h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<br><br><center> <h1>How we can <b>break the chain</b> of transmission — the maths</h1> </center><br>"),
                 	shiny::HTML("<h4><br>As we all know, Aotearoa, New Zealand has adopted <b><a href=https://covid19.govt.nz/alert-system/covid-19-alert-system/>4 Alert Levels</a></b>, that will place different social distancing expectations on all kiwis. Of course we should always sneeze into our elbows, wash our hands before touching the face, and stay home when sick regardless of alert level.</br><br>Maths explain how and why social how distancing measures can help control the spread of disease.</br><br>The <b>intensity</b> of any infectious disease is measured by <b>its reproduction number (R<sub>0</sub></b>)</b> — the average number of people one contagious person will infect. In short, for the infection to spread, the average infected person (whether symptomatic or not) must infect at least one other person (R<sub>0</sub> greater than 1).To eliminate the disease, each infected kiwi must infect self-isolate so quickly that they infect less than one other person (R<sub>0</sub> less than 1).</br><br>If we did nothing, global science shows that a person infected with <b>COVID-19 would infect 2-3 others (R<sub>0</sub> about 2.5)</b>. Until we have a vaccine, our most powerful tool to combat this disease is to infect fewer people – by assiduously washing our hands and maintaining physical distance, self-isolating at the first hint of respiratory symptoms, and keeping track of our close contacts. The power to stop the spread is in our hands.</br><br>The reproduction number (R<sub>0</sub></b>) of any virus depends on a few things, including how long a person is contagious, how many people they come into contact with, and how transmissible the virus is. That means we can make an epidemic less likely to spread by attacking any or all of these factors by cooperating with <a href=https://covid19.govt.nz/>Alert Level guidelines</a>.</br><br>To understand how each and every kiwi can take control of COVID-19, this simulator illustrates how cooperation with social distancing measures can reduce R<sub>0</sub> and create a better future for Aotearoa. For example, if we collectively reduce the reproduction number (R<sub>0</sub></b>) by 50%, we can see the effects in the figure below.</br></h4>")		
					),
					column(3)
				),
				br(),
				br(),
				fluidRow(
					column(3),
					column(7,img(src="4.R0b.png", style="width:100%")	),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<br><br><center> <h1><b>Alert Levels 2-4</b></h1> </center><br>"),
                 	shiny::HTML("<h4><br>Right now we are in Level 4 or Lockdown. An effective Level 4, when each and every kiwi stays within our bubble, can keep the virus within the bubble and <b>break the chain of transmission</b>. This will reduce the number of infections in the community, and make us all safer.</br><br>But the real key to eliminating COVID-19 is <b>after Level 4</b>. To eliminate or contain the virus, we must keep the reproductive number R<sub>0</sub> near or below 1. This means we must continue to cooperate with guidelines of Level 2 or 3 — reducing travel, social gatherings, and physical contact with friends, workmates, extended family, and neighbours.</h4>")


					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<br><br><center> <h1><b>Simulating spread</b> – the model and its assumptions</b></h1> </center><br>"),
					shiny::HTML("<h4><br>Governments across the world are relying on <b>mathematical projections</b> to help guide decisions about when to apply what guidelines and for how long. Note that COVID-19 Take Control is a simulator, for public use, based on a simple model, not a decision-making tool.</br><br>The <b>true performance</b> of models in this pandemic might take months or years to become clear. But to understand the value of any model, it’s crucial to know how they are made and the assumptions on which they are built.</br><br>For example, to arrive at the numbers reported above, we made a number of key assumptions.</br><br>First, we assumed on average, an infected individual will spread the disease to <b>2.5 other people (R<sub>0</sub> = 2.5)</b>. This is consistent with the best global data.</br><br>Next, we assumed that a ‘clinical’ case is an infected person who will unknowingly spread COVID-19 over a <b>five day pre-symptomatic incubation period</b>. After this period, the individual will develop symptoms, immediately isolate inside his or her bubble, and infect fewer people.</br><br>We also assumed <b>a ‘silent’ case</b> is an infected person, who doesn’t show recognisable symptoms, but will be slightly less infectious, over the full course of the infection. Thus they will unknowingly spread COVID-19 as well.</br><br>Finally, we assumed a direct linear correlation between social interactions and R<sub>0</sub>. This means that when an infected person reduces their physical contact with others by 50%, they also reduce their spread of the virus by 50%.</br><br>While there is still much we don't know, this simple model — using basic assumptions — allows you to simulate how the COVID-19 pandemic might play out in Aotearoa, New Zealand under different policy settings.</br></h4>")
					),
					column(3)
				),
				br(),
				fluidRow(
					column(3),
					column(7, actionButton('JumptoSimulator', "Run your scenario", class="btn btn-primary btn-lg")),					 
					column(3)
				),
				br(), br()		
				
			),
		#### Simulator ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		tabPanel("Simulator", value = "Simulator",
			sidebarLayout(
				sidebarPanel(
					fluidRow(
						# Initial number of cases
						div(style="display: inline-block;vertical-align:top; width: 80%;", h5(div(HTML("<b>Initial number of COVID-19 cases</b> (clinical plus silent)")))),
         				div(style="display: inline-block;vertical-align:bottom; width: 18%;", numericInput("initInf", label = NULL, value = 15, min = 0, max = 600, step = 1))
					),
					fluidRow(
						setSliderColor(c(rep("#b2df8a", 3)), sliderId=c(8, 9, 10)),
						h4(div(HTML("<b>Reproduction number (R<sub>0</sub>) under different social conditions</b>")))
					),
					fluidRow(
						div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("If we do not cooperate with alert levels 2-4, every person infected by COVID-19 will infect 2 or 3 others, at least (R<sub>0</sub> = 2.5). Each of those 2-3 infects 2 or 3 more. Each of those 4-9 infects 2-3 more, and so on. In an outbreak, our health system will get too swamped to care for all those who need it. This simulator shows that <b>the power to control COVID-19 is in our hands.</b>")))),
						# Do nothing option versus Break the chain
						radioButtons("DoNothingscenario", " ",	choices = list("The Do Nothing Option" = "Yes", "Break the chain of transmission" = "No"), inline = FALSE, selected = "No"),
						conditionalPanel(condition="input.DoNothingscenario == 'No'",
							div(style="display: inline-block;vertical-align:top; width: 80%;", h5(div(HTML("<b>R<sub>0</sub> during Level 4 Lockdown</b>: so far has been observed to be somewhere between 0.3 and 0.8.")))),
         					div(style="display: inline-block;vertical-align:top; width: 18%;", numericInput("HighControlR0", label = NULL, value = 0.4, min = 0, max = 3, step = 0.1)),
							br(),
							div(style="display: inline-block;vertical-align:top; width: 80%;", h5(div(HTML("<b>R<sub>0</sub> during Level 3</b>: <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2020/04/InternationalReffReview_FullReport_21Apr_FINAL2.pdf>depends</a> on how well we <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2017/01/Stochastic-Model-FINAL-RELEASE.pdf> cooperate </a> with Level 3 expectations.")))),
         					div(style="display: inline-block;vertical-align:top; width: 18%;", numericInput("LowControlR0", label = NULL, value = 1.1, min = 0, max = 3, step = 0.1)), 
							div(style="display: inline-block;vertical-align:top; width: 80%;", h5(div(HTML("<b>R<sub>0</sub> during Level 2</b>: depends on whether we go up or down, and how well we <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2017/01/Stochastic-Model-FINAL-RELEASE.pdf> cooperate </a> .")))),
         					div(style="display: inline-block;vertical-align:top; width: 18%;", numericInput("level2R0", label = NULL, value = 1.5, min = 0, max = 3, step = 0.1)),
							# add tooltip to selectInput element
         					sliderInput("Afterlevel4controlperiod", h5(div(HTML("<b>How long would you maintain the Level 3 restrictions?</b>"))), 0, 84, 28, step = 1, post = " days"),
							
							sliderInput("level2period", h5(div(HTML("<b>How long would you maintain the Level 2 restrictions?</b>"))), 0, 84, 28, step = 1, post = " days"),
							bsPopover("LowControlR0", "<ul><li><b>Excellent</b>: we keep our bubbles tight and small; we are pros at working and learning at home; we stay local, maintain 2m physical distance, and wash our hands often – R<sub>0</sub> between 0.8 and 1.1</li><li><b>Good</b>: but some bubbles get too big – R<sub>0</sub> between 1.1 and 1.3</li><li><b>Medium</b>: rules don’t apply to me; I’ll travel between towns to visit family and friends when I like – R<sub>0</sub> between 1.3 and 1.5</li><li><b>Poor</b>: can’t be bothered. There’s no point – R<sub>0</sub> of 1.5 or greater</li></ul>", trigger = "hover", options = list(container = "body", width = 180)),  	
							bsPopover("level2R0", "<ul><li><b>Level 2 Excellent</b> – R<sub>0</sub> between 1.1 and 1.3</li><li><b>Level 2 Good</b> – R<sub>0</sub> between 1.3 and 1.6</li><li><b>Level 2 Medium</b> – R<sub>0</sub> between 1.6 and 1.8</li><li><b>Level 2 Poor</b> – R<sub>0</sub> of 1.8 or greater</li></ul>", trigger = "hover", options = list(container = "body", width = 180)), 
							actionButton("reset", "Reset parameters"),	
							bsPopover("HighControlR0", "Somewhere between 0.3 and 0.8", trigger = "hover", options = list(container = "body", width = 180)), 
							actionButton("reset", "Reset parameters"),						
							br(),
							br(),
							prettyCheckbox(inputId = "AdvanceOptions", label = "Advanced Options", icon = icon("check"), status="primary"),
							conditionalPanel(condition="input.AdvanceOptions==1",
								div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("The default clinical parameters included in the model, and expressed in the editable boxes below, represent the World Health Organisation’s best global data. As an advanced option, you may change them.")))),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Basic reproduction number (R<sub>0</sub>)</b>: average number of people who will catch a disease from one contagious person with no distancing or hygiene measures")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("R0", label = NULL, value = 2.5, min = 0, max = 4, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Incubation period</b>: average number of days between exposure to COVID-19 and detectable symptoms.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("EOnsetToS", label = NULL, value = 5.8, min = 0, max = 10, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Generation time</sub></b>: average number of days before an infected individual is contagious enough to infect someone else.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("TG", label = NULL, value = 5.67, min = 0, max = 20, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Isolation delay</b>: average number of days between onset of symptoms and isolation within the bubble.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("EOnsetToIsol", label = NULL, value = 2.18, min = 0, max = 10, step = 0.1)),								
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Infectiousness inside the bubble of isolation</b>: once an infected person is isolated within his or her bubble, how much will he or she transmit the virus (as a % of the basic reproduction number R<sub>0</sub>)? (For example, an isolated clinical case’s reproduction number will be 65% of the basic reproduction number for a non-isolated clinical case.)")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("InfC", label = NULL, value = 65, min = 0, max = 100, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Prevalence of ‘silent’ cases</b>: what proportion of the <a href=https://www.nejm.org/doi/full/10.1056/NEJMoa2006100>total number of infections will be ‘silent’</a>, or undetected? (For example, 33% of all cases of COVID-19 are undetected silent cases.)")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("PSub", label = NULL, value = 33, min = 0, max = 100, step = 0.1)),
								br(),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Infectiousness of silent cases</b>: how much will a silent case transmit the virus, as a percentage of the reproduction number (R<sub>0</sub>)? (For example, the reproduction numver for a <a href=https://www.nejm.org/doi/full/10.1056/NEJMoa2006100>silent case</a> will be 50% of the basic reproduction number for a non-isolated clinical case.)")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("InfS", label = NULL, value = 50, min = 0, max = 100, step = 0.1)),
								br(),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Hospitalisation rate</b>: proportion of all cases (clinical plus silent) who require hospital care.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("Psevere", label = NULL, value = 5.25, min = 0, max = 100, step = 0.1)),
								sliderInput("level4controlperiod", h5(div(HTML("<b>Start and end times of Level 4.</b> — How long would you maintain Level 4 in place? "))), 0, 140, c(25, 58), step=1, post = " days"),
								sliderInput("simulation_time", h5(div(HTML("<b>Simulator time</b>: we recommend starting with simulating 140 days into the future, and increasing in 5 day increments to avoid overloading the server."))),0, 180, 140, step=1, post=" days"),		
						)
						),
						br(),
					),
				),
				 mainPanel(
					fluidPage(
						fluidRow(
							shiny::HTML("<center> <h1>Simulated COVID-19 cases for Aotearoa, New Zealand</b></h1> </center>"),
							br(),
							div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("There is much we don’t know about COVID-19 infection and transmission. And there is <b>great uncertainty</b> about what we think we know. We built that uncertainty into the simulator with ‘stochasticity’. If you <b>re-run the simulator</b> multiple times  for each collection of settings you choose, <b>you’ll notice different results</b>. This is not a mistake. It just conveys uncertainty in a rapidly changing field of knowledge. For a more thorough tutorial, please see the Tutorial tab.")))),
							#div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 5%;", actionButton("rerun", "Re-run simulation")),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 25%;",  h5(div(HTML("")))),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 16%;", actionButton("rerun", "Re-run simulation")),
							div(style="display: inline-block;vertical-align:bottom; width: 8%;", numericInput("Nbrep", label = NULL, value = 5, min = 1, max = 100, step = 1)),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 28%;", h5(div(HTML("<b>Select the number of replications to display</b> (we recommend starting with 5 replicates)")))),
							
							 
								
							div(style="display: inline-block;vertical-align:bottom; width: 99%;", plotlyOutput("plot_timecourse")),
							br(),br(),br(),br(),br(),br(),br(),br(),br(),
							shiny::HTML("<h5><br>This epidemiological simulator graphs the natural course of a COVID-19 epidemic in Aotearoa, New Zealand. The <b><font color=#01DFA5>green lines</font></b> depict the expected number of new cases per day (both ‘clinical’ or ‘silent’). The <b><font color=#FFBF00>yellow lines</font></b> depict the expected number of reported cases per day. There is a lag between infection and symptoms, and another between symptoms and a test result. We can see this lag between the peak of the green lines at the start of Level 4, and the peak of yellow lines of reported cases about a week later.</br><br>You can change the reproduction number under different alert levels, and set the duration of these levels. To change the virus’ clinical parameters, click on <b>Advanced Options</b> at the bottom. To reset back to the simulator’s default values, click on <b>Reset parameters</b> at the bottom. The graphs are interactive: hover over a curve to get values.</br></br><h5>")
						)
					)
				)
			)
		),
		tabPanel("Basics",
			shinyjs::useShinyjs(),
			fluidRow(
					column(3),
					column(7,
					shiny::HTML("<center> <h1>COVID-19 simulator: The Basics</h1> </center>"),
                 	shiny::HTML("<h4><br>This simulator uses a mathematical model to illustrate how COVID-19 could spread in Aotearoa, New Zealand. The pattern of spread depends on several numbers that describe virus transmission under different policy settings. You can push those numbers up and down on the left side of the Simulator screen (more on these below).</br><br>With no change in behaviour, each infected person will likely infect about 2.5 others (R<sub>0</sub> = 2.5). Physical distancing and hygiene behaviours will lessen virus transmission. Hence, we estimate a range of reproduction numbers that correspond to degree of public cooperation with distancing and hygiene expectations at Levels 2, 3, and 4. You can move reproduction numbers up and down on the left side of the Simulator screen (more on these below).</br><br><b>Remember, the power to control COVID-19 is in our hands.</b></br></h4>"),
					br(),
					shiny::HTML("<h2>Simulating virus transmission<h2>"),
					shiny::HTML("<h4><br>The simulator uses a standard epidemiological model based on how and when people transmit the virus. It comprises 2 types of cases.</br><br><br><b>‘Clinical’ and ‘silent’ cases</b></br><br>The simulator’s <b><font color=#FFBF00>yellow line</font></b> shows the expected number of reported cases. They have <a href=https://thespinoff.co.nz/science/18-03-2020/siouxsie-wiles-how-testing-for-covid-19-works/>symptoms</a>, get tested, and show up in the <a href=https://www.health.govt.nz/our-work/diseases-and-conditions/covid-19-novel-coronavirus/covid-19-current-situation/covid-19-current-cases>Ministry of Health’s daily counts</a> of confirmed and probable cases.</br><br>The simulator’s <b><font color=#01DFA5>green line</font></b> also accounts for <a href=https://www.npr.org/sections/goatsandsoda/2020/04/13/831883560/can-a-coronavirus-patient-who-isnt-showing-symptoms-infect-others>‘silent’</a> cases, who never show up in the Ministry’s official counts. They fly under the radar for any of several reasons: they have limited access to health care services; they get sick but never get tested because ‘she’ll be right, it’s just a flu’; their symptoms are too mild to recognise; they never have symptoms; or their test is a <a href=https://www.livescience.com/covid19-coronavirus-tests-false-negatives.html>‘false negative’</a>, but they are not symptomatic enough for their doctor to call them a <a href=https://www.newsroom.co.nz/2020/04/07/1117858/what-are-probable-cases-and-why-are-they-rising>‘probable case’</a>.</br><br>Because we cannot detect the silent cases, there is much uncertainty about how many there are and how readily they transmit the virus. Research studies of varying sizes suggest the silent cases comprise anywhere from <a href=https://www.nature.com/articles/d41586-020-00822-x>18%</a> to <a href=https://thenextweb.com/syndication/2020/04/13/scientists-find-78-of-people-dont-show-symptoms-of-coronavirus-heres-what-that-could-mean/>78%</a> of all infected people. Iceland has <https://www.covid.is/data>tested 10% of its population</a>, at random, and found about <a href=https://www.buzzfeed.com/albertonardelli/coronavirus-testing-iceland>half of all positive cases detected no symptoms</a>.</br><br>How much these silent cases will transmit the virus is similarly uncertain, but data suggest that silent cases <a href=https://www.nejm.org/doi/10.1056/NEJMc2001737>can transmit the virus even when they have mild or no symptoms</a>. However, silent cases are likely to transmit less than the clinical cases. Media have reported <a href=https://www.stuff.co.nz/national/health/121046464/coronavirus-air-nz-steward-linked-to-bluff-wedding-cluster-deeply-upset>pre-symptomatic transmission causing COVID-19 clusters in Aotearoa, New Zealand</a>. In Advanced Options, you can set the proportion of infections that are silent, and the silent infections’ transmission patterns.</br><br><br><b>Outside and inside the bubble</b></br><br>The simulator also distinguishes between infected people who are isolated within their bubbles, and those who are not. Once within the bubble, their physical contacts are limited so transmission rates will depend on the size of the bubble. If we keep our bubbles tight, work and learn from home whenever possible, keep 2m distance from others, and stay local, we will continue to break the <b>chain of transmission</b>.</br><br>The model on which the simulator runs assumes that clinical infections stick to their bubbles within 2 days of detection; but silent cases never isolate because they don’t know they should.</br><br>This highlights the importance of rapid contact tracing. The sooner we can identify and isolate all close contacts of an infected person, the fewer people those potential new silent and clinical cases will infect.</br><br>The figure below illustrates transmission by clinical vs. silent, and outside vs. inside the bubble.</br></h4>")
				),
				column(2)
				),
				br(),
				fluidRow(
					column(3),
					column(8,img(src="silentvsclinical.png", style="width:85%")	),
					column(3)
				),
				fluidRow(
					column(3),
					column(7,
					br(),
					br(),
					shiny::HTML("<h2>What can I change in the simulator?</h2>"),
					shiny::HTML("<h4><br>The boxes on the left-hand side of the simulator allow you to envision how the disease might spread under different policies, and different levels of cooperation. You can push them up or down, according to what Level you choose and when, and how well our team of 5 million cooperates.</br></h4>"),
					shiny::HTML("<h4><br><b>Initial number of confirmed COVID-19 cases</b> sets the number of infected individuals at the start of the simulation.</h4>"),
					br(),
					shiny::HTML("<h4><b>Reproduction number (R<sub>0</sub>) under different social conditions</b><ul><li><b>The 'Do Nothing' option</b> sets the reproduction number (R<sub>0</sub>) if we do nothing to contain the virus’ spread. This number predicts the average number of people who will catch a disease from one contagious person. For <b>COVID-19</b>, scientists around the world have estimated it to be <b>2.5</b>.</li><li><b>R<sub>0</sub> during Level 4</b> allows you to estimate the reproduction number (R<sub>0</sub>) during Level 4. It predicts the average number of people who will catch a disease from one contagious person during Level 4. This depends directly on how well each and every kiwi respects the guidelines. Scientists have observed the Level 4 R to be somewhere between 0.3 and 0.8. The simulator lets you push them up and down to see the results. Our Level 4 will be 33 days, but the simulator lets you change that to see what could have been.</li><li><b>R<sub>0</sub> during Level 3</b> allows you to estimate the reproduction number (R<sub>0</sub>) during Level 3. How much we can decrease the R<sub>0</sub> during Level 3 depends on how well we cooperate with the distancing, hygiene, and travel expectations under Level 3. We can’t know exactly how much Level 3 will reduce the R<sub>0</sub>, but we offer some estimates based on international experiences and let you play with them to see the possible outcomes. It also lets you set the duration of Level 3.</li></ul></h4>"),
					br(),
					shiny::HTML("<h4><b>Advanced options</b>. Default values for the ‘clinical parameters’ of COVID-19 described above are taken from the literature. When you click ‘Advanced options’ at the bottom, you can change these clinical parameters to understand how disease might spread under different circumstances, if scientific knowledge changes. You can change each parameter by itself to understand how it affects the course of the epidemic – how many get sick and when.</h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
		),
		tabPanel("Tutorial",
			shinyjs::useShinyjs(),
			fluidRow(
					column(3),
					column(7,
					shiny::HTML("<h2>Tutorial</h2>"),
					shiny::HTML("<h4><br>The following exercises will help you get acquainted with the app. At any time, you can click the <em>Reset parameters</em> button at the bottom of the left-hand side to return variables to their default values. We recommend resetting the parameters between these exercises.</br></h4>"),
					br(),
					shiny::HTML("<h4><br><ul><li><b>Tick the Do Nothing option</b>, and see what would happen if we had no Level 2, 3, or 4 restrictions.<br></br></li><li><b>Set the reproduction number R<sub>0</sub> during Level 4 to 1.5 and then 0.8, then to 0.4.</b> R<sub>0</sub> tells us the average number of people that a single contagious person infects in an entirely susceptible population. What happens when R<sub>0</sub> is greater than 1? What about when R<sub>0</sub> is below 1? Breaking the chain of transmission, and ultimately eliminating COVID-19, depends on each and every one of us cooperating with the guidelines for the Level we are at.<br></br></li><li><b>Set R<sub>0</sub> during Level 3 to 0.9, then 1.1, then to 1.3</b> (you can slightly increase the simulation time). What do you observe? What happens if we continue to observe hygiene and distancing guidelines, and keep our bubbles tight? What happens if we don’t? The more you play with the R<sub>0</sub> during Level 3 and the duration of level 3, the more obvious its importance becomes.<br></br></li><li><b>Increase the initial number of infected persons to 100</b>. What changes do you observe with more infected people to start? Does increasing the initial number of infected persons change the number of individuals who get infected? Does it change the time of the peak? Does it change the duration of restrictions we would need to contain COVID-19? The more you play with the initial number of cases, the more obviously important swift response becomes.</li></br></h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
		),
		tabPanel("About",
			shinyjs::useShinyjs(),
			fluidRow(
					column(12,
			#fluidPage(
				#br(),
				includeMarkdown("about.Rmd")),
					column(1)
				),
			fluidRow(style = "height:50px;"),
			tags$hr(),
       	)
	)
)
