//
//  TitlePage.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the title of the interactive paper along with an image and the button which presents the next scene / page.
 */
public class TitlePageScene: SKScene {
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white
        
        let titles = [
            ("An Introduction to", 26, 50),
            ("PID Controllers", 38, 95),
            ("Interactive Paper", 26, 146),
            ("WWDC19 Scholarship Submission", 20, 532),
            ("by Marius Montebaur", 20, 570)
        ]
        
        for attr in titles {
            let title = SKLabelNode(text: attr.0)
            title.fontSize = CGFloat(attr.1)
            title.fontName = "TimesNewRomanPSMT"
            title.horizontalAlignmentMode = .center
            title.verticalAlignmentMode = .top
            title.position = CGPoint(x: size.width/2, y: size.height - CGFloat(attr.2))
            title.fontColor = NSColor.black
            addChild(title)
        }
        
        let btn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: nextButtonPressed)
        btn.position = CGPoint(x: size.width/2, y: size.height - 465 - 46/2)
        addChild(btn)
        
        let pidComp = SKSpriteNode(imageNamed: "PID_Components")
        pidComp.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(pidComp)
    }
    
    private func nextButtonPressed() {
        let page2 = Theory1PageScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        page2.scaleMode = .aspectFill
        scene?.view?.presentScene(page2, transition: transition)
    }
}

