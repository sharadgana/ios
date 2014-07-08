RottenTomatoes iOS client Demo
==============================

------------------------------
This is an iOS demo application for displaying the latest box office movies using the [RottenTomatoes API](http://developer.rottentomatoes.com/).

## Time Spent ##
Approximately 15-20 hours

## 3rd Party Libraries ##

Used [cocoapods](http://cocoapods.org/) to manage the following 3rd party libraries.

$ cat Podfile
platform :ios, '7.0'

target "rottentomatoes" do
pod "AFNetworking", "~> 2.0"
pod 'ALAlertBanner', '~>0.3.1'
pod 'MBProgressHUD', '~> 0.8'
end

target "rottentomatoesTests" do

end



##Completed User Stories##

 - **Required** User can view a list of movies from Rotten Tomatoes.  Poster images must be loading asynchronously.(**UIImageView+AFNetworking.h**)
 - **Required** User can view movie details by tapping on a cell
 - **Required** User sees loading state while waiting for movies API - (**MBProgressHUD.h**)
 - **Required** User sees error message when there's a networking error - (**ALAlertBanner.h**)
 - **Required** User can pull to refresh the movie list.
 - **Optional** Add a tab bar for Box Office and DVD

## Walkthrough ##
----------
![Video Walkthrough](rottentomatoes.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
 
> Written with [StackEdit](https://stackedit.io/).

