//
//  MainTabBarViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit
import SnapKit

class MainTabBarViewController: UITabBarController {
    
    let viewModel = MainViewModel()
    
    lazy var movieController: MovieViewController = {
        let controller = MovieViewController()
        return controller
    }()
    
    lazy var musicVideoController: MusicVideoViewController = {
        let controller = MusicVideoViewController()
        return controller
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupControllers()
    }
    
    // MARK: - Setup
    private func setupAttributes() {
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func setupControllers() {
        viewControllers = [
            viewModel.createTabController(title: viewModel.tab1Text, controller: movieController, imageFill: "tab-movie"),
            viewModel.createTabController(title: viewModel.tab2Text, controller: musicVideoController, imageFill: "")
            ]
    }
}
