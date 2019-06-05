//
//  EndPage.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 23.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the last page of the interactive paper */
public class EndPageScene: SKScene {
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white
        
        let btn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: nextButtonPressed)
        btn.position = CGPoint(x: size.width/2, y: size.height - 339 - 46/2)
        addChild(btn)
        
        let texts = [
            ("I hope you learned something about PID controllers", 153),
            ("and liked the interactive examples.", 178),
            ("To start over, please press the button.", 242)
        ]
        
        for text in texts {
            let label = PaperText(type: .ImageDescription, text: text.0)
            label.position = CGPoint(x: size.width/2, y: size.height - CGFloat(text.1))
            addChild(label)
        }
        
        addChild(PaperText(type: .SectionTitle, text: "Thanks for experiencing this Playground"))
        addChild(PaperText(type: .PageNumber, text: "Page 8"))
    }
    
    private func nextButtonPressed() {
        let titlePage = TitlePageScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        titlePage.scaleMode = .aspectFill
        scene?.view?.presentScene(titlePage, transition: transition)
    }
}

