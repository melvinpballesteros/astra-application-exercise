//
//  MovieTableViewCell.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieTableViewCell"
    
    // MARK: - Controls
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 3
        label.sizeToFit()
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.sizeToFit()
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.yellow
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.sizeToFit()
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart-white"), for: .normal)
        button.addTarget(self, action: #selector(userTapFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg-cell")
        return imageView
    }()
    
    lazy var contextView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAttributes()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func setupAttributes() {
        self.backgroundColor = AppColor.black
        self.selectionStyle = .none
    }
    
    private func setupViews() {
        contentView.setSubviewForAutoLayout(
            backgroundImageView,
            thumbnail,
            favoriteButton,
            contextView
        )
        
        contextView.setSubviewForAutoLayout(
            titleLabel,
            genreLabel,
            priceLabel
        )
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        thumbnail.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(16)
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalTo(backgroundImageView).offset(-10)
            make.top.equalToSuperview().offset(13)
        }
        
        contextView.snp.makeConstraints { make in
            make.left.equalTo(thumbnail.snp.right).offset(16)
            make.right.equalToSuperview().offset(-35)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(priceLabel).offset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(5)
            
        }
        
        genreLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(genreLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configure(_ viewModel: MovieViewModel) {
        titleLabel.text = viewModel.textTitle
        genreLabel.text = viewModel.textGenre
        priceLabel.text = viewModel.textPrice
        
        fetchImage(viewModel.textArtwork)
    }
    
    
    // MARK: - Logic
    func fetchImage(_ artworkUrl: String) {
        let url = URL(string: artworkUrl)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
        thumbnail.kf.indicatorType = .activity
        
        
        KF.url(url)
        .setProcessor(processor)
        .placeholder(UIImage(named: "placeholder"))
        .scaleFactor(UIScreen.main.scale)
        .transition(.fade(0.3))
        .cacheOriginalImage()
        .set(to: thumbnail)
    }
    
    
    // MARK: - Events
    @objc private func userTapFavorite() {
         // tapFavorite!()
    }

}
