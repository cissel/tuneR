# First time using R? I can walk you through it.

Scroll down to get the TL;DR of what the visualizations look like.

## Install R & RStudio

I like to think of R & RStudio as a car that will take you where you want to go. R is like the engine under the hood. You know it is there and you need it to work properly, but if things are going smoothly then you don't need to open your hood every time you use your car. RStudio is like the driver's seat. This is where you take the wheel and head to your destination. Follow the link below to install R & RStudio. Posit does a good job of simplifying the download & install process. All you really need to do is check your operating system & update version to make sure you install the right versions.

https://posit.co/download/rstudio-desktop/

## Get a Spotify API Key

You need to create a Spotify for Developers account. Click the link below.

https://developer.spotify.com/

After you've created a developer account go to your dashboard and create an app - you can call it wherever you'd like. You can put whatever you want in the description. You can leave the website blank. You'll need to set your Redirect URI to http://localhost:1410/ and then you can go ahead and save it.

Now you should have a Spotify API key and secret key (I think they call it a Client ID and Client Secret). You might have to go to Dashboard > [Your App] > Settings to find them, but you should see your Client ID and a button you need to click to see your Client Secret. Keep this tab open. We will be right back.

## Open RStudio

In the top left corner you should see a little white square with a green plus sign bubble. Click the dropdown menu and select R Markdown. It is going to show up with a default template, but delete all of that stuff. Come back when you're done.

## Come back to GitHub to wrap things up

Once you get back to this page, navigate to vibes.rmd in this repo. GitHub is awesome because you should see a button in the top right corner to copy my code. You should click that button. Then you should go back to RStudio & paste it in that empty .rmd file you just created. Go back to your Spotify for Developers tab and copy & paste your Client ID and Client Secret in the setup chunk of the .rmd file. Now you're ready to run the program. You should see a white box in the top right corner with a green arrow going to the right. Click that dropdown menu and select "Run All" at the bottom. It might take a long time to run. It will probably take a long time to run. For context on what to expect I have ~4k songs saved and it takes ~15 minutes to finish running on a brand new Macbook Pro. If you click the "Knit" dropdown menu and select "Knit to HTML", it will output an interactive HTML page that takes you on a fun journey through your entire Spotify saved tracks history.

# TuneR
Use the Spotify API to pull data about your saved tracks to learn more about your taste in music and how it changes over time.

Check out a wordcloud of your favorite genres.

![Rplot](https://user-images.githubusercontent.com/101683174/234728809-757e552c-059b-43f2-b4a5-6154d7e10736.png)

Find out which keys you love and which ones you don't.

![keysModes](https://user-images.githubusercontent.com/101683174/233725834-250c27e5-c1e0-4bd0-8f90-f1527c2a4b1c.png)

Check out a map of your favorite tracks in terms of valence (positivity) and energy.

![vibeMap](https://user-images.githubusercontent.com/101683174/233723413-16fb2c70-133e-4dc5-85a1-06684e76e7b9.png)

See when you found your favorite song or artist. At the top of the chart you can see songs and albums you saved immediately on release day and at the bottom you can see when you discovered your favorite old tracks.

![discovery](https://user-images.githubusercontent.com/101683174/233723779-fc57d99d-0303-4062-bb8f-14995428fa04.png)

Watch yourself fall in love with pop music after years of listening to almost exclusvely indie/alt.

![popularity](https://user-images.githubusercontent.com/101683174/233724406-2f4cd9ef-7983-4f49-904e-b4ccbde4c417.gif)

Dance.

![danceability](https://user-images.githubusercontent.com/101683174/233725203-5743472c-cd99-42db-b889-75fe50cfe1e5.gif)
