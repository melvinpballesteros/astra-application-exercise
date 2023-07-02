//
//  NSAttribute+Extension.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    func setAttributedText(fullText: String, boldText: String)-> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .justified
        
        let attributeBold = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), 
                             NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributeRegular = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), 
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let boldText = NSMutableAttributedString(string: boldText, attributes: attributeBold)
        let regularText = NSMutableAttributedString(string: fullText, attributes: attributeRegular)

        regularText.addAttribute(NSAttributedString.Key.font,
                                 value: UIFont.systemFont(ofSize: 18, weight: .bold),
                                 range: NSRange(location: 0, length: boldText.length))
        
        regularText.addAttribute(NSAttributedString.Key.paragraphStyle, 
                                 value: paragraphStyle, 
                                 range: NSMakeRange(0, regularText.length))

        return regularText
    }
    
    
}
