//
//  Theory2.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the second part of the theory along with the formula that mathematically describes the behaviour of a PID controller.
 */
public class Theory2PageScene: SKScene {
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white
        
        let btn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: nextButtonPressed)
        btn.position = CGPoint(x: size.width/2, y: size.height - 522 - 46/2)
        addChild(btn)
        
        let text1 = "The formula below shows how to calculate these three terms.\nThe parameters Kp, Ki and Kd are scaling factors that are used to tune the controller. They determine how big the influence of a term is on the overall result. The next pages will explain the parameters in detail and demonstrate the influence of each of the three terms using interactive examples."
        let sectionLabel1 = PaperText(type: .TextSection, text: text1)
        addChild(sectionLabel1)
        
        let text2 = "When a PID controller influences a car or robotic arm in the following examples, it does so by adjusting the parameters of the SKPhysicsWorld that controls the nodes behaviour rather than just changing the zRotation."
        let sectionLabel2 = PaperText(type: .TextSection, text: text2)
        sectionLabel2.position.y = size.height - 404
        addChild(sectionLabel2)
        
        addChild(PaperText(type: .SectionTitle, text: "Components of a PID Controller?"))
        
        addChild(PaperText(type: .PageNumber, text: "Page 3"))
        
        let pidFormula = SKSpriteNode(imageNamed: "PID_Formula")
        pidFormula.scale(to: CGSize(width: 410, height: 82.25))
        pidFormula.position = CGPoint(x: size.width/2, y: size.height - 300 - pidFormula.size.height/2)
        addChild(pidFormula)
    }
    
    private func nextButtonPressed() {
        let parametersPD = ParametersPDPageScene(size: CGSize(width: 480, height: 640))
        parametersPD.initStage1()
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        parametersPD.scaleMode = .aspectFill
        scene?.view?.presentScene(parametersPD, transition: transition)
    }
}

