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
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView)
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState)
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality)
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error)
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float)
    func playerViewPreferredBackgroundColor(_ playerView: YoutubePlayerView) -> UIColor
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView?
}

extension YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) { }
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) { }
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) { }
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) { }
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) { }
    func playerViewPreferredBackgroundColor(_ playerView: YoutubePlayerView) -> UIColor { return .white }
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? { return nil }
}

open class YoutubePlayerView: UIView {
    private var webView: WKWebView!
    fileprivate var loadingView: UIView?
    
    weak var delegate: YoutubePlayerViewDelegate?
    
    private var configuration: WKWebViewConfiguration {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        } else {
            webConfiguration.requiresUserActionForMediaPlayback = false
        }
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
        webView.navigationDelegate = self
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createVideoUrlString(_ videoId: String, from args: [String: Any]?) -> String {
        let params = args?.reduce("") { $0 + "\($1.key)=\($1.value)&" } ?? ""
        
        return "https://www.youtube.com/embed/"+videoId+"?\(params)enablejsapi=1"
    }
    
    private func createPlaylistUrlString(_ playlistId: String, from args: [String: Any]?) -> String {
        let params = args?.reduce("") { $0 + "\($1.key)=\($1.value)&" } ?? ""
        
        return "https://www.youtube.com/embed?listType=playlist&list=\(playlistId)&\(params)enablejsapi=1"
    }
    
    private func loadPlayer(with url: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            let htmlString = String(format: YoutubePlayerUtils.htmlString, url)
            self.webView.loadHTMLString(htmlString, baseURL: nil)
        })
    }
    
    public func loadWithVideoId(_ videoId: String, with parArgs: [String: Any]? = nil) {
        let link = createVideoUrlString(videoId, from: parArgs)
        loadPlayer(with: link)
    }
    
    public func loadWithPlaylistId(_ playlistId: String, with parArgs: [String: Any]? = nil) {
        let link = createPlaylistUrlString(playlistId, from: parArgs)
        loadPlayer(with: link)
    }
}

extension YoutubePlayerView {
    public func play() {
        webView.evaluateJavaScript("player.playVideo();", completionHandler: nil)
    }
    
    public func pause() {
        notifyDelegate(for: URL(string: "ytplayer://onStateChange?data=\(YoutubePlayerState.paused.rawValue)")!)
        webView.evaluateJavaScript("player.pauseVideo();", completionHandler: nil)
    }
    
    public func stop() {
        webView.evaluateJavaScript("player.stopVideo();", completionHandler: nil)
    }
    
    public func seek(to seconds: Float, allowSeekAhead: Bool) {
        let command = "player.seekTo(\(seconds), \(allowSeekAhead));"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

// MARK:- Cueing methods
extension YoutubePlayerView {
    public func loadVideoById(_ videoId: String, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.loadVideoById('\(videoId)', \(startSeconds), '\(quality.rawValue)');"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func loadVideoById(_ videoId: String, startSeconds: Float, endSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.loadVideoById({'videoId': '\(videoId)', 'startSeconds': \(startSeconds), 'endSeconds': \(endSeconds), 'suggestedQuality': '\(quality.rawValue)'});"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func cueVideoById(_ videoId: String, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.cueVideoById('\(videoId)', \(startSeconds), '\(quality.rawValue)');"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func cueVideoById(_ videoId: String, startSeconds: Float, endSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.cueVideoById({'videoId': '\(videoId)', 'startSeconds': \(startSeconds), 'endSeconds': \(endSeconds), 'suggestedQuality': '\(quality.rawValue)'});"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func loadVideoByUrl(_ videoUrl: String, startSeconds: Float, endSeconds: Float? = nil, suggestedQuality quality: YoutubePlaybackQuality) {
        let command: String
        if let endSeconds = endSeconds {
            command = "player.loadVideoByUrl('\(videoUrl)', \(startSeconds), \(endSeconds), '\(quality.rawValue)');"
        } else {
            command = "player.loadVideoByUrl('\(videoUrl)', \(startSeconds), '\(quality.rawValue)');"
        }
        
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func cueVideoByUrl(_ videoUrl: String, startSeconds: Float, endSeconds: Float? = nil, suggestedQuality quality: YoutubePlaybackQuality) {
        let command: String
        if let endSeconds = endSeconds {
            command = "player.cueVideoByUrl('\(videoUrl)', \(startSeconds), \(endSeconds), '\(quality.rawValue)');"
        } else {
            command = "player.cueVideoByUrl('\(videoUrl)', \(startSeconds), '\(quality.rawValue)');"
        }
        
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

// MARK:- Cueing methods for lists
extension YoutubePlayerView {
    public func cuePlaylistByPlaylistId(_ playlistId: String, index: Int=0, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        cuePlaylist("'\(playlistId)'", index: index, startSeconds: startSeconds, suggestedQuality: quality)
    }
    
    public func cuePlaylistByVideos(_ videoIds: [String], index: Int=0, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        cuePlaylist("'\(videoIds.description)'", index: index, startSeconds: startSeconds, suggestedQuality: quality)
    }
    
    private func cuePlaylist(_ playlistIdString: String, index: Int, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.cuePlaylist(\(playlistIdString), \(index), \(startSeconds), '\(quality.rawValue)');"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func loadPlaylistPlaylistId(_ playlistId: String, index: Int=0, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        loadPlaylist("'\(playlistId)'", index: index, startSeconds: startSeconds, suggestedQuality: quality)
    }
    
    public func loadPlaylistByVideos(_ videoIds: [String], index: Int=0, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        loadPlaylist("'\(videoIds.description)'", index: index, startSeconds: startSeconds, suggestedQuality: quality)
    }
    
    private func loadPlaylist(_ playlistIdString: String, index: Int, startSeconds: Float, suggestedQuality quality: YoutubePlaybackQuality) {
        let command = "player.loadPlaylist(\(playlistIdString), \(index), \(startSeconds), '\(quality.rawValue)');"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

// MARK:- Setting the playback rate
extension YoutubePlayerView {
    public func fetchPlaybackRate(_ handler: @escaping (Float?)->()) {
        webView.evaluateJavaScript("player.getPlaybackRate();") { (data, _) in
            handler(data as? Float)
        }
    }
    
    public func setPlaybackRate(_ rate: Float) {
        webView.evaluateJavaScript("player.setPlaybackRate(\(rate));", completionHandler: nil)
    }
    
    public func fetchAvailablePlaybackRates(_ handler: @escaping ([Float]?)->()) {
        webView.evaluateJavaScript("player.getPlaybackRate();") { (data, _) in
            if let stringValue = (data as? String)?.data(using: .utf8) {
                if let rates = try? JSONSerialization.jsonObject(with: stringValue, options: []) as? [Float] {
                    handler(rates)
                    return
                }
            }
            handler(nil)
        }
    }
}

// MARK:- Setting playback behavior for playlists
extension YoutubePlayerView {
    public func setLoop(_ isLoop: Bool) {
        let command = "player.setLoop(\(isLoop));"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
    
    public func setShuffle(_ isShuffle: Bool) {
        let command = "player.setShuffle(\(isShuffle));"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

// MARK:- Playback status
extension YoutubePlayerView {
    public func fetchVideoLoadedFraction(_ completionHandler: @escaping (Float?) -> ()) {
        webView.evaluateJavaScript("player.getVideoLoadedFraction();") { (data, _) in
            completionHandler(data as? Float)
        }
    }
    
    public func fetchPlayerState(_ completionHandler: @escaping (YoutubePlayerState) -> ()) {
        webView.evaluateJavaScript("player.getPlayerState();") { (data, _) in
            if let stringValue = data as? String, let state = YoutubePlayerState(rawValue: stringValue) {
                completionHandler(state)
            } else {
                completionHandler(.unknown)
            }
        }
    }
    
    public func fetchCurrentTime(_ completionHandler: @escaping (Float?) -> ()) {
        webView.evaluateJavaScript("player.getCurrentTime();") { (data, _) in
            completionHandler(data as? Float)
        }
    }
}

// MARK:- Playback quality
extension YoutubePlayerView {
    public func fetchPlaybackQuality(_ completionHandler: @escaping (YoutubePlaybackQuality) -> ()) {
        webView.evaluateJavaScript("player.getPlaybackQuality();") { (data, _) in
            if let stringValue = data as? String, let state = YoutubePlaybackQuality(rawValue: stringValue) {
                completionHandler(state)
            } else {
                completionHandler(.unknown)
            }
        }
    }
    
    public func setPlaybackQuality(_ quality: YoutubePlaybackQuality) {
        let command = "player.setPlaybackQuality('\(quality.rawValue)');"
        webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

// MARK:- Video information methods
extension YoutubePlayerView {
    public func fetchDuration(_ completionHandler: @escaping (TimeInterval?) -> ()) {
        webView.evaluateJavaScript("player.getDuration();") { (data, _) in
            completionHandler(data as? Double)
        }
    }
    
    public func fetchVideoUrl(_ completionHandler: @escaping (String?) -> ()) {
        webView.evaluateJavaScript("player.getVideoUrl();") { (data, _) in
            completionHandler(data as? String)
        }
    }
    
    public func fetchVideoEmbedCode(_ completionHandler: @escaping (String?) -> ()) {
        webView.evaluateJavaScript("player.getVideoEmbedCode();") { (data, _) in
            completionHandler(data as? String)
        }
    }
}

// MARK:- Playlist methods
extension YoutubePlayerView {
    public func fetchPlaylist(_ handler: @escaping ([String]?)->()) {
        webView.evaluateJavaScript("player.getPlaylist();") { (data, _) in
            if let stringValue = (data as? String)?.data(using: .utf8) {
                if let rates = try? JSONSerialization.jsonObject(with: stringValue, options: []) as? [String] {
                    handler(rates)
                    return
                }
            }
            handler(nil)
        }
    }
    
    public func fetchPlaylistIndex(_ completionHandler: @escaping (Int?) -> ()) {
        webView.evaluateJavaScript("player.getPlaylistIndex();") { (data, _) in
            completionHandler(data as? Int)
        }
    }
}

// MARK:- Playing a video in a playlist
extension YoutubePlayerView {
    public func nextVideo() {
        webView.evaluateJavaScript("player.nextVideo();", completionHandler: nil)
    }
    
    public func previousVideo() {
        webView.evaluateJavaScript("player.previousVideo();", completionHandler: nil)
    }
    
    public func playVideo(at index: Int) {
        webView.evaluateJavaScript("player.playVideoAt(\(index));", completionHandler: nil)
    }
}

extension YoutubePlayerView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.scheme == "ytplayer" {
            notifyDelegate(for: navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
           decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView?.removeFromSuperview()
    }
}

extension YoutubePlayerView {
    fileprivate func notifyDelegate(for url: URL) {
        guard let actionString = url.host, let action = Callback(rawValue: actionString)  else {
            return
        }
        
        let data = url.query?.components(separatedBy: "=").last
        
        switch action {
        case .onReady:
            loadingView?.removeFromSuperview()
            delegate?.playerViewDidBecomeReady(self)
        case .onStateChange:
            if let data = data, let state = YoutubePlayerState(rawValue: data) {
                delegate?.playerView(self, didChangedToState: state)
            }
        case .onPlaybackQualityChange:
            if let data = data, let quality = YoutubePlaybackQuality(rawValue: data) {
                delegate?.playerView(self, didChangeToQuality: quality)
            }
        case .onError:
            if let data = data, let error = YoutubePlayerError(rawValue: data) {
                delegate?.playerView(self, receivedError: error)
            } else {
                delegate?.playerView(self, receivedError: YoutubePlayerError.unknown)
            }
        case .onPlayTime:
            if let data = data, let time = Float(data) {
                delegate?.playerView(self, didPlayTime: time)
            }
        case .onYouTubeIframeAPIFailedToLoad:
            loadingView?.removeFromSuperview()
        }
    }
}
