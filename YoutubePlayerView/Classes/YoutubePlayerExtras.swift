//
//  YoutubePlayerUtils.swift
//  YoutubePlayerView
//
//  Copyright (c) 2018 Mukesh Yadav <mails4ymukesh@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation

enum YoutubePlayerUtils {
    static var htmlString: String {
        return "<head>\(script)<meta name=viewport content='width=device-width, initial-scale=1'><style type='text/css'> body { margin: 0;} </style></head><iframe id='existing-iframe-example' width='100%%' height='100%%' src='%@' frameborder='0' allowfullscreen></iframe>"
    }
    
    private static var script: String {
        return """
        <script type="text/javascript">
            var tag = document.createElement('script');
            tag.id = 'iframe-demo';
            tag.src = 'https://www.youtube.com/iframe_api';
            tag.onerror = "window.location.href='ytplayer://onYouTubeIframeAPIFailedToLoad'";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
            var player;
            var error = false;
        
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('existing-iframe-example', {
                    events: {
                        'onReady': onReady,
                        'onStateChange': onStateChange,
                        'onPlaybackQualityChange': onPlaybackQualityChange,
                        'onError': onPlayerError
                    }
                });
        
                // this will transmit playTime frequently while playng
                function getCurrentTime() {
                    var state = player.getPlayerState();
                    if (state == YT.PlayerState.PLAYING) {
                        time = player.getCurrentTime()
                        window.location.href = 'ytplayer://onPlayTime?data=' + time;
                    }
                }
        
                window.setInterval(getCurrentTime, 500);
            }
        
            function onReady(event) {
                window.location.href = 'ytplayer://onReady?data=' + event.data;
            }
        
            function onStateChange(event) {
                if (!error) {
                    window.location.href = 'ytplayer://onStateChange?data=' + event.data;
                }
                else {
                    error = false;
                }
            }
        
            function onPlaybackQualityChange(event) {
                window.location.href = 'ytplayer://onPlaybackQualityChange?data=' + event.data;
            }
        
            function onPlayerError(event) {
                if (event.data == 100) {
                    error = true;
                }
                window.location.href = 'ytplayer://onError?data=' + event.data;
            }
        
            window.onresize = function() {
                player.setSize(window.innerWidth, window.innerHeight);
            }
        </script>
        """
    }
}


public enum YoutubePlayerState: String {
    case unstarted = "-1"
    case ended = "0"
    case playing = "1"
    case paused = "2"
    case buffering = "3"
    case queued = "5"
    case unknown
}

public enum YoutubePlaybackQuality: String {
    case small
    case medium
    case large
    case hd720
    case hd1080
    case highres
    case auto /** Addition for YouTube Live Events. */
    case `default`
    case unknown /** This should never be returned. It is here for future proofing. */
}

public enum YoutubePlayerError: String, Error {
    case invalidParam = "2"
    case HTML5Error = "5"
    case videoNotFound = "100" // Functionally equivalent error codes 100 and
    // 105 have been collapsed into |kYTPlayerErrorVideoNotFound|.
    case notEmbeddable = "101" // Functionally equivalent error codes 101 and
    // 150 have been collapsed into |kYTPlayerErrorNotEmbeddable|.
    case unknown
}

enum Callback: String {
    case onReady = "onReady"
    case onStateChange = "onStateChange"
    case onPlaybackQualityChange = "onPlaybackQualityChange"
    case onError = "onError"
    case onPlayTime = "onPlayTime"
    
    case onYouTubeIframeAPIFailedToLoad = "onYouTubeIframeAPIFailedToLoad"
}
