# Tune.R by JHCV

##### Required Packages #####

library(tidyverse)
library(lubridate)
library(plotly)
library(spotifyr)
library(ggwordcloud)
library(gganimate)
library(gifski)
library(purrr)
library(magick)

#####

##### Plot Appearance Theme #####

myTheme <- theme(legend.position = "none",
                 plot.background = element_rect(fill = "#02233F"),
                 panel.background = element_rect(fill = "#02233F"),
                 panel.grid = element_line(color = "#274066"),
                 axis.text = element_text(color = "white"),
                 axis.title = element_text(color = "white",
                                           hjust = .5),
                 plot.title = element_text(color = "white",
                                           hjust = .5),
                 plot.subtitle = element_text(color = "white",
                                              hjust = .5),
                 strip.background = element_rect(fill = "#02233F"),
                 strip.text.x = element_text(color = "white"),
                 plot.caption = element_text(color = "white",
                                             size = 5))

#####

##### Legend Appearance Theme #####

myLegend <- theme(legend.position = "right",
                  legend.background = element_rect(fill = "#02233F"),
                  legend.text = element_text(color = "white"),
                  legend.title = element_text(color = "white",
                                              hjust = .5))

#####

##### Spotify API Authorization #####

Sys.setenv("SPOTIFY_CLIENT_ID" = "xxx")
Sys.setenv("SPOTIFY_CLIENT_SECRET" = "xxx")
Sys.setenv("SPOTIFY_REDIRECT_URI" = "http://localhost:1410/")

accessToken <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"), 
                                        client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))

##### 

##### Playback Functions #####

nowPlaying <- function() {
  
  np <- get_my_currently_playing()
  
  artists <- paste(np$item$artist$name, collapse = " & ")
  
  df <- data.frame("artist" = artists,
                   "song" = np$item$name,
                   "album" = np$item$album$name) |> 
    
    pivot_longer(cols = everything(),
                 names_to = "Field",
                 values_to = "Value")
  
  tf <- tempfile(fileext = ".jpg")
  
  download.file(get_my_currently_playing()$item$album$images$url[1],
                destfile = tf,
                mode = "wb",
                quiet = TRUE)
  
  ac <- image_read(tf)
  
  print(ac, 
        info = FALSE)
  
  if (df$Value[2] == df$Value[3]) {
    
    return(head(df, 2))
    
  } else {
    
    return(df)
    
  }
  
}

skip <- function() {
  
  np <- nowPlaying()
  
  print(paste("Skipping:",
              np$Value[2],
              "by",
              np$Value[1],
              sep = " "))
  
  print("Now playing:")
  
  skip_my_playback()
  
  return(nowPlaying())
  
}

lastOne <- function() {
  
  skip_my_playback_previous()
  
  print("Yo what was that last one?")
  
  return(nowPlaying())
  
}

spinback <- function() {
  
  print("Yo run this one back!")
  
  seek_to_position()
  
  return(nowPlaying())
  
}

#####

##### Top Artists & Genres Functions #####

## TIMEFRAME OPTIONS:
# short - last 4 weeks
# medium - last 6 months
# long - all time listening history (default)

plot_genre_wordcloud <- function(timeframe = "long") {
  
  data <- get_my_top_artists_or_tracks("artists",
                                       time_range = paste(timeframe,
                                                          "_term",
                                                          sep = ""),
                                       limit = 50) |>
    
    select(name, genres, popularity) |> 
    
    unnest(genres) |>
    
    select(genres) |>
    
    group_by(genres) |>
    
    summarize("n" = n())
  
  ggplot(data,
         aes(label = genres,
             size = n,
             color = factor(genres))) +
    
    geom_text_wordcloud(shape = "diamond") +
    
    myTheme
  
}

plot_artist_wordcloud <- function(timeframe = "long") {
  
  data <- get_my_top_artists_or_tracks("artists",
                                       time_range = paste(timeframe,
                                                          "_term",
                                                          sep = ""),
                                       limit = 50,
                                       offset = 0) |>
    
    select(name, popularity, genres) 
  
  data$sf <- 0
  
  for (i in 1:nrow(data)) {
    
    data$sf[i] <- (51-i)^1.2
    
  }
  
  ggplot(data,
         aes(label = name,
             size = sf,
             color = factor(name))) +
    
    geom_text_wordcloud(shape = "diamond") +
    
    myTheme
  
}

#####

