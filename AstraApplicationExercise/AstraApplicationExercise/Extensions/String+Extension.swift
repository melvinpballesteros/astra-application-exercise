//
//  String+Extension.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation


extension String {
    
    func formatImageUrl(format: String) -> String {
        return self.replacingOccurrences(of: "100x100", with: format)
    }
    
    
}
