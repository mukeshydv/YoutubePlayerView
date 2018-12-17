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
            tag.onerror = 'window.location.href='ytplayer://onYouTubeIframeAPIFailedToLoad'';
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
            var player;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('existing-iframe-example', {
                    events: {
                        'onReady': onReady,
                        'onStateChange': onStateChange,
                        'onPlaybackQualityChange': onPlaybackQualityChange,
                        'onError': onPlayerError
                    }
                });
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

enum Constants {
    enum StateCode {
        static let unstarted = "-1"
        static let ended = "0"
        static let playing = "1"
        static let paused = "2"
        static let buffering = "3"
        static let cued = "5"
        static let unknown = "unknown"
    }
    
    enum PlaybackQuality {
        static let small = "small"
        static let medium = "medium"
        static let large = "large"
        static let hd720 = "hd720"
        static let hd1080 = "hd1080"
        static let highRes = "highres"
        static let auto = "auto"
        static let `default` = "default"
        static let unknown = "unknown"
    }
    
    enum ErrorCode {
        static let invalidparamerrorcode = "2"
        static let Html5errorcode = "5"
        static let videonotfounderrorcode = "100"
        static let notembeddableerrorcode = "101"
        static let cannotfindvideoerrorcode = "105"
        static let sameasnotembeddableerrorcode = "150"
    }
    
    enum Callback: String {
        case onReady = "onReady"
        case onStateChange = "onStateChange"
        case onPlaybackQualityChange = "onPlaybackQualityChange"
        case onError = "onError"
        case onPlayTime = "onPlayTime"
        
        case onYouTubeIframeAPIFailedToLoad = "onYouTubeIframeAPIFailedToLoad"
    }
    
    enum RegexPattern {
        static let embedUrl = "^http(s)://(www.)youtube.com/embed/(.*)$"
        static let adUrl = "^http(s)://pubads.g.doubleclick.net/pagead/conversion/"
        static let oAuth = "^http(s)://accounts.google.com/o/oauth2/(.*)$"
        static let staticProxy = "^https://content.googleapis.com/static/proxy.html(.*)$"
        static let syndication = "^https://tpc.googlesyndication.com/sodar/(.*).html$"
    }
}
