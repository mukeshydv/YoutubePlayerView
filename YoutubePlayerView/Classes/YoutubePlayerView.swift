//
//  YoutubePlayerView.swift
//  YoutubePlayerView
//
//  Created by Mukesh on 17/12/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

import UIKit
import WebKit

public class YoutubePlayerView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        scrollView.isScrollEnabled = false
    }
    
    public func load(_ videoId: String, with parArgs: [String: Any]) {
        
        let link = createUrlString(videoId, from: parArgs)
        
        DispatchQueue.main.async(execute: { () -> Void in
            let htmlString = String(format: YoutubePlayerUtils.htmlString, link)
            self.loadHTMLString(htmlString, baseURL: nil)
        })
    }
    
    private func createUrlString(_ videoId: String, from args: [String: Any]) -> String {
        let params = args.reduce("") { $0 + "\($1.key)=\($1.value)&" }
        
        return "https://www.youtube.com/embed/"+videoId+"?\(params)enablejsapi=1"
    }
    
    public func play() {
        evaluateJavaScript("player.playVideo();", completionHandler: nil)
    }
}
