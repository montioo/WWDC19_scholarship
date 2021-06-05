//
//  ParameterI.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the explanation for the parameter Ki. 
 */
class ParameterIPageScene: SKScene {
    
    override public func didMove(to view: SKView) {
        backgroundColor = .white
        
        addChild(PaperText(type: .SectionTitle, text: "The Parameter Ki"))
        addChild(PaperText(type: .PageNumber, text: "Page 6"))
    
        let subsTitle = PaperText(type: .SubsectionTitle, text: "Ki: Integral Term")
        subsTitle.position = CGPoint(x: size.width/2, y: size.height - 100)
        addChild(subsTitle)
        
        let text = "The integral term sums up previous errors. This helps to compensate constant influences like more weight pulling a robotic arm down."
        let desc = PaperText(type: .TextSection, text: text)
        desc.position.y = size.height - 143
        addChild(desc)
        
        let iTermFormula = SKSpriteNode(imageNamed: "IntegralTerm")
        iTermFormula.scale(to: CGSize(width: 245, height: 108))
        iTermFormula.position = CGPoint(x: 41 + 245/2, y: size.height - 213 - 108/2)
        addChild(iTermFormula)
        
        let tryBtn = ButtonNode(imageNamed: "TryItBtn", targetFunc: nextPage)
        tryBtn.position = CGPoint(x: 322 + tryBtn.size.width/2, y: size.height - 218 - tryBtn.size.height/2)
        addChild(tryBtn)
    }
    
    public func nextPage() {
        let nextPage = RobotArmExampleScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        nextPage.scaleMode = .aspectFill
        scene?.view?.presentScene(nextPage, transition: transition)
    }
}
