//
//  YoutubePlayerView.swift
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

import UIKit
import WebKit

public protocol YoutubePlayerViewDelegate: class {
    
}

open class YoutubePlayerView: UIView {
    private var webView: WKWebView!
    
    weak var delegate: YoutubePlayerViewDelegate?
    
    private var configuration: WKWebViewConfiguration {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        return webConfiguration
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder: NSCoder) {
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
    
    private func createUrlString(_ videoId: String, from args: [String: Any]?) -> String {
        let params = args?.reduce("") { $0 + "\($1.key)=\($1.value)&" } ?? ""
        
        return "https://www.youtube.com/embed/"+videoId+"?\(params)enablejsapi=1"
    }
    
    public func load(_ videoId: String, with parArgs: [String: Any]? = nil) {
        
        let link = createUrlString(videoId, from: parArgs)
        
        DispatchQueue.main.async(execute: { () -> Void in
            let htmlString = String(format: YoutubePlayerUtils.htmlString, link)
            self.webView.loadHTMLString(htmlString, baseURL: nil)
        })
    }
    
    public func play() {
        webView.evaluateJavaScript("player.playVideo();", completionHandler: nil)
    }
}
