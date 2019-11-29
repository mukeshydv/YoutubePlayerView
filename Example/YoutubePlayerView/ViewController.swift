//
//  ViewController.swift
//  YoutubePlayerView
//
//  Created by mukeshydv on 12/17/2018.
//  Copyright (c) 2018 mukeshydv. All rights reserved.
//

import UIKit
import YoutubePlayerView

class ViewController: UIViewController {

    @IBOutlet weak var playerView: YoutubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        playerView.delegate = self
        playerView.loadWithVideoId("x-MBR13sVqs", with: playerVars)
    }
}

extension ViewController: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
        }
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
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
}

