shinyServer(function(input, output, session)
  {
  ds <- read_csv("ds_salaries.csv")
  
  ds_clean <- ds %>% 
    mutate( across(
      .cols = everything(),
      ~str_replace( ., "EN", "Entry-Level"))
    ) %>%
    mutate( across(
      .cols = everything(),
      ~str_replace( ., "MI", "Mid-Level"))
    ) %>%
    mutate( across(
      .cols = everything(),
      ~str_replace( ., "SE", "Senior-Level"))
    ) %>%
    mutate( across(
      .cols = everything(),
      ~str_replace( ., "EX", "Executive-Level"))
    ) %>% 
    mutate(
      experience_level = as.factor(experience_level),
      employment_type = as.factor(employment_type),
      job_title = as.factor(job_title),
      salary_currency = as.factor(salary_currency),
      employee_residence = as.factor(employee_residence),
      remote_ratio = as.factor(remote_ratio),
      company_location = as.factor(company_location),
      company_size = as.factor(company_size),
      salary = as.double(salary),
      salary_in_usd = as.double(salary_in_usd),
      company_country = countrycode(company_location, "iso2c", "country.name"),
      region = as.factor(company_country)
    ) %>% 
    select(-c(...1))
  

  
# halaman 1 done
  #plot 1 top 10 data scientist worldwide
  output$barplot <- renderPlotly({
    top10_title <- ds_clean %>%
      count(job_title) %>%
      arrange(desc(n)) %>% 
      mutate(label = glue("Job Title: {job_title}
                      Total: {n} persons ")) %>% 
      head(10)
    
    plot2 <- top10_title %>% 
      ggplot(aes(x = n,
                 y = reorder(job_title, n),
                 fill = n,
                 text = label)) +
      geom_col() +
      scale_fill_gradient(low = "#E6E6FA", high = "#C3B1E1") +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(title = 'Top 10 Data Science Job Title Worldwide',
           subtitle = "This plot shows the Job Title of Data Scientist worldwide",
           x = 'Number of Person',
           y = NULL)
    
    ggplotly(plot2, tooltip = "text")
    
  })

  #plot 2 data scientist by country  
  output$barplotcountry <-renderPlotly({
    ds_countryrole <- ds_clean %>%
      select(c(12, 4)) %>%
      group_by(company_country) %>% 
      count(job_title) %>% 
      mutate(
        company_country = as.factor(company_country),
        job_title = as.character(job_title),
        n = as.double(n)) %>% 
      arrange("company_country") %>%
      mutate(across(everything(), ~ ifelse(is.na(.), 0, .))) %>% 
      mutate(label = glue("Job Title: {job_title}
                      Total: {n} persons "))
    
    ds_countryrole <- subset(ds_countryrole, ds_countryrole$"company_country" == input$countrynames) %>%
      arrange(n)
    
    plot2b <- ds_countryrole%>% 
      ggplot(aes(x = n,
                 y = reorder(job_title, n),
                 fill = n,
                 text = label)) +
      geom_col() +
      scale_fill_gradient(low = "#E6E6FA", high = "#C3B1E1") +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(title = 'Data Science Job Title by Country',
           x = 'Number of Person',
           y = NULL) +
      xlim(0, 85)
    
    
    ggplotly(plot2b, tooltip = "text")
  })
  
# halaman 2 Data science Job location
  
  output$map <- renderPlotly({
    no_of_companies <- aggregate(ds_clean$company_country, list(ds_clean$company_country), table)
    
    no_of_companies <- no_of_companies %>% 
      rename(
        region = Group.1,
        Number_of_companies = x)
    
    map_data <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")
    map_data<-left_join(map_data,no_of_companies,by=c("COUNTRY"="region"))
    map_data<-na.omit(map_data)
    map<-plot_ly(map_data, type='choropleth', locations=map_data$CODE, z=map_data$Number_of_companies, text=map_data$COUNTRY, colorscale="Cividis", reversescale = T) %>%
      layout(title = "Number of companies employing Data Scientist")
    
    ggplotly(map)
  })

# halaman 3 remote ratio

  output$remoteratio <- renderPlotly({
    ds_remotework <- ds_clean %>% 
      select(c(1, 9)) %>% 
      mutate(
        remote_ratio=case_when(
          remote_ratio=="0" ~ "No remote",
          remote_ratio=="50" ~ "Partial remote",
          remote_ratio=="100" ~ "Full remote")) %>%
      group_by(work_year, remote_ratio) %>% 
      tally() %>%
      mutate(percentage = round(n/sum(n), 3),
             in_percent = percentage*100,
             work_year = as.factor(work_year),
             remote_ratio = as.factor(remote_ratio)) %>% 
      mutate(label = glue("Remote Ratio: {remote_ratio}
                      Percentage: {in_percent}%
                      Number of People: {n} people")) %>% 
      arrange(remote_ratio)
   
     ds_remotework <- ds_remotework %>% 
       select(c(work_year, remote_ratio, in_percent, label)) %>% 
       filter(remote_ratio %in% input$remoteratio)
     
     plotremoteratio2 <- ds_remotework %>% 
       ggplot(aes(x = work_year,
                  y = in_percent,
                  text = label)) +
       geom_line(aes(group = remote_ratio, col = remote_ratio)) +
       geom_point() +
       theme_minimal() +
       labs(title = 'Remote work ratio',
            x = NULL,
            y = 'Percentage') +
       guides(fill=guide_legend("Remote Ratio")) + ylim(0,100)
     
     ggplotly(plotremoteratio2, tooltip = "text")
     
  })
  
})