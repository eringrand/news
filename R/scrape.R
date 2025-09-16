library(httr2)
library(jsonlite)
library(lubridate)

# Set up what days we want data for
start_date <- ymd("2025-09-10")
today <- today()

days_wanted <- seq(start_date, today, by = 1)

for(date in days_wanted) {
  if(file.exists(glue::glue("csv/{date}.csv"))) {
    next
  }

  req <- request("https:/newsapi.org/v2/everything") |>
      req_url_query(
        q = '`"data science"`',
        from = date,
        pageSize = 10,
        apiKey = Sys.getenv("NEWS_API_KEY")
      )

    req_perform(req, path = paste0("data/", date, ".json"))

    json_data_raw <- fromJSON(glue::glue("data/{date}.json"))

    news_file <- json_data_raw$articles |>
      as.data.frame()

    # Write out data
    write.csv(news_file, glue::glue("csv/{date}.csv"), row.names = FALSE)
}
