//
//  PlayerView.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit
import AVKit

class PlayerView: UIView {
    
    static var videoIsMuted: Bool = true
    
    var isAutoStop: Bool = false
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var assetPlayer:AVPlayer? {
        didSet {
            DispatchQueue.main.async {
                if let layer = self.layer as? AVPlayerLayer {
                    layer.player = self.assetPlayer
                }
            }
        }
    }
    
    private var playerItem:AVPlayerItem?
    private var urlAsset: AVURLAsset?
    
    var isMuted: Bool = true {
        didSet {
            self.assetPlayer?.isMuted = isMuted
        }
    }
    
    var url: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        initialSetup()
    }
    
    private func initialSetup() {
        if let layer = self.layer as? AVPlayerLayer {
            //layer.videoGravity = AVLayerVideoGravity.resizeAspect
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
        
        setupActivityIndicatorView()
        setupConstraints()
        //activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width - 50) / 2, y: (self.frame.size.height - 50) / 2, width: 50, height: 50))
    }
    
    func setupActivityIndicatorView() {
        self.setSubviewForAutoLayout(
            activityIndicatorView
        )
    }
    
    func setupConstraints() {
        activityIndicatorView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func setAspectRatio() {
        if let layer = self.layer as? AVPlayerLayer {
            //
            if self.isAutoStop {
                layer.videoGravity = AVLayerVideoGravity.resizeAspect
            } else {
                layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            }
        }
    }
    
    func hideShowActivityIndicatorView(isShow: Bool) {
        UIView.animate(withDuration: 0.5) { 
            DispatchQueue.main.async {
                self.activityIndicatorView.alpha = isShow ? 1 : 0
            }
        }
    }
    
    func prepareToPlay(withUrl url:URL, shouldPlayImmediately: Bool = false) {
        activityIndicatorView.removeFromSuperview()
        self.addSubview(activityIndicatorView)
        
        setupConstraints()
        activityIndicatorView.startAnimating()
        
        guard !(self.url == url && assetPlayer != nil && assetPlayer?.error == nil) else {
            if shouldPlayImmediately {
                play()
            }
            return
        }
        
        cleanUp()
        
        self.url = url
        
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey : true]
        let urlAsset = AVURLAsset(url: url, options: options)
        self.urlAsset = urlAsset
        
        let keys = ["tracks"]
        urlAsset.loadValuesAsynchronously(forKeys: keys, completionHandler: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.startLoading(urlAsset, shouldPlayImmediately)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func startLoading(_ asset: AVURLAsset, _ shouldPlayImmediately: Bool) {
        var error:NSError?
        let status:AVKeyValueStatus = asset.statusOfValue(forKey: "tracks", error: &error)
        if status == AVKeyValueStatus.loaded {
            let item = AVPlayerItem(asset: asset)
            self.hideShowActivityIndicatorView(isShow: false)
            self.playerItem = item
            self.assetPlayer = AVPlayer(playerItem: item)
            self.didFinishLoading(self.assetPlayer, shouldPlayImmediately)
        }
    }
    
    //    private func stopPlayingIndicator() {
    //        DispatchQueue.main.async {
    //            self.activityIndicatorView.stopAnimating()
    //            self.activityIndicatorView.removeFromSuperview()
    //        }
    //    }
    
    private func didFinishLoading(_ player: AVPlayer?, _ shouldPlayImmediately: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.hideShowActivityIndicatorView(isShow: false)
        }
        
        guard let player = player, shouldPlayImmediately else { return }
        DispatchQueue.main.async {
            player.play()
        }
    }
    
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        guard notification.object as? AVPlayerItem == self.playerItem else { return }
        DispatchQueue.main.async {
            guard let videoPlayer = self.assetPlayer else { return }
            videoPlayer.seek(to: .zero)
            if self.isAutoStop {
                videoPlayer.pause()
                // self.delegate?.didFinishedVideo()
            } else {
                videoPlayer.play()
            }
        }
    }
    
    func play() {
         guard self.assetPlayer?.isPlaying == false else { return }
        DispatchQueue.main.async {
            self.assetPlayer?.play()
        }
    }
    
    func pause() {
        guard self.assetPlayer?.isPlaying == true else { return }
        DispatchQueue.main.async {
            self.assetPlayer?.pause()
        }
    }
    
    func cleanUp() {
        pause()
        urlAsset?.cancelLoading()
        urlAsset = nil
        assetPlayer = nil
        removeObservers()
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

extension AVPlayer {
    var isPlaying:Bool {
        get {
            return (self.rate != 0 && self.error == nil)
        }
    }
}
