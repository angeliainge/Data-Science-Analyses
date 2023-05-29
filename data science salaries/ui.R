dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Data Science Analyses"),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Data Information", tabName = "data_information", icon = icon("tags")),
      menuItem("Job Title Analysis", tabName = "Job_Title", icon = icon("people-group")),
      menuItem("Data Science Job Location", tabName = "map", icon = icon("map")),
      menuItem("Remote Ratio", tabName = "remote_ratio", icon = icon("home"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "data_information",
        
        fluidPage(
          titlePanel("Learning by Building & Capstone Project"),
          sidebarLayout(
            sidebarPanel(img(src = "logo.png", height = 60, width = 150),
                         p(),
                         p("Algoritma LBB and Capstone project Sparta Night Online"),
                         p("Inge Angelia"),
                         width = 2
            ),
            mainPanel(
              p(strong("Data Information from Dataset")),
              p("Year = The year the salary was paid"),
              p("experience_level = The experience level in the job during the year"),
              p("employment_type = The type of employement for the role: PT [Part-time] FT [Full-time] CT [Contract] FL [Freelance]"),
              p("job_title = The role worked in during the year"),
              p("salary = The total gross salary amount paid"),
              p("salary_currency	= The currency of the salary paid as an ISO 4217 currency code"),
              p("salaryinusd = The salary in USD"),
              p("employee_residence = Employee's primary country of residence in during the work year"),
              p("remote_ratio = The overall amount of work done remotely, possible values are as follows: 0 No remote work (less than 20%) 50 Partially remote 100 Fully remote (more than 80%)"),
              p("company_location = The country of the employer's main office or contracting branch as an ISO 3166 country code"),
              p("company_size = The average number of people that worked for the company during the year: S less than 50 employees (small) M 50 to 250 employees (medium) L more than 250 employees (large)")
            )
          )
        )
      ),
      
      tabItem(
        tabName = "Job_Title",
        
        # --------- INFO BOXES
        fluidRow(
          infoBox("Top Job Title Worldwide", "Data Scientist", icon = icon("users"), color = "black"),
          infoBox("total sample", nrow(ds_clean), icon = icon("group"), color = "black"),
          infoBox("total job title", length(unique(ds_clean$job_title)), icon = icon("list"), color = "black")
        ),
        
        # --------- BAR PLOT
        fluidRow(
          box(
            width = 12,
            plotlyOutput(outputId = "barplot")
          )
        ),
        fluidRow(
          box(
            width = 12,
            selectInput(
              inputId = "countrynames", 
              label = "Choose Country", 
              choices = ds_countryrole$company_country),
            plotlyOutput(outputId = "barplotcountry",
                         height = 800)
          )
        )
      ),
      
      # --------- HALAMAN KEDUA: Salary analysis
      tabItem(
        tabName = "map",
        plotlyOutput(outputId = "map",
                     height = 1000)
      ),
      tabItem(
        tabName = "remote_ratio",
        fluidPage(
          plotlyOutput("remoteratio",
                       height = "500"),
      
          checkboxGroupInput(
            inputId = "remoteratio", 
            label = "Choose Remote Level", 
            choices = unique(ds_remotework$remote_ratio),
            selected = "No remote"
                )
        
              )
            )
          )
        )
    )
