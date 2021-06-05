//
//  PaperText.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

// The different types of text styles that the document should be able to display
enum PaperTextType {
    case DocumentTitle
    case SectionTitle
    case SubsectionTitle
    case TextSection
    case PageNumber
    case ImageDescription
}

/* Since the paper should only display a fixed amount of text styles, this class will handle the preferences of the different styles. It also handles the converson of certain text patterns to subscript to display the controller's parameters Kp, Ki and Kd correctly.
 */
class PaperText: SKLabelNode {
    
    override init() {
        super.init()
    }
    
    init(type: PaperTextType, text: String) {
        super.init(fontNamed: "TimesNewRomanPSMT")
        
        self.fontColor = .black
        self.verticalAlignmentMode = .top
        
        switch type {
        case .TextSection:
            self.horizontalAlignmentMode = .left
            self.numberOfLines = 0
            self.preferredMaxLayoutWidth = 410
            self.position = CGPoint(x: 35, y: 640 - 100)
        default:
            horizontalAlignmentMode = .center
        }
        
        switch type {
        case .DocumentTitle:
            self.fontSize = 38
        case .SectionTitle:
            self.fontSize = 26
            self.position = CGPoint(x: 240, y: 640 - 32)
        case .SubsectionTitle:
            self.fontSize = 20
        default:
            self.fontSize = 18
        }
        
        if type == .PageNumber {
            self.position = CGPoint(x: 240, y: 32)
        }
        
        self.attributedText = convertSubscripts(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttrText(text: String) {
        self.attributedText = convertSubscripts(text: text)
    }
    
    // Looks for the parameters Kp, Ki and Kd and converts the index to lowerscript to make them look as they should.
    func convertSubscripts(text: String) -> NSMutableAttributedString {
        
        let normalFont = NSFont(name: self.fontName!, size: self.fontSize)
        let subFont = NSFont(name: self.fontName!, size: self.fontSize * 0.7)
        
        let attrText : NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font:normalFont!])
        
        var param_idx = [Int]()
        let parameters = ["Kp", "Ki", "Kd"]
        var i = text.startIndex
        
        for param in parameters {
            while i < text.endIndex {
                guard let range = text.range(of: param, range: i..<text.endIndex), !range.isEmpty else {
                    break
                }
            
                let index = text.distance(from: text.startIndex, to: range.lowerBound)
                param_idx.append(index)
                i = range.upperBound
            }
        }
        
        let blO = -self.fontSize * 0.13
        for idx in param_idx {
            attrText.addAttributes([.font:subFont!, .baselineOffset:blO], range: NSRange(location: idx+1, length: 1))
        }
        
        return attrText
    }
    
}
