//
//  MusicVideoDetailViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit

class MusicVideoDetailViewController: UIViewController {
    
    
    var viewModel: MusicVideoViewModel?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy var playerView: PlayerView = {
        let playerView = PlayerView()
        return playerView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-back-white"), for: .normal)
         button.addTarget(self, action: #selector(userTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart-white"), for: .normal)
        button.addTarget(self, action: #selector(userTapFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 5
        label.sizeToFit()
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColor.gray
        label.sizeToFit()
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.yellow
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.sizeToFit()
        return label
    }()
    

    // MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupViews()
        setupConstraints()
        setupContext()
        autoplayVideo()
        checkFavorites()
    }
    
    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = AppColor.black
    }
    
    private func setupViews() {
        view.setSubviewForAutoLayout(
            backButton,
            favoriteButton,
            scrollView
        )
        
        scrollView.setSubviewForAutoLayout(
            playerView,
            titleLabel,
            priceLabel,
            genreLabel
        )
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(backButton)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.bottom.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
        
        playerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(20)
            make.height.equalTo(400)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(25)
            make.left.equalTo(28)
            make.width.equalTo(screenSize.width - 56)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupContext() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.textTitle
        priceLabel.text = viewModel.textPrice
        genreLabel.text = viewModel.textGenre
    }
    
    private func autoplayVideo() {
        guard let videoUrlString = viewModel?.previewUrl else { return }
        let url = URL(string: videoUrlString)!
        playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: true)
    }
    
    // MARK: - Events
    @objc private func userTapBackButton() {
        navigateBack()
    }
    
    @objc private func userTapFavorite() {
        viewModel?.detailPageTapFavorite(withFavoriteButton: favoriteButton)
    }
    
    // MARK: - Navigation
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Logic
    
    private func checkFavorites() {
        viewModel?.getFavoriteStatus(withFavoriteButton: favoriteButton)
    }

}
