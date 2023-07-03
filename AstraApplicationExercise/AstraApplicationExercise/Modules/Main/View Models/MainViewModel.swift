//
//  MainViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import UIKit

class MainViewModel {
    
    let tab1Text = "Movies"
    let tab2Text = "Music Videos"
    let tab3Text = "Series"
    
    func createTabController(title: String, 
                             controller: UIViewController, 
                             imageFill: String)-> UIViewController {
        controller.navigationItem.title = title
        let navController = UINavigationController(rootViewController: controller)
        
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageFill)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = UIImage(named: imageFill)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        navController.isNavigationBarHidden = true
        return navController
    }
}
