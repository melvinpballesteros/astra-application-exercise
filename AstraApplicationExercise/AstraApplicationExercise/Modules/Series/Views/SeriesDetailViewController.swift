//
//  SeriesDetailViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/3/23.
//

import UIKit

class SeriesDetailViewController: BaseDetailViewController {
    
    // MARK: - Variables
    
    let detailViewModel = SeriesDetailViewModel()
    
    // MARK: - Controls
    
    

    // MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDetail()
    }

    
    private func fetchDetail() {
        detailViewModel.fetchSerieDetailInfo(id: seriesDetailViewModel?.textID ?? "") { 
            self.refreshUI()
        } failed: { 
            
        }
    }
    
    private func refreshUI() {
        fetchImage(artworkUrl: detailViewModel.posterUrl)
        
        titleLabel.text = detailViewModel.title
        genreLabel.text = detailViewModel.genre
        
        longDescLabel.attributedText = NSAttributedString().setAttributedText(fullText: detailViewModel.plot, 
                                                                              boldText: "Plot:")
    }


}
