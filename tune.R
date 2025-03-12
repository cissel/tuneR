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
  
  pi <- get_playlist(str_remove(np$context$uri,
                                "spotify:playlist:"))
  
  # This one has a catch condition for my Spotify DJ
  # You might need to update this URL for your own DJ
  df <- data.frame("artist" = artists,
                   "song" = np$item$name,
                   "album" = np$item$album$name,
                   "context" = ifelse(np$context$uri == "spotify:playlist:37i9dQZF1EYkqdzj48dyYq",
                                      "DJ X",
                                      paste(pi$name,
                                            pi$owner$display_name,
                                            sep = " - "))) |> 
    
    pivot_longer(cols = everything(),
                 names_to = "Field",
                 values_to = "Value")
  
  tf <- tempfile(fileext = ".jpg")
  
  download.file(np$item$album$images$url[1],
                destfile = tf,
                mode = "wb",
                quiet = TRUE)
  
  ac <- image_read(tf)
  
  print(ac, 
        info = FALSE)
  
  return(df)
  
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
  
  seek_to_position(1)
  
  return(nowPlaying())
  
}

#####

##### Top Artists & Genres Functions #####

myTopArtists <- function(artists = 100,
                         timeframe = "long") {
  
  d1 <- get_my_top_artists_or_tracks("artists",
                                     time_range = paste(timeframe,
                                                        "_term",
                                                        sep = ""),
                                     limit = 50,
                                     offset = 0) |>
    
    select(name, 
           popularity)
  
  for (i in 2:(artists/50)) {
    
    d2 <- get_my_top_artists_or_tracks("artists",
                                       time_range = paste(timeframe,
                                                          "_term",
                                                          sep = ""),
                                       limit = 50,
                                       offset = (i-1)*50) |>
      
      select(name,
             popularity)
    
    df <- rbind(d1, d2)
    
  }
  
  return(df)
  
}

myTopTracks <- function(tracks = 10,
                        timeframe = "long") {
  
  d1 <- get_my_top_artists_or_tracks("tracks",
                                     time_range = paste(timeframe,
                                                        "_term",
                                                        sep = ""),
                                     limit = 50,
                                     offset = 0) #|>
    
    #select(name,
    #       artists$name,
    #       popularity)
  
  for (i in 2:(tracks/50)) {
    
    d2 <- get_my_top_artists_or_tracks("tracks",
                                       time_range = paste(timeframe,
                                                          "_term",
                                                          sep = ""),
                                       limit = 50,
                                       offset = (i-1)*50) #|>
      
      #select(name,
      #       artists,
      #       popularity)
    
    df <- rbind(d1, d2)
    
  }
  
  return(df)
  
}

## TIMEFRAME OPTIONS:
# short - last 4 weeks
# medium - last 6 months
# long - all time listening history (default)

plotGenreWordcloud <- function(timeframe = "long") {
  
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

plotArtistWordcloud <- function(timeframe = "long",
                                artists = 100) {
  
  df <- myTopArtists(100, timeframe)
  
  df$bt <- 0
  
  for (i in 1:nrow(df)) {
    
    df$bt[i] <- ((nrow(df)+1)-i)
    
  }
  
  ggplot(df,
         aes(label = name,
             size = bt,
             color = factor(name))) +
    
    geom_text_wordcloud(shape = "diamond") +
    
    myTheme
  
}

#####

