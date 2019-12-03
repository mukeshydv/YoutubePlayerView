# YoutubePlayerView

[![CI Status](https://img.shields.io/travis/mukeshydv/YoutubePlayerView.svg?style=flat)](https://travis-ci.org/mukeshydv/YoutubePlayerView)
![](https://github.com/mukeshydv/YoutubePlayerView/workflows/Swift/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/YoutubePlayerView.svg?style=flat)](https://cocoapods.org/pods/YoutubePlayerView)
[![License](https://img.shields.io/cocoapods/l/YoutubePlayerView.svg?style=flat)](https://cocoapods.org/pods/YoutubePlayerView)
[![Platform](https://img.shields.io/cocoapods/p/YoutubePlayerView.svg?style=flat)](https://cocoapods.org/pods/YoutubePlayerView)

The `YoutubePlayerView` is an open source library that helps you embed a YouTube iframe player into an iOS application. The library creates a `WKWebView` and a bridge between your application’s Swift code and the YouTube player’s JavaScript code, thereby allowing the iOS application to control the YouTube player.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation
### Install the library via CocoaPods

YoutubePlayerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YoutubePlayerView'
```
At the command line prompt, type `pod install` to update your workspace with the dependencies.

Tip: Remember that when using CocoaPods, you must open the `.xcworkspace` file in Xcode, not the `.xcodeproj` file.

### Manually install the library

The library is also easy to install manually. Either download the source via [GitHub’s download link](https://github.com/mukeshydv/YoutubePlayerView) or clone the repository. Once you have a local copy of the code, follow these steps:

1. Open the sample project in Xcode or Finder.

2. Select `YoutubePlayerView.swift` and `YoutubePlayerExtras.swift`. If you are opening the workspace in Xcode, these will be available under `Pods -> Development Pods -> YoutubePlayerView`. In the Finder, these are available in the project's root directory in the `Classes` directories.

3. Drag these files and folders into your project. Make sure the `Copy items into destination group’s folder` option is checked.

## Usage

### Getting started to load video
To start playing youtube videos follow these steps:
1. In interface builder drag a `UIView` to your scene.
2. Select the Identity Inspector and change the class of the view to `YoutubePlayerView`.
3. In interface builder create an `IBOutlet` of this view to yout view controller and name it `playerView`.
4. Now in your view controller's `viewDidLoad` method add following code:
```swift
playerView.loadWithVideoId("GC5V67k0TAA")
```
Build and Run, after video loads tap on it to play the video.

### Control video playback
You can also use `loadWithVideoId(_ : with:)` method to pass addition parameter to the view. For more information about the parameters visit [Player Parameter](https://developers.google.com/youtube/player_parameters)

To play with additional parameter you can replace you code with this:
```swift
let playerVars: [String: Any] = [
    "controls": 1,
    "modestbranding": 1,
    "playsinline": 1,
    "rel": 0,
    "showinfo": 0,
    "autoplay": 1
]
playerView.loadWithVideoId("GC5V67k0TAA", with: playerVars)
```
There are also methods to control the playback:
```swift
func play()
func pause()
func stop()
func seek(to: allowSeekAhead:)
```
### Handle player callbacks
The library provides a protocol `YoutubePlayerViewDelegate` to handle callbacks.
Your class can conform to this protocol and set the `delegate` of the `playerView` to the class.
```swift
extension ViewController: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.play()
    }

    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }

    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }

    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }

    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
}
```

Now set the delegate of player view:
```swift
playerView.delegate = self
```

## Author

Mukesh Yadav, mails4ymukesh@gmail.com

## License

YoutubePlayerView is available under the MIT license. See the LICENSE file for more info.
