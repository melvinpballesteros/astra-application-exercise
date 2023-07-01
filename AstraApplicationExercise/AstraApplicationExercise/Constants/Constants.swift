//
//  Constants.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 6/30/23.
//

import Foundation
import UIKit

enum Api {
    static let movie = "https://itunes.apple.com/search?media=movie&term=2023"
    static let musicVideo = "https://itunes.apple.com/search?media=movie&term=2023&entity=musicVideo"
}

enum screenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

enum AppColor {
    static let black = UIColor(red: 26/255, green: 25/255, blue: 36/255, alpha: 1) 
    static let yellow = UIColor(red: 231/255, green: 186/255, blue: 44/255, alpha: 1)
    static let gray = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
    static let grayBlack = UIColor(red: 35/255, green: 34/255, blue: 46/255, alpha: 1)
}
