# MapLocations

Purpose:

This sample project is to create an app that gets location coordinates from the DataBase through a middle layer server and plots the same in iOS Apple Maps. 
The App updates the latitude and longitude values with a random number (1-10), and pulls the latest data back into the App.
The Map is plotted and updated with different colosr based on the random number assigned to each location.


 Technical Requirements:
 
 1. Xcode
 2. MySql DB
 3. phpMyAdmin
 4. A server(local) to connect and update MYSQL db
 
 Design Pattern:
 
 1. MVVM
 
 Language:
 
 1. Swift
 2. PHP
 
 Server:
 
 There are couple of php files, which needs to be in the server. If you are using mac you can copy these under "/Library/WebServer/Documents/"
 1. predinaUpdate/index.php
 2. predinaService/index.php
 
 Make sure you have mySQL installed and server is running. To run the server go to System Preferences/MySQL and tap on "Start MySQL Server"
 
 
 iOS App:
 It is a Single View Application which display the Apple Map using MapView. The App calls the predinaService on start to get the complete list of locations and plots the same in the Map.
 After the initial load App updates the data in periodic and gets the latest data continuously.
 
 
 Test Project:
 
 The test files are auto generated. However since the design pattern is MVVM you can create unit and automated test cases using XCTest and XCUITest respectively
 
 
 Possible Improvements:
 
 1. Use socket streaming instead of http to continuosuly update the map
 2. Use file to store the locations, this is important to prevent high memory consumption
 3. Update the logic in the server to intelligently send only the required set of locations based on User current location
 
 



