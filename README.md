# szeretet_foldje

This relatively simple app is written in Dart using the Flutter SDK.
The goal of the app is to represent the content of one segment of my faters website (szeretetföldje.hu) in a native application.

## Challanges:

The main challange was the data-source. Given the website is Joomla, i had no API accessing the data i wanted to display in the app. I had to write a web-scraper to extract the needed information.

The second challange arrised after i got the web scraped. I needed to convert the information to native Objects, wich proved to be a bit more time-consuming than i initially expected. I had to extract the date from a String, wich varies greatly depending on the month (december is longer than june), or even the day (joomla gives out the information without 0-s in front of the single-digit days).

The app can be downloaded from Google Play:
https://play.google.com/store/apps/details?id=hu.szeretetfoldje.szeretet_foldje
