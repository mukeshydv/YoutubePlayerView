//
//  YoutubePlayerUtils.swift
//  YoutubePlayerView
//
//  Created by Mukesh on 17/12/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

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
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
        var player;
        function onYouTubeIframeAPIReady() {
        player = new YT.Player('existing-iframe-example', {
        events: {
        }
        });
        }
        </script>
        """
    }
}
