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
                 	shiny::HTML("<h4><br>This app shows how powerful our actions are in taking control of COVID-19. It shows that our actions drive how many people will catch COVID-19 from one infected person; and that ‘catchiness factor’, or R, drives disease spread. Hence our behaviour drives spread.</br><br>In other words, the power to control COVID-19 is in each of our hands.</br></h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<br><br><center> <h1>How we can  control COVID-19 — the maths</h1> </center><br>"),
                 	shiny::HTML("<h4><br>As we all know, Aotearoa, New Zealand has adopted <b><a href=https://covid19.govt.nz/alert-system/covid-19-alert-system/>4 Alert Levels</a></b>, that place different physical distancing expectations on all kiwis. Of course we should always sneeze into our elbows, wash our hands before touching the face, and stay home when sick regardless of alert level.</br><br>Maths explain how and why social how distancing measures can help control the spread of disease.</br><br>The <b>intensity</b> of any infectious disease is measured by its reproduction number (R) — the average number of people one contagious person will infect. In short, for the infection to spread, the average infected person (whether symptomatic or not) must infect at least one other person (R greater than 1).To eliminate the disease, each infected kiwi must infect self-isolate so quickly that they infect less than one other person (R less than 1).</br><br><br><b>What if we did nothing?</b><br><br>If we had done nothing, global science shows that a person infected with COVID-19 would infect 2-3 others (R about 2.5), whether at home, work, school, or in day-to-day interactions. Some ‘super-spreaders’ would infect far more, especially when attending <a href=https://www.stuff.co.nz/national/health/coronavirus/120781038/coronavirus-matamata-cluster-at-45-cases-all-linked-to-bar>gatherings</a> outside <a href=https://www.stuff.co.nz/national/health/coronavirus/120902484/coronavirus-how-beautiful-bluff-wedding-became-major-covid19-cluster>their community</a>. Some <a href=https://www.npr.org/sections/goatsandsoda/2020/04/13/831883560/can-a-coronavirus-patient-who-isnt-showing-symptoms-infect-others>‘silent spreaders’</a> won’t even know they were infected.</br><br>This virus spreads when an infected person <a href=https://thespinoff.co.nz/society/06-04-2020/siouxsie-wiles-toby-morris-should-we-all-be-wearing-face-masks-to-prevent-covid-19-spread/>coughs or sneezes onto, or touches a surface, then someone else touches that surface then their face</a> before <a href=https://www.youtube.com/watch?v=2eqhw6yZk-c&feature=youtu.be>washing their hands</a>. The virus can live on hard surfaces (plastic, steel, etc.) for up to 3 days, and on softer surfaces (paper, cardboard) for up to 1 day. Many infections <a href=https://thespinoff.co.nz/covid-19/03-04-2020/siouxsie-wiles-toby-morris-a-note-on-apartments-and-bubbles/>spread by people who are infected</a> but don’t yet, or might never, show <a href=https://thespinoff.co.nz/science/18-03-2020/siouxsie-wiles-how-testing-for-covid-19-works/>symptoms</a>.</br><br>The reproduction number (R) of any virus depends on a few things: how long a person is contagious, how many people they come into contact with, and how transmissible the virus is. That means we can make an epidemic less likely to spread by attacking any or all of these factors by cooperating with <a href=https://covid19.govt.nz/>Alert Level guidelines</a>. As such, staying home when sick, <a href=https://thespinoff.co.nz/politics/22-03-2020/siouxsie-wiles-toby-morris-what-does-level-two-mean-and-why-does-it-matter/>reducing our physical contact with others</a>, coughing and sneezing into a tissue or an elbow, <a href=https://www.youtube.com/watch?v=pMtrbcYz2TU/>cleaning surfaces</a>, washing hands often, and avoiding touching our faces are all critical. Together they can take us a long way in beating COVID-19.</br></br><br>To understand how each and every kiwi can take control of COVID-19, the R calculator illustrates how physical distancing, hand hygiene, contact tracing, and self-isolating when exposed or sick can reduce R. For example, if we collectively reduce the reproduction number (R) by 50%, we can see the effects in the figure below.</br></h4>")		
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
					shiny::HTML("<br><br><center> <h1><b>Alert Levels 1-4</b></h1> </center><br>"),
                 	shiny::HTML("<h4><br>From 26 March to 28 April, we were in Level 4. Our ‘team of 5 million’ stayed within our bubbles and broke the chain of transmission. Testing rates soared as case numbers plummeted; scientists estimated our R during Level 4 was 0.34.</br><br>But the real key to eliminating COVID-19 is keeping our R near or below 1 during Levels 3, 2, and 1. This means we must continue to cooperate with guidelines — keeping a record of close contacts, limiting the size of gatherings, working and learning from home when possible, enjoying our local region and travelling only when safe and reasonable, and maintaining physical distance from strangers outside our bubble. The elbow bump and <a href=https://www.theguardian.com/world/2020/mar/17/east-coast-wave-should-replace-handshakes-and-hongi-amid-coronavirus-says-jacinda-ardern> East Coast</a> wave are the new normal.</br></h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
				fluidRow(
					column(3),
					column(7,
					shiny::HTML("<br><br><center> <h1><b>Simulating spread</b> — the model and its assumptions</b></h1> </center><br>"),
					shiny::HTML("<h4><br>Governments across the world are relying on <b>mathematical projections</b> to help guide decisions about when to apply what guidelines and for how long. COVID-19 Take Control is a simulator, for public use, that illustrates and communicates these models. It is not a decision-making tool.</br><br>The <b>true performance</b> of models in this pandemic might take months or years to become clear. But to understand the value of any model, it’s crucial to know how they are made and the assumptions on which they are built.</br><br>For example, to arrive at the numbers reported above, we made a number of key assumptions.</br><br>First, we assumed on average, an infected individual will spread the disease to <b>2.5 other people (R = 2.5)</b>. This is consistent with the best international data.</br><br>Next, we assumed that a ‘clinical’ case is an infected person, who will unknowingly spread COVID-19 over a <b>five day pre-symptomatic incubation period</b>. After this period, the person will develop symptoms, immediately isolate inside his or her bubble, and infect fewer people.</br><br>We also assumed there will be some ‘silent’ cases who are infected, but never gets tested because he or she doesn’t show recognisable symptoms, ignores the symptoms, or doesn’t have good access to health care. We assumed the silent cases might unknowingly spread COVID-19, but will be <a ref= https://www.newsroom.co.nz/2020/04/23/1141501/live-qa-8-covid-19-questions-answered-1-1>less infectious</a>, over the full course of the infection.</br><br>Finally, we assumed a direct linear correlation between social interactions and R. This means that when an infected person reduces their physical contact with others by 50%, they also reduce their spread of the virus by 50%.</br><br>While there is still much we don't know, this model allows you to simulate how the COVID-19 pandemic might play out in Aotearoa, New Zealand under different conditions of collective cooperation.</br></h4>")
					),
					column(3)
				),
				br(),
				#fluidRow(
				#	column(3),
				#	column(7, actionButton('JumptoSimulator', "Run your scenario", class="btn btn-primary btn-lg")),					 
				#	column(3)
				#),
				#br(), br()		
				
			),
		tabPanel("Basics",
			shinyjs::useShinyjs(),
			fluidRow(
					column(3),
					column(7,
					shiny::HTML("<center> <h1>COVID-19 Take Control: The Basics</h1> </center>"),
                 	shiny::HTML("<br><h2><b>The R Calculator page</b></h2><h4><br>The R Calculator page asks you to predict how we will behave and how effective our contact tracing and case isolation will be under each Alert Level. You can watch those answers push the national R up and down, to see how <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2017/01/Stochastic-Model-FINAL-RELEASE.pdf> powerfully hygiene, physical distancing, contact tracing, and case isolation drive down R</a>.</br><br>You’ll notice that improving from poor to medium on any of the measures — hygiene, distancing, contact tracing, and case isolation – is comparatively easier than improving from good to excellent. Although you can push the sliders on the left side of the R Calculator up and down yourself, bear in mind that as we get closer to perfect on any of the measures, improvement gets more and more difficult. Hence perfection is unlikely.</br><br>You’ll also notice that contact tracing and case isolation are pivotal to NZ’s continued success in eliminating COVID-19. The R Calculator highlights the importance of rapid contact tracing. The sooner we can identify and isolate all close contacts of an infected person, the fewer people they will infect. Done right, <a href=https://www.health.govt.nz/system/files/documents/publications/contact_tracing_report_verrall.pdf>experts find contact tracing and case isolation nearly as effective as a vaccine</a>. <br>"),
					br(),
					shiny::HTML("<br><h2><b>The Simulator page</b></h2><h4><br>The Simulator page uses mathematical models to illustrate how COVID-19 could spread in Aotearoa, New Zealand. The pattern of spread depends on the <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2020/04/InternationalReffReview_FullReport_21Apr_FINAL2.pdf>reproduction number, which depends on virus characteristics and human behaviour under different policy settings</a>. You can set your own R numbers for each Alert Level on the left side of the Simulator, and the duration of the Alert Levels themselves, and watch the modelled case numbers go up and down.</br><br>With no change in behaviour, each infected person will likely infect about 2.5 others (R = 2.5). Physical distancing, hygiene, case isolation, and contact tracing will lessen virus transmission. Hence, we estimate a range of reproduction numbers that correspond to public cooperation with distancing and hygiene expectations at Levels 1, 2, 3, and 4.</br><br>Lucky for us, with concerted effort by our team of 5 million, the power to control COVID-19 is in our hands. Indeed, evidence shows we are more likely to suffer harm by underreacting, or responding too late to a threat, than by overreacting. Indeed the greatest risks for spread of a pandemic virus are that people under-estimate the virus risk and act in dangerous ways, whether knowingly or not.</br></h4>"),
					br(),
					shiny::HTML("<h3>Simulating virus transmission<h3>"),
					shiny::HTML("<h4><br>The simulator uses a standard epidemiological model based on how and when people transmit the virus. It comprises 2 types of cases.</br><br><br><b>‘Clinical’ and ‘silent’ cases</b></br><br>The simulator’s <b><font color=#FFBF00>yellow line</font></b> shows the expected number of reported cases. They have <a href=https://thespinoff.co.nz/science/18-03-2020/siouxsie-wiles-how-testing-for-covid-19-works/>symptoms</a>, get tested, and show up in the <a href=https://www.health.govt.nz/our-work/diseases-and-conditions/covid-19-novel-coronavirus/covid-19-current-situation/covid-19-current-cases>Ministry of Health’s daily counts</a> of confirmed and probable cases.</br><br>The simulator’s <b><font color=#01DFA5>green line</font></b> also accounts for <a href=https://www.npr.org/sections/goatsandsoda/2020/04/13/831883560/can-a-coronavirus-patient-who-isnt-showing-symptoms-infect-others>‘silent’</a> cases, who never show up in the Ministry’s official counts. They fly under the radar for any of several reasons: they have <a href=https://cpb-ap-se2.wpmucdn.com/blogs.auckland.ac.nz/dist/d/75/files/2020/04/Estimated-ifrs_draft12.ACTUALFINAL.pdf>limited access to health care services</a>; they get sick but never get tested because they deny their symptoms, saying ‘she’ll be right, it’s just a cold’; their symptoms are too mild to recognise; they never have symptoms; or their test is a <a href=https://www.livescience.com/covid19-coronavirus-tests-false-negatives.html>‘false negative’</a>, but they are not symptomatic enough for their doctor to call them a <a href=https://www.newsroom.co.nz/2020/04/07/1117858/what-are-probable-cases-and-why-are-they-rising>‘probable case’</a>.</br><br>Because we cannot detect the silent cases, there is much uncertainty about <a ref=https://thespinoff.co.nz/society/14-05-2020/siouxsie-wiles-toby-morris-simple-rules-to-play-it-safe-at-alert-level-two/>how many there are and how readily they transmit</a> the virus. <a ref=https://wwwnc.cdc.gov/eid/article/26/8/20-1274_article>A South Korean study tested and followed several hundred workers</a> in the midst of a COVID-19 outbreak, finding less than 2% of all cases never felt symptoms. By contrast, Iceland has tested 10% of its population, at random, and found about <a href=https://www.buzzfeed.com/albertonardelli/coronavirus-testing-iceland>half of all positive cases reported feeling no symptoms, but they did not follow up</a>. In both studies, symptoms were self-reported.</br><br>How much these silent cases will transmit the virus is similarly uncertain, but data suggest that silent cases <a href=https://www.nejm.org/doi/10.1056/NEJMc2001737>can transmit the virus even when they have mild or no symptoms</a>. However, silent cases are likely to <a href=https://www.medrxiv.org/content/10.1101/2020.04.25.20079103v1> transmit less than the clinical cases </a>, and most transmissions come from symptomatic people. Media have reported <a href=https://www.stuff.co.nz/national/health/121046464/coronavirus-air-nz-steward-linked-to-bluff-wedding-cluster-deeply-upset>pre-symptomatic transmission causing COVID-19 clusters in Aotearoa, New Zealand</a>. Yet there is some evidence that children seem to transmit more rarely than adults, even within the household. And <a href=https://dontforgetthebubbles.com/the-missing-link-children-and-transmission-of-sars-cov-2/>children seem less likely to contract COVID-19</a> when exposed. </br><br>In Advanced Options, you can set the proportion of infections that are silent, and the silent infections’ transmission patterns.</br><br><br><b>Outside and inside the bubble</b></br><br>The Simulator page also distinguishes between infected people who are isolated within their bubbles, and those who are not. Research shows <a href=https://www.medrxiv.org/content/10.1101/2020.04.15.20064980v2>the virus spreads most in crowded enclosed places and events with prolonged exposure</a>, like congregations, family gatherings, public transport, care homes, and homeless shelters. But when we keep our bubbles tight, our physical contacts are limited so transmission rates will depend on the size of the bubble. If we keep our bubbles tight, work and learn from home whenever possible, keep 2m distance from others, and stay local we will continue to break the chain of transmission.</br><br>The model on which the simulator runs assumes that clinical infections stick to their bubbles within 2 days of detection; but silent cases will not be detected by contact tracing, and their contacts will never isolate because they don’t know they should.</br><br>The figure below illustrates transmission by clinical vs. silent, and outside vs. inside the bubble.</br></h4>")
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
					shiny::HTML("<h4><br>The boxes on the left-hand side of the simulator allow you to envision how the disease might spread under different policies, and different levels of cooperation. You can push them up or down, according to what Level you choose and when, and how well we cooperate.</br></h4>"),
					shiny::HTML("<h4><br><b>Initial number of confirmed COVID-19 cases</b> sets the number of infected individuals at the start of the simulation.</h4>"),
					br(),
					shiny::HTML("<h4><b>Reproduction number (R) under different social conditions</b><ul><li><b>The 'Do Nothing' option</b> sets the reproduction number (R) if we do nothing to contain the virus’ spread. This number predicts the average number of people who will catch a disease from one contagious person. For COVID-19, scientists have estimated it to be 2.5.</li><li><b>R during Level 4, 3, 2, and 1</b> allows you to estimate the reproduction number R during all Alert Levels. R predicts the average number of people who will catch a disease from one contagious person. This depends directly on how well each and every kiwi respects the guidelines, and <a href=https://www.stuff.co.nz/national/health/121229439/the-story-behind-the-doctor-pushing-for-better-covid19-contact-tracing>how effective our public health interventions are</a>. We offer some estimates based on international experiences and let you calculate your own in the R calculator. Scientists have observed the Level 4 R in NZ was somewhere 0.34; our case numbers in NZ were too low to estimate Level 3 R. The simulator lets you push these up and down to see the results.</li><li>Our Level 4 was 33 days, and our Level 3 was 16. But the Simulator lets you change the durations to see what could have been.</li></ul></h4>"),
					br(),
					shiny::HTML("<h4><b>Advanced options</b>. Default values for the ‘clinical parameters’ of COVID-19 described above are taken from the literature. When you click ‘Advanced options’ at the bottom, you can change these clinical parameters to understand how disease might spread under different circumstances, if scientific knowledge changes. You can change each parameter by itself to understand how it affects the course of the epidemic – how many get infected and when.</h4>")
					),
					column(3)
				),
				fluidRow(style = "height:50px;"),
				tags$hr(),
		),
		tabPanel("R calculator",  value = "Rcalculatortab",
			shinyjs::useShinyjs(),
			#fluidRow(
			#		#sliderInput(inputId = 'handwashing', label = h5(div(HTML("<b>Increased Hygiene"))), min = 0, max = 1, value = 0),
			#		column(3),
			#		column(7,
			#		shiny::HTML("<center><h2>The power to control COVID is in our hands</h2></center>"),
			#		shiny::HTML("<h4><br>On this page, you can explore effects of our behaviour on viral spread.  Watch R0 go up and down, on the left, based on your answers.  You’ll see that we are the architects of our future.</br></h4>"),
			#		br(),
			#		#shiny::HTML("<h4>First, let's look at the two main ways to reduce the reproduction number: <b>handwashing</b> & <b>physical distancing<b></br></h4>"),
			#		#div(style="display: inline-block;vertical-align:bottom; width: 99%;", sliderInput(inputId = 'handwashing', label = h5(div(HTML("<b>Increased Hygiene"))), min = 0, max = 1, value = 0)),
			#		#sliderInput("physicalDistancing", h5(div(HTML("<b>Start and end times of Level 4.</b> — How long would you maintain Level 4 in place? "))), 0, 140, c(25, 58), step=1, post = " days"),
			#		#shiny::HTML("<h4></h4>")
			#		),
			#		column(3)
			#	),
			fluidRow(
					#column(1),
					#column(10,
						sidebarLayout(
							sidebarPanel(
								fluidRow(
								# add tooltip to selectInput element
								chooseSliderSkin("Shiny", color = "#8da5ed"),
								#setSliderColor(color = c("#E88B4B", "#D4AF37", "#e1001a", "#777777", "#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91"), c(1,2,3,4,5,6,7,8, 9)),
								setSliderColor(color = c("#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91", "#8da5ed", "#8da5ed", "#8da5ed", "#8da5ed", "#777777"), c(1,2,3,4,5,6,7,8,9,10)),
								tags$head(tags$style(HTML('.js-irs-1 .irs-from, .js-irs-1 .irs-to, .js-irs-1 .irs-min, .js-irs-1 .irs-max, .js-irs-1 .irs-single {visibility: hidden !important;}'))),
								tags$head(tags$style(HTML('.js-irs-2 .irs-from, .js-irs-2 .irs-to, .js-irs-2 .irs-min, .js-irs-2 .irs-max, .js-irs-2 .irs-single {visibility: hidden !important;}'))),						
								tags$head(tags$style(HTML('.js-irs-3 .irs-from, .js-irs-3 .irs-to, .js-irs-3 .irs-min, .js-irs-3 .irs-max, .js-irs-3 .irs-single {visibility: hidden !important;}'))),
								tags$head(tags$style(HTML('.js-irs-4 .irs-from, .js-irs-4 .irs-to, .js-irs-4 .irs-min, .js-irs-4 .irs-max, .js-irs-4 .irs-single {visibility: hidden !important;}'))),
								tags$head(tags$style(HTML('.js-irs-0 .irs-from, .js-irs-0 .irs-to, .js-irs-0 .irs-min, .js-irs-0 .irs-max, .js-irs-0 .irs-single {visibility: hidden !important;}'))),
								#tags$head(HTML("<script type='text/javascript' src='js/slider.js'></script>")),
								#tags$head(tags$script(src = "slider.js")),
								#includeScript("slider.js"),
								# Initial number of cases
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 1px", h5(div(HTML("<h3><b>Your calculated reproduction number is</b></h3>")))), 
								div(style="display: inline-block;vertical-align:bottom; width: 100%; height: 340px", plotlyOutput("Rcalculator")),
								#div(style="display: inline-block;vertical-align:top; width: 100%; height: 110px",  sliderInput("physicaldistancing", div(style="display: inline-block;vertical-align:top; width: 200%; height: 38px;", div(style="display: inline-block;vertical-align:top; width: 200%; height: 30px;", h4(div(HTML("<b>Physical distancing</b>")))), div(style="display: inline-block;vertical-align:top; width: 11%; height: 15px;", h5(div(HTML("<font color=#939393 size=3><b>Level 1</b></font>")))), div(style="display: inline-block;vertical-align:top; width: 18%; height: 15px;",h5(div(HTML("<font color=#939393 size=3><b>Level 2</b></font>")))), div(style="display: inline-block;vertical-align:top; width: 20%; height: 15px;",h5(div(HTML("<font color=#939393 size=3><b>Level 3</b></font>")))), div(style="display: inline-block;vertical-align:top; width: 15%; height: 15px;",h5(div(HTML("<font color=#939393 size=3><b>Level 4</b></font>"))))), 0, 85, 20, step = 1, post = " %", ticks=TRUE)),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 25%; height: 65px;", h4(div(HTML("<b>Physical distancing</b>")))),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 2%; height: 65px;", ''),
							div(style="display: inline-block; vertical-align:bottom; width: 70%; height: 90px;",
								#div(style="display: inline-block; vertical-align:top; width: 100%; height: 28px;", h5(div(HTML("<b>Physical distancing</b>")))), 
								div(style="display: inline-block; vertical-align:top; width: 20%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Level 1</font>")))), 									div(style="display: inline-block; vertical-align:top; width: 30%; height: 1px;",  h5(div(HTML("<font color=#939393 size=3>Level 2</font>")))), 
								div(style="display: inline-block; vertical-align:top; width: 30%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Level 3</font>")))),  
								div(style="display: inline-block; vertical-align:top; width: 15%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Level 4</font>")))), 
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 80px",  sliderInput("physicaldistancing", NULL, 0, 85, 20, step = 1, post = " %", ticks=TRUE)), 
							),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 25%; height: 65px;", h4(div(HTML("<b>Hygiene</b>")))),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 2%; height: 65px;", ''),
							div(style="display: inline-block; vertical-align:bottom; width: 70%; height: 90px;",
								#div(style="display: inline-block; vertical-align:top; width: 100%; height: 30px;", h5(div(HTML("<b>Hygiene</b>")))), 
								div(style="display: inline-block; vertical-align:top; width: 10%; height: 1px;", h5(div(HTML("<font color=#939393 size=3> </font>")))),
								div(style="display: inline-block; vertical-align:top; width: 35%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Poor</font>")))), 									div(style="display: inline-block; vertical-align:top; width: 22.5%; height: 1px;",  h5(div(HTML("<font color=#939393 size=3>Medium</font>")))), 
								div(style="display: inline-block; vertical-align:top; width: 16.5%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Good</font>")))),  
								div(style="display: inline-block; vertical-align:top; width: 11%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Excellent</font>")))), 
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 80px",  sliderInput("handwash", NULL, 0, 25, 20, step = 1, post = " %", ticks=TRUE)), 
							),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 25%; height: 65px;", h4(div(HTML("<b>Tracing contacts</b>")))),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 2%; height: 65px;", ''),
							div(style="display: inline-block; vertical-align:bottom; width: 70%; height: 90px;",
								#div(style="display: inline-block; vertical-align:top; width: 100%; height: 30px;", h5(div(HTML("<b>Tracing contacts</b>")))), 
								div(style="display: inline-block; vertical-align:top; width: 10%; height: 1px;", h5(div(HTML("<font color=#939393 size=3> </font>")))),
								div(style="display: inline-block; vertical-align:top; width: 35%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Poor</font>")))), 									div(style="display: inline-block; vertical-align:top; width: 22.5%; height: 1px;",  h5(div(HTML("<font color=#939393 size=3>Medium</font>")))), 
								div(style="display: inline-block; vertical-align:top; width: 16.5%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Good</font>")))),  
								div(style="display: inline-block; vertical-align:top; width: 11%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Excellent</font>")))),
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 80px",  sliderInput("quarantine", NULL, 0, 100, 80, step = 1, post = " %", ticks=TRUE)),
							),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 25%; height: 65px;", h4(div(HTML("<b>Isolating cases and contacts</b>")))),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 2%; height: 65px;", ''),
							div(style="display: inline-block; vertical-align:bottom; width: 70%; height: 90px;",
								#div(style="display: inline-block; vertical-align:top; width: 100%; height: 30px;", h5(div(HTML("<b>Case isolation</b>")))), 
								div(style="display: inline-block; vertical-align:top; width: 10%; height: 1px;", h5(div(HTML("<font color=#939393 size=3> </font>")))),
								div(style="display: inline-block; vertical-align:top; width: 35%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Poor</font>")))), 									div(style="display: inline-block; vertical-align:top; width: 22.5%; height: 1px;",  h5(div(HTML("<font color=#939393 size=3>Medium</font>")))), 
								div(style="display: inline-block; vertical-align:top; width: 16.5%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Good</font>")))),  
								div(style="display: inline-block; vertical-align:top; width: 11%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Excellent</font>")))),
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 80px",  sliderInput("isolating", NULL, 0, 100, 80, step = 1, post = " %", ticks=TRUE)),
							),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 25%; height: 65px;", h4(div(HTML("<b>Winter weather</b>")))),
							div(style="display: inline-block; vertical-align:bottom; text-align:right; width: 2%; height: 65px;", ''),
							div(style="display: inline-block; vertical-align:bottom; width: 70%; height: 90px;",
								#div(style="display: inline-block; vertical-align:top; width: 100%; height: 30px;", h5(div(HTML("<b>Winter weather</b>")))),
								div(style="display: inline-block; vertical-align:top; width: 15%; height: 1px;", h5(div(HTML("<font color=#939393 size=3> </font>")))), 
								div(style="display: inline-block; vertical-align:top; width: 20%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Balmy</font>")))),
								div(style="display: inline-block; vertical-align:top; width: 20%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Mild</font>")))),
								div(style="display: inline-block; vertical-align:top; width: 20%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Cold</font>")))),
 								div(style="display: inline-block; vertical-align:top; width: 20%; height: 1px;",  h5(div(HTML("<font color=#939393 size=3>Frigid</font>")))), 
								#div(style="display: inline-block; vertical-align:top; width: 10%; height: 1px;", h5(div(HTML("<font color=#939393 size=3>Excellent</font>")))),
								div(style="display: inline-block;vertical-align:top; width: 100%; height: 80px",  sliderInput("winter", NULL, 0, 50, 0, step = 1, post = NULL, ticks=TRUE)),				
							)			
								), width = 4),
							mainPanel(
								shiny::HTML("<center><h2>The power to control COVID is in our hands</h2></center>"),
					#shiny::HTML("<h4><br>On this page, you can explore the effects of <a href = https://www.nature.com/articles/s41562-020-0884-z#ref-CR246 > our behaviour on viral spread </a>. Watch the reproduction number R go up and down, on the left, based on your answers. You’ll see that we are the architects of our future.</br></h4>"),
								br(),
								div(style="display: inline-block; vertical-align:bottom; width: 100%; height: 120px;", h4(div(HTML("<br>Use this page to calculate R during Alert Levels, based on your <b>answers to the questions</b> below (or on your predictions with the sliders to the left). Then <b>enter your calculated R</b> for each Level in the box below. Then <b>run your scenario</b> to see how our behaviour shapes our COVID-19 future.</br>")))),
								div(style="display: inline-block;vertical-align:top; width: 15%;", ""), 
								div(style="display: inline-block;vertical-align:top; width: 10%;", numericInput("Rlevel4", label = 'R during Level 4', value = 0.4, min = 0, max = 3, step = 0.1)), 
								div(style="display: inline-block;vertical-align:top; width: 2%;", ""),
								div(style="display: inline-block;vertical-align:top; width: 10%;", numericInput("Rlevel3", label = 'R during Level 3', value = 1, min = 0, max = 3, step = 0.1)), 
								div(style="display: inline-block;vertical-align:top; width: 2%;", ""),
								div(style="display: inline-block;vertical-align:top; width: 10%;", numericInput("Rlevel2", label = 'R during Level 2', value = 1.8, min = 0, max = 3, step = 0.1)), 
								div(style="display: inline-block;vertical-align:top; width: 2%;", ""),
								div(style="display: inline-block;vertical-align:top; width: 10%;", numericInput("Rlevel1", label = 'R during Level 1', value = 2.2, min = 0, max = 3, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 2%;", ""),
								div(style="display: inline-block;vertical-align:bottom; width: 10%; height: 80px;", actionButton('JumptoSimulator', "Run your scenario", class="btn btn-primary btn-lg") ),
								br(),
								br(),
								br(),
								#div(style="display: inline-block; vertical-align:bottom; width: 100%; height: 70px;", h4(div(HTML("<b>Explore the effects of <a href = https://www.nature.com/articles/s41562-020-0884-z#ref-CR246 > our behaviour on viral spread</a></b>. Watch the reproduction number R go up and down, on the left, based on your answers. You’ll see that we are the architects of our future.")))),
								div(style="display: inline-block; vertical-align:bottom; width: 100%; height: 70px;", h3(div(HTML("<b>Controlling R</b>")))),
								div(style="display: inline-block; vertical-align:bottom; width: 100%; height: 70px;", h4(div(HTML("You can explore effects on viral spread of our behaviour, contact tracing, and isolating cases and contacts.  Watching R go up and down, you’ll see that we are the architects of our future. You will also see that contact tracing and case isolation are crucial to eliminating COVID-19.")))),
								div(style="display: inline-block; vertical-align:bottom; width: 100%; height: 35px;", h5(div(HTML("First, choose an Alert Level for which you want to explore the reproduction number R:")))),
								#div(style="display: inline-block;vertical-align:bottom; width: 100%; height: 80px;", h5(div(HTML("<h3><b>Controlling R with behaviour</b></h4>")))),
								#div(style="display: inline-block;vertical-align:bottom; width: 100%;", h5(div(HTML("<i> First, choose an Alert Level for which you want to explore the reproduction number R:</i>")))),
br(),
								div(style="display: inline-block;vertical-align:bottom; width: 100%; height: 70px;", radioButtons("baselinelevel", NULL, width = '100%', inline = TRUE,
									   c("Alert level 4" = "L4",
										 "Alert level 3" = "L3",
										 "Alert level 2" = "L2",
										 "Alert level 1" = "L1"))),
								#div(style="display: inline-block;vertical-align:bottom; width: 100%; height: 45px;", h5(div(HTML("<h4><b>Physical distancing</b></h4>")))),
								 bsCollapsePanel(h5(div(HTML("<h4><b>Physical distancing</b></h4>"))), 
								conditionalPanel(condition="input.baselinelevel=='L4'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L4PH1", "I stay home, except", width = '100%',
									   c("to shop for food and essentials, as infrequently as possible and keeping a respectful 2m distance; to go to work, because I’m an essential worker; to go for a daily walk in my neighbourhood with my bubble-mates." = "L4PH1W1",
										 "all of the above, but I shop several times a week because I can’t be bothered planning ahead." = "L4PH1W2",
										 "I consider mountain biking, surfing, hunting, and kayaking essential, so you can’t stand between me and my board, bike, or boat." = "L4PH1W3",
										 "I’ll go to my mates’ house, visit my mum, and see my girlfriend whenever I want." = "L4PH1W4"))),
								),
								conditionalPanel(condition="input.baselinelevel=='L3'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L3PH1", "During Level 3, I went to work because I cannot work at home. At work,", width = '100%',
									   c("my colleagues and I are now pros at the 2 metre dance of physical distancing; we track all ins and outs for contact tracing purposes; we take breaks in shifts to avoid swamping the smoko room; we temperature-check all staff and customers before they can enter the site; we set up a schedule for customer pick-ups so there are no queues." = "L3PH1W1",
										 "we keep 2 metres apart, and track all visitors, and ensure that there are no crowded queues of customers; but can’t be bothered with temperature checks." = "L3PH1W2",
										 "we try to keep 1 meter apart, but really can’t. We do our level best to control queues, but they sometimes get on top of us." = "L3PH1W3",
										 "can’t be bothered. We are young and healthy, as are our customers. This is all an over-reaction and I’ll do as I please." = "L3PH1W4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L3PH2", "Went to the supermarket or got take-aways", width = '100%',
									   c("shopped once a week or less, at times chosen to avoid queueing." = "L3PH2W1",
										 "shopped several days of the week, because planning ahead is hard; we got takeaways from the neighbourhood a couple times; but we all did click and collect, or kept a respectful 2m physical distance." = "L3PH2W2",
										 "who needs supermarkets now. I get take-aways once a day from all over town. We try to keep 2m distance, but don’t always succeed." = "L3PH2W3",
										 "I get takeaways every meal, from all over town, no matter the queue." = "L3PH2W4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L3PH3", "Kids and school", width = '100%',
									   c("one of us was at home, so we kept the kids home." = "L3PH3W1",
										 "sent the kids to school only on days when all carers in our bubble had to work; and we kept 2m away from other parents at school." = "L3PH3W2",
										 "we kept the kids home, but they sneak out to their mates’ houses most afternoons " = "L3PH3W3",
										 "I haven’t seen the kids in days, no idea where they are." = "L3PH3W4"))),
								),
								conditionalPanel(condition="input.baselinelevel=='L2'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L2PH1", "I can work at home", width = '100%',
									   c("so I do, every day" = "L2PH1W1",
										 "I work at home most days. When I do go to the office I keep a careful log of who I interact with, and maintain a safe and respectful 2m distance from my colleagues." = "L2PH1W2",
										 "I work at home one day a week, and at work we keep our physical distance, clean surfaces often, and don’t share food, cups, or pens." = "L2PH1W3",
										 "Woohoo for Level 2. Danger’s over, we are back to daily morning tea and cake." = "L2PH1W4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L2PH2", "I will leave my bubble ", width = '100%',
									   c("to go to work and essential services as needed. Occasionally, I’ll go to a restaurant where we sit apart from other tables, or to a friend’s house to catch up with a couple of people where we maintain physical distance. But I avoid gatherings of more than 10 people." = "L2PH2W1",
										 "I’ll go to restaurants several times a week, and to catch up with friends and family whom I give ‘a quick hug’. Colleagues and new friends get an elbow bump at best." = "L2PH2W2",
										 "when it opens, I’ll be at the pub every night mate!" = "L2PH2W3",
										 "Bring on the Level 2 party." = "L2PH2W4")))
								),
								conditionalPanel(condition="input.baselinelevel=='L1'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L1PH1", "I can work at home", width = '100%',
									   c("so I do, every day" = "L1PH1W1",
										 "I work at home most days. When I do go to the office I keep a careful log of who I interact with, and maintain a safe and respectful 1m distance from my colleagues." = "L1PH1W2",
										 "I work at home one day a week, and at work we keep our physical distance, clean surfaces often, and don’t share food, cups, or pens." = "L1PH1W3",
										 "Woohoo for Level 1. Danger’s over, we are back to hugs and daily morning cake." = "L1PH1W4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("L1PH2", "I will leave my bubble ", width = '100%',
									   c("to go to work and essential services as needed. Occasionally, I’ll go to a restaurant where we sit apart from other tables, or to a friend’s house to catch up with a couple of people where we maintain physical distance. But I avoid gatherings of more than 10 people." = "L1PH2W1",
										 "I’ll go to restaurants several times a week, and to catch up with friends and family whom I give ‘a quick hug’. Colleagues and new friends get an elbow bump at best. " = "L1PH2W2",
										 "when it opens, I’ll be at the pub every night mate!" = "L1PH2W3",
										 "Bring on the party!" = "L1PH2W4")))
								)),
								bsCollapsePanel(h5(div(HTML("<h4><b>Hygiene</b></h4>"))), 
								
								#shiny::HTML("<h4><b><font color=#2c9c91> Hygiene </font></b></h4>"), 
								div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("H1", "Hygiene", width = '100%',
									   c("upon entering a new building, after using the toilet, after sneezing, before eating, and any other time I think of it, and before scratching my eyes or nose. Loving singing happy birthday twice while lathering." = "H1H1",
										 "after using the toilet, and when I return home, and whenever I think of it. I wash for the full 20 seconds." = "H1H2",
										 "I splash my hands with water after using the toilet, but never lather for 20 full seconds." = "H1H3",
										 "can’t be bothered. How could my own hands make me sick?" = "H1H4")))
								),
								bsCollapsePanel(h5(div(HTML("<h4><b>Tracing contacts</b></h4>"))), 
								conditionalPanel(condition="input.baselinelevel=='L4'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("Q1L4", "I keep a record of my movements and close contacts by", width = '100%',
									   c("keeping a daily diary of where I go, and who I talk to for more than 15 minutes. Pretty easy since I never leave my bubble." = "Q1L4Q1",
										 "as an essential worker, my employer is vigilant about recording all ins and outs to the work-site, so I don’t need to keep a diary." = "Q1L4Q2",
										 "as an essential worker, my employer does a great job recording ins and outs and controlling queues … but only when there is no one around; once it gets busy the customer comes first." = "Q1L4Q3",
										 "government needs to mind its own business. If Healthline calls, I will happily lie to them about where I’ve been and who I’ve seen." = "Q1L4Q4"))),   
								),
								conditionalPanel(condition="input.baselinelevel=='L3'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("Q1L3", "I keep a record of my movements and close contacts by", width = '100%',
									   c("using the NZ COVID Tracer app, keeping a daily diary of where I go and who I talk to for more than 15 minutes." = "Q1L3Q1",
										 "my employer is vigilant about recording all ins and outs to the work-site, so I don’t need to keep a diary." = "Q1L3Q2",
										 "my employer does a great job recording ins and outs and controlling queues … but only when there is no one around; once it gets busy the customer comes first." = "Q1L3Q3",
										 "government needs to mind its own business. If Healthline calls, I will happily lie to them about where I’ve been and who I’ve seen." = "Q1L3Q4"))),   
								),
								conditionalPanel(condition="input.baselinelevel=='L2'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("Q1L2", "I keep a record of my movements and close contacts by", width = '100%',
									   c("using the NZ COVID Tracer app, keeping a daily diary of where I go and who I talk to for more than 15 minutes." = "Q1L2Q1",
										 "my employer is vigilant about recording all ins and outs to the work-site, so I don’t need to keep a diary." = "Q1L2Q2",
										 "my employer does a great job recording ins and outs and controlling queues … but only when there is no one around; once it gets busy the customer comes first." = "Q1L2Q3",
										 "government needs to mind its own business. If Healthline calls, I will happily lie to them about where I’ve been and who I’ve seen." = "Q1L2Q4"))),   
								),
								conditionalPanel(condition="input.baselinelevel=='L1'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("Q1L1", "I keep a record of my movements and close contacts by", width = '100%',
									   c("using the NZ COVID Tracer app, keeping a daily diary of where I go and who I talk to for more than 15 minutes." = "Q1L1Q1",
										 "my employer is vigilant about recording all ins and outs to the work-site, so I don’t need to keep a diary, but I do use the Tracer app." = "Q1L1Q2",
										 "my employer does a great job recording ins and outs and controlling queues … but only when there is no one around; once it gets busy the customer comes first." = "Q1L1Q3",
										 "government needs to mind its own business. If Healthline calls, I will happily lie to them about where I’ve been and who I’ve seen." = "Q1L1Q4"))),   
																)
								),
								bsCollapsePanel(h5(div(HTML("<h4><b>Isolating cases and contacts</b></h4>"))), 
								conditionalPanel(condition="input.baselinelevel=='L4'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("I1L4", "I feel a bit crook, a tickle in the throat, a sniffle in the nose, or a rumbly in the tummy, I", width = '100%',
									   c("immediately self isolate within my home, avoid shared bathrooms and kitchens. My lovely bubble-mates leave meals for me outside the bedroom. And I spray bathroom surfaces with disinfectant after I use it. I ring my GP or Healthline immediately, and get tested when advised." = "I1L4Q1",
										 "immediately ring my GP and get tested if advised to do so. And I do my best to keep my distance from bubble-mates, and spray the bathroom and kitchen with disinfectant after I use them." = "I1L4Q2",
										 "wait to see if I get right proper sick before I ring the GP. And isolating from bubble-mates is impossible." = "I1L4Q3",
										 "Continue going to shops, and don’t bother ringing the GP or getting tested. She’ll be right." = "I1L4Q4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("I2L4", "Healthline rings me to say a close contact has tested positive, I", width = '100%',
									   c("if I am an essential worker, I immediately leave work and inform my employer. I then self isolate within my home, avoid shared bathrooms and kitchens. My lovely bubble-mates leave meals for me outside the bedroom. And I spray bathroom surfaces with disinfectant after I use it. I ring my GP or Healthline immediately, and get tested when advised." = "I2L4Q1",
										 "immediately ring my GP and get tested if advised to do so. And I do my best to keep my distance from bubble-mates, and spray the bathroom and kitchen with disinfectant after I use them." = "I2L4Q2",
										 "wait to see if I get right proper sick before I ring the GP. And isolating from bubble-mates is impossible." = "I2L4Q3",
										 "Continue going to shops, and don’t bother ringing the GP or getting tested. She’ll be right." = "I2L4Q4"))),
								),
								conditionalPanel(condition="input.baselinelevel!='L4'",
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("I1", "I feel a bit crook, a tickle in the throat, a sniffle in the nose, or a rumbly in the tummy, I", width = '100%',
									   c("immediately self isolate within my home, avoid shared bathrooms and kitchens. My bubble-mates leave meals for me outside the bedroom. I spray bathroom surfaces with disinfectant after I use it. I ring my GP or Healthline immediately, and get tested when advised." = "I1Q1",
										 "immediately ring my GP and get tested if advised. And I do my best to keep my distance from bubble-mates, and spray the bathroom and kitchen with disinfectant after I use them." = "I1Q2",
										 "wait to see if I get right proper sick before I ring the GP. And isolating from bubble-mates is impossible. But I do stay home most of the time." = "I1Q3",
										 "continue going to shops, and don’t bother ringing the GP or getting tested. She’ll be right." = "I1Q4"))),
									div(style="display: inline-block;vertical-align:top; width: 99%;", radioButtons("I2", "Healthline rings me to say a close contact has COVID19, I", width = '100%',
									   c("immediately leave work or school, self isolate within my home for 14 days, ring my GP or Healthline for advice, avoid work and shops, instead asking a neighbour or bubble-mate to drop some shopping outside the door if I need things." = "I2Q1",
										 "self isolate, except the odd run to the local shop for beer." = "I2Q2",
										 "continue going to work unless I get right proper sick, but avoid the shops." = "I2Q3",
										 "continue going to work, school, shops, and takeaways no matter what. She’ll be right." = "I2Q4")))
 
								)
								),
								width = 7						
							)
						)
					#)
					#column(2)
			),		
		),
		#### Simulator ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		tabPanel("Simulator", value = "Simulator",
			sidebarLayout(
				sidebarPanel(
					#fluidRow(
						# Initial number of cases
					#	div(style="display: inline-block;vertical-align:top; width: 80%;", h5(div(HTML("<b>Initial number of COVID-19 cases</b> (clinical plus silent)")))),
         			#	div(style="display: inline-block;vertical-align:bottom; width: 18%;", numericInput("initInf", label = NULL, value = 15, min = 0, max = 600, step = 1))
					#),
					fluidRow(
						h4(div(HTML("<b>Reproduction number (R) under different social conditions</b>")))
					),
					fluidRow(
						#div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("If we do not cooperate with alert levels 2-4, every person infected by COVID-19 will infect 2 or 3 others, at least (R = 2.5). Each of those 2-3 infects 2 or 3 more. Each of those 4-9 infects 2-3 more, and so on. In an outbreak, our health system will get too swamped to care for all those who need it. This simulator shows that <b>the power to control COVID-19 is in our hands.</b>")))),
						# Do nothing option versus Break the chain
						radioButtons("DoNothingscenario", " ",	choices = list("The Do Nothing Option" = "Yes", "Break the chain of transmission" = "No"), inline = FALSE, selected = "No"),
						conditionalPanel(condition="input.DoNothingscenario == 'No'",
							div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>R during Level 4</b>: observed between 0.3 and 0.6.")))),
         					div(style="display: inline-block;vertical-align:top; width: 20%;", numericInput("HighControlR0", label = NULL, value = 0.4, min = 0, max = 3, step = 0.1)),
							#bsPopover("HighControlR0", "Somewhere between 0.3 and 0.8", trigger = "hover", options = list(container = "body", width = 180)), 
							br(),
							div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>R during Level 3</b>: use the R Calculator")))),
         					div(style="display: inline-block;vertical-align:top; width: 20%;", numericInput("LowControlR0", label = NULL, value = 1, min = 0, max = 3, step = 0.1)), 
							div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>R during Level 2</b>: use the R Calculator")))),
         					div(style="display: inline-block;vertical-align:top; width: 20%;", numericInput("level2R0", label = NULL, value = 1.8, min = 0, max = 3, step = 0.1)),
							div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>R during Level 1</b>: use the R Calculator")))),
         					div(style="display: inline-block;vertical-align:top; width: 20%;", numericInput("level1R0", label = NULL, value = 2.2, min = 0, max = 3, step = 0.1)),

							
														
#setSliderColor(color = c(rgb(25.5, 41.2, 88.2), "#D4AF37", "#e1001a", "#777777", "#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91", "#2c9c91"), c(1,2,3,4,5,6,7,8, 9)),
         					sliderInput("Afterlevel4controlperiod", h5(div(HTML("<b>How long would you maintain the Level 3 restrictions?</b>"))), 0, 84, 16, step = 1, post = " days"),
							#chooseSliderSkin("Flat", color = "blue"),
							#setSliderColor(color = "#d4af37", 1),
							sliderInput("level2period", h5(div(HTML("<b>How long would you maintain the Level 2 restrictions?</b>"))), 0, 84, 28, step = 1, post = " days"),
							sliderInput("level1period", h5(div(HTML("<b>How long would you maintain the Level 1 restrictions?</b>"))), 0, 84, 28, step = 1, post = " days"),
							#bsPopover("LowControlR0", "<ul><li><b>Excellent</b>: we keep our bubbles tight and small; we are pros at working and learning at home; we stay local, maintain 2m physical distance, and wash our hands often – R between 0.8 and 1.1</li><li><b>Good</b>: but some bubbles get too big – R between 1.1 and 1.3</li><li><b>Medium</b>: rules don’t apply to me; I’ll travel between towns to visit family and friends when I like – R between 1.3 and 1.5</li><li><b>Poor</b>: can’t be bothered. There’s no point – R of 1.5 or greater</li></ul>", trigger = "hover", options = list(container = "body", width = 180)),  	
							#bsPopover("level2R0", "<ul><li><b>Level 2 Excellent</b> – R between 1.1 and 1.3</li><li><b>Level 2 Good</b> – R between 1.3 and 1.6</li><li><b>Level 2 Medium</b> – R between 1.6 and 1.8</li><li><b>Level 2 Poor</b> – R of 1.8 or greater</li></ul>", trigger = "hover", options = list(container = "body", width = 180)), 
							# Initial number of cases
							actionButton("reset", "Reset parameters"),						
							br(),
							br(),
							prettyCheckbox(inputId = "AdvanceOptions", label = "Advanced Options", icon = icon("check")),
							conditionalPanel(condition="input.AdvanceOptions==1",
								div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("The default clinical parameters included in the model, and expressed in the editable boxes below, represent the best national and global data. As an advanced option, you may change them.")))),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Initial number of COVID-19 cases</b> (clinical plus silent)")))),
								div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("initInf", label = NULL, value = 15, min = 0, max = 600, step = 1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Basic reproduction number (R<sub>0</sub>)</b>: average number of people who will catch a disease from one contagious person with no distancing or hygiene measures")))),
								div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("R0", label = NULL, value = 2.5, min = 0, max = 4, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Reproduction number pre-lockdown</b>: observed between 1.8 and 2.2. This could be due, in part, to measures put in place in early- to mid-March, including: the cancellation of mass gatherings, the isolation of international arrivals, and employees being encouraged to work from home.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("Rprelockdown", label = NULL, value = 2.2, min = 0, max = 4, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Incubation period</b>: average number of days between exposure to COVID-19 and detectable symptoms.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("EOnsetToS", label = NULL, value = 5.8, min = 0, max = 10, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Generation time</sub></b>: average number of days before an infected individual is contagious enough to infect someone else.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("TG", label = NULL, value = 5.67, min = 0, max = 20, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Isolation delay</b>: average number of days between onset of symptoms and isolation within the bubble.")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("EOnsetToIsol", label = NULL, value = 2.18, min = 0, max = 10, step = 0.1)),								
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Infectiousness inside the bubble of isolation</b>: once an infected person is isolated within his or her bubble (during Levels 3 and 4, or if isolated after exposure during Levels 2 and 1), how much will he or she transmit the virus?  Expressed as a % of the basic reproduction number R")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("InfC", label = NULL, value = 65, min = 0, max = 100, step = 0.1)),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Prevalence of ‘silent’ cases</b>: what proportion of the <a href=https://www.nejm.org/doi/full/10.1056/NEJMoa2006100>total number of infections will be ‘silent’</a>, or undetected? (For example, 33% of all cases of COVID-19 are undetected silent cases.)")))),
				 				div(style="display: inline-block;vertical-align:bottom; width: 20%;", numericInput("PSub", label = NULL, value = 33, min = 0, max = 100, step = 0.1)),
								br(),
								div(style="display: inline-block;vertical-align:top; width: 75%;", h5(div(HTML("<b>Infectiousness of silent cases</b>: how much will a silent case transmit the virus, as a percentage of the reproduction number (R)? (For example, the reproduction number for a <a href=https://www.nejm.org/doi/full/10.1056/NEJMoa2006100>silent case</a> will be 50% of the basic reproduction number for a clinical case.)")))),
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
							conditionalPanel(condition="input.DoNothingscenario == 'No'",
							div(style="display: inline-block;vertical-align:top; width: 100%;", h5(div(HTML("There is much we don’t know about COVID-19 infection and transmission. And there is <b>great uncertainty</b> about what we think we know. We built that uncertainty into the simulator with ‘stochasticity’. If you <b>re-run the simulator</b> multiple times for each collection of settings you choose, <b>you’ll notice different results</b>. This is not a mistake. It just conveys uncertainty in a rapidly changing field of knowledge. For a more thorough tutorial, please see the Tutorial tab.")))),
							
							#div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 5%;", actionButton("rerun", "Re-run simulation")),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 25%;",  h5(div(HTML("")))),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 16%;", actionButton("rerun", "Re-run simulation")),
							div(style="display: inline-block;vertical-align:bottom; width: 8%;", numericInput("Nbrep", label = NULL, value = 5, min = 1, max = 100, step = 1)),
							div(style="display: inline-block;horizontal-align:right;vertical-align:top; width: 28%;", h5(div(HTML("<b>Select the number of replications to display</b> (we recommend starting with 5 replicates)")))),
							),
							
							 
								
							div(style="display: inline-block;vertical-align:bottom; width: 99%;", plotlyOutput("plot_timecourse")),
							br(),br(),br(),br(),br(),br(),br(),br(),br(),
							shiny::HTML("<h5><br>This epidemiological simulator graphs the natural course of a COVID-19 epidemic in Aotearoa, New Zealand. The <b><font color=#01DFA5>green lines</font></b> depict the expected number of new cases per day (both ‘clinical’ or ‘silent’). The <b><font color=#FFBF00>yellow lines</font></b> depict the expected number of reported cases per day. There is a lag between infection and symptoms, and another between symptoms and a test result. We can see this lag between the peak of the green lines at the start of Level 4, and the peak of yellow lines of reported cases about a week later.</br><br>You can change the reproduction number under different alert levels, and set the duration of these levels. To change the virus’ clinical parameters, click on <b>Advanced Options</b> at the bottom. To reset back to the simulator’s default values, click on <b>Reset parameters</b> at the bottom. The graphs are interactive: hover over a curve to get values.</br></br><h5>")
						)
					)
				)
			)
		),
		tabPanel("Tutorial",
			shinyjs::useShinyjs(),
			fluidRow(
					column(3),
					column(7,
					shiny::HTML("<center><h2>Tutorial</h2></center>"),
					shiny::HTML("<h4><br>The following exercises will help you get acquainted with the app. At any time, you can click the <em>Reset parameters</em> button at the bottom of the left-hand side to return variables to their default values. We recommend resetting the parameters between these exercises.</br></h4>"),
					br(),
					shiny::HTML("<h2><b>R Calculator Page</b></h2>"),
					shiny::HTML("<h4><br><ul><li><b>On the R calculator tab, play with the answers to the questions under Controlling R with behaviour.</b> Observe the effects on R, to the left. Then push the hygiene, distancing, isolation, and tracing sliders up and down to see their relative importance in controlling R. Compare the power of Contact Tracing and Case Isolation, to Physical Distancing and Hygiene measures in combatting the spread of COVID19.<br></br></li><li><b>On the left side of the R calculator, choose Level 2 for distancing. Then push the Hygiene slider all the way to excellent and the Tracing contacts and Case isolation all the way to poor.</b>How low can we get R0 with just hygiene and distancing? Then gradually improve the tracing and isolating sliders to poor, then medium, then high medium, then good. What do you notice about R0? Once you get R0 to 1 or below, push hygiene down to medium or below. This gives you insight into the pivotal importance of contact tracing and case isolation.<br></br></li><li><b>Don’t forget to type your calculated R values into the boxes at the top of right side of the page. Then punch the Run your Scenario button and watch the number of cases rise and fall.</b></li></br></h4>"),
					shiny::HTML("<h2><b>Simulator page</b></h2>"),
					shiny::HTML("<h4><br><ul><li><b>On the Simulator page, first tick the Do Nothing option,</b>, and see what would happen if we had no Level 1, 2, 3, or 4 or public health interventions such as testing and contact tracing.<br></br></li><li><b>Set the reproduction number R during Level 4 to 1.1, then to 0.8, then to 0.4. </b> What happens when R >1? What about when R <1? Change the reproduction number (R) during Level 4 to 1.5 and observe what happens. Breaking the chain of transmission, and ultimately eliminating COVID-19, depends on each and every one of us cooperating with the guidelines for the Level we are at.<br></br></li><li><b>Set R during Level 3 to 1.1, then to 0.9, then to 0.6.</b> What do you observe? What happens if we continue to observe hygiene and distancing guidelines, and keep our bubbles tight? What happens if we don’t? The more you play with R during Level 3, the more obvious its importance becomes.<br></br></li><li><b>Set R during Level 2 to 1.8, then to 1.3, then to 0.9</b>. What do you observe? What happens if we continue to observe hygiene and distancing guidelines, and keep our bubbles tight? What happens if we don’t? The more you play with R during Level 2, the more obvious its importance becomes.<br></br></li><li><b>In Advanced Options, increase the initial number of infected persons to 100 or 500</b>. What changes do you observe with more infected people to start? Does increasing the initial number of infected persons change the number of individuals who get infected? Does it change the time of the peak? Does it change the duration of restrictions we would need to contain COVID-19? The more you play with the initial number of cases, the more obviously important swift response becomes.<br></br></li><li>At any time, you can click the <b>Reset Parameters</b> button at the bottom of the left-hand side to return variables to their default values. We recommend resetting the parameters between these exercises.</li></br></h4>")
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
