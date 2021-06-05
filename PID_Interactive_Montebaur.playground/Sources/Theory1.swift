//
//  Theory1.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the first page of theory with an image showing the structural components of a PID controller.
 */
public class Theory1PageScene: SKScene {
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white
        
        let btn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: nextButtonPressed)
        btn.position = CGPoint(x: size.width/2, y: size.height - 522 - 46/2)
        addChild(btn)
        
        let pidComp = SKSpriteNode(imageNamed: "PID_Components")
        pidComp.position = CGPoint(x: size.width/2, y: size.height - 332 - pidComp.size.height/2)
        addChild(pidComp)
        
        let text = "PID (proportional integral derivative) controllers influence real world machines so that a given state / position is maintained even in the event of interference.\n\nIts output depends not only on the desired value (e.g. a robotic arm's angle), the so called setpoint s, but also on the current value c (e.g. the current angle). The difference between these two is called error e and is used in three different terms which are then added to calculate the output o."
        let sectionLabel = PaperText(type: .TextSection, text: text)
        addChild(sectionLabel)
        
        addChild(PaperText(type: .SectionTitle, text: "What is a PID Controller?"))
        addChild(PaperText(type: .PageNumber, text: "Page 2"))
    }
    
    private func nextButtonPressed() {
        let page2 = Theory2PageScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        page2.scaleMode = .aspectFill
        scene?.view?.presentScene(page2, transition: transition)
    }
}

