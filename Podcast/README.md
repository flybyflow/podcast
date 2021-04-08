# Podcast Player

This Podcast Player lets you search the Itunes store podcast library and play the episode of your chosing.
You can also download podcasts to the device and play them without needed a network connection.

# Pods

This project uses the following pods : 
 - Alamofire for networking calls and to download media files
 - FeedKit to parse the RSS Feed
 - SDWebImage for Image Caching
 
 ## Implementation & Frameworks

 SearchBarController : Searches using the Itunes Api for its podcast library and displays the fetched podcasts, pushes to EpisodesController

 EpisodesController: Displays a podcast's episodes list, allows the user to download episodes and to play them using the AudioPlayer 

 AudioPlayerView: plays the episode using AVKit
 The user can play, pause, forward, rewind and move to a specific time in the audio. 
 the user can also adjust the volume. Dismisses back to the EpisodesController or DownloadsController

 DownloadsController: Displays the users downloaded episodes that are saved locally to the device. Running the AudioPlayer from here allows the user to play an episode without a Network connection

 Frameworks : 
 CoreData - implemented in DatabaseHandler
 AVKit - implemented in AudioPlayerView

## Search for Podcast Episode

The user can swipe up to bring the search bar and search the itunes store podcast library.
Selecting a podcast brings up its episode list.
Selecting an episode will launch the audio Player .
The user can also download a Podcast by swiping right on an episode.

## Audio Player

On launch, the podcast episode automatically starts playing.

Here's the available controls for the audio player :

 - Resume/Pause audio playback by tapping play/pause button
 - Foward audio playback by 15 seconds by tapping the forward button
 - Rewind audio playback by 15 seconds by tapping the rewind button
 - Play at a specific time by dragging the top slider to the desired time
 - Adjust Volume by dragging the bottom slider to the desired volume

the audio player can be dismissed using the dismiss button at the top.

## Downloads

The user can access the downloaded podcast episode by selecting "Downloads" in the bottom tab. 
This action will display all the fully downloaded podcast episodes.

selecting an episode will display the audio player and will play the media file stored on the device - this part doesnt require a network connection.

This section is persistent and so are media files associated with the downloaded Podcasts


## How to build
 - Extract folder from file 
 - Run Podcast.xcworkspace

## Requirements
Xcode 14.2
Swift 5

## License
MIT License

Copyright (c) [2021] [Mo Sersouri]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Current Bugs

Unable to Download Episodes from EpisodesController if the NetworkConnection goes Down - even if its restored after.. 
this has something to do with Network Reachability and its Im not yet familiar with this topic

Doesnt Display any alerts in the AudioPlayerView if the network connection is down - the Api Call is handled by the AVPlayer and Ill need a longer look at the documentation

## Upcoming Features

 - Deleting Downloaded Podcasts with swipe gesture
 - Favorites Tab where the user can access a persistent list of his favorite podcasts 
 - Minized audio player 
 - audio player background & locked screen functionality 
 - download progress tracking
