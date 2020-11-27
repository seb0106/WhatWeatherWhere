# WhatWeatherWhere

Here is a brief introduction of the WhatWeatherWhere app.

You can find the weather of a place on the map and save it on the app. Like that you can always look where on the world what weather is, only one click and there
you have it. There are maybe some complication with the API response, sometimes the temperature isn't right but there can't I do much. 

## Implementation

In the mapController you have a map and a tab bar. On the map you can add annotation by holding on to the screen for 2 seconds,
which triggers a request to the CurrentWheather API. Then you will be send to the DetailView of the wheather in that location. You can easily move back by the back 
navigation button or by clicking on the tab bar. Theres also a TableView, there you can see every annotations/ currentwheater. Its sorted by date. In the cells you can
see the location and the date with time. If you click onto the cell you get redirected to the detailview. If you want to delete an annotation you just select it
on the map view and can press the delete button on the top. If you want to delete it from the tableview, you can just swipe left and delete it there. 

## Requirements

 - Xcode 12
 - Swift 5.0
 - Internet connection
 
 ## How to build
 You need to have a development account if you want to build it on a physical device, else you can build it on xcode. 
 
 I hope the app is usefull and you like it. 
 Kind regards your mobile developer Sebastian.
