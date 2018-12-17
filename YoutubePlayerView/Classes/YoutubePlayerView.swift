//
//  YoutubePlayerView.swift
//  YoutubePlayerView
//
//  Created by Mukesh on 17/12/18.
//  Copyright © 2018 BooEat. All rights reserved.
//

import UIKit
import WebKit

public class YoutubePlayerView: UIView {
    private var webView: WKWebView!
    
    private var configuration: WKWebViewConfiguration {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        return webConfiguration
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func load(_ videoId: String, with parArgs: [String: Any]? = nil) {
        
        let link = createUrlString(videoId, from: parArgs)
        
        DispatchQueue.main.async(execute: { () -> Void in
            let htmlString = String(format: YoutubePlayerUtils.htmlString, link)
            self.webView.loadHTMLString(htmlString, baseURL: nil)
        })
    }
    
    private func createUrlString(_ videoId: String, from args: [String: Any]?) -> String {
        let params = args?.reduce("") { $0 + "\($1.key)=\($1.value)&" } ?? ""
        
        return "https://www.youtube.com/embed/"+videoId+"?\(params)enablejsapi=1"
    }
    
    public func play() {
        webView.evaluateJavaScript("player.playVideo();", completionHandler: nil)
    }
}
