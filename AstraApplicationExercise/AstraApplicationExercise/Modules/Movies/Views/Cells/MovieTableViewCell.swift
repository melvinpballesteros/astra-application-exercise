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
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func setupViews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
    func configure(_ viewModel: MovieViewModel) {
        
        
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

}
