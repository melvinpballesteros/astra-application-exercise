//
//  MovieDetailViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    // MARK: - Variables
    var movieViewModel: MovieViewModel?
    let viewModel = MovieDetailViewModel()
    
    // MARK: - Controls
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
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
    
    lazy var longDescLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
        
        /// Check movie if user saved it as favorite
        checkFavorites()
        /// Fetch artwork
        fetchImage(artworkUrl: movieViewModel?.textArtwork ?? "")
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
            posterImageView,
            titleLabel,
            priceLabel,
            genreLabel,
            longDescLabel
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
        
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width - 56)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(25)
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
        
        longDescLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.width.equalTo(screenSize.width - 56)
            make.top.equalTo(priceLabel.snp.bottom).offset(35)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    private func setupContext() {
        guard let viewModel = movieViewModel else { return }
        
        titleLabel.text = viewModel.textTitle
        priceLabel.text = viewModel.textPrice
        genreLabel.text = viewModel.textGenre

        longDescLabel.attributedText = NSAttributedString().setAttributedText(fullText: viewModel.textLongDesc, 
                                                                              boldText: "Description:")
    }
    
    
    // MARK: - Events
    @objc private func userTapBackButton() {
        navigateBack()
    }
    
    @objc private func userTapFavorite() {
        movieViewModel?.detailPageTapFavorite(withFavoriteButton: favoriteButton)
    }

    
    // MARK: - Navigation
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Logic
    
    private func checkFavorites() {
        movieViewModel?.getFavoriteStatus(withFavoriteButton: favoriteButton)
    }
    
    func fetchImage(artworkUrl: String) {
        /// Get higher resolution by changing the 100x100 of your choice
        let formattedArtworkUrl = artworkUrl.formatImageUrl(format: "800x800")
        print(formattedArtworkUrl)
        let url = URL(string: formattedArtworkUrl)
        let processor = DownsamplingImageProcessor(size: CGSize(width: screenSize.width - 56, height: 400))
        posterImageView.kf.indicatorType = .activity
        
        
        KF.url(url)
        .setProcessor(processor)
        .placeholder(UIImage(named: "placeholder"))
        .scaleFactor(UIScreen.main.scale)
        .transition(.fade(0.3))
        .cacheOriginalImage()
        .set(to: posterImageView)
    }
}
