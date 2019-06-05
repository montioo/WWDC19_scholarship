//
//  ParametersPD.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* Displays the explanations for the parameters Kp and Kd.
At first, to keep the paper clean, only the parameter Kp is explained along with a button to start the interactive example which lets the user tune the Kp parameter for a car.
Then, when this scene is loaded again, the second stage will explain the influence of the parameter Kd.
 */
class ParametersPDPageScene: SKScene {
    
    private var tryBtn1 : ButtonNode!
    
    override public func didMove(to view: SKView) {
        backgroundColor = .white
        
        addChild(PaperText(type: .SectionTitle, text: "The Parameters Kp and Kd"))
        addChild(PaperText(type: .PageNumber, text: "Page 4"))
    }
    
    public func initStage1() {
        let subsTitle = PaperText(type: .SubsectionTitle, text: "Kp: Proportional Term")
        subsTitle.position = CGPoint(x: size.width/2, y: size.height - 100)
        addChild(subsTitle)
        
        let text = "The output is proportional to the error term. Kp is multiplied by the current error to obtain the new controller output."
        let desc = PaperText(type: .TextSection, text: text)
        desc.position.y = size.height - 143
        addChild(desc)
        
        let pTermFormula = SKSpriteNode(imageNamed: "ProportionalTerm")
        pTermFormula.scale(to: CGSize(width: 144, height: 55))
        pTermFormula.position = CGPoint(x: 41 + 144/2, y: size.height - 213 - 55/2)
        addChild(pTermFormula)
        
        tryBtn1 = ButtonNode(imageNamed: "TryItBtn", targetFunc: executeExample1)
        tryBtn1.position = CGPoint(x: 322 + tryBtn1.size.width/2, y: size.height - 218 - tryBtn1.size.height/2)
        addChild(tryBtn1)
    }
    
    public func initStage2() {
        initStage1()
        tryBtn1.isUserInteractionEnabled = false
        tryBtn1.alpha = 0.3
        
        let subsTitle = PaperText(type: .SubsectionTitle, text: "Kd: Derivative Term")
        subsTitle.position = CGPoint(x: size.width/2, y: size.height - 350)
        addChild(subsTitle)
        
        let text = "The derivative term considers the rate of change in the error value. Thus it will prevent the output value from overshooting, as it lowers the rate of change when the output approaches the desired value."
        let desc = PaperText(type: .TextSection, text: text)
        desc.position.y = size.height - 389
        addChild(desc)
        
        let dTermFormula = SKSpriteNode(imageNamed: "DerivativeTerm")
        dTermFormula.scale(to: CGSize(width: 170, height: 90))
        dTermFormula.position = CGPoint(x: 41 + 144/2, y: size.height - 495 - 55/2)
        addChild(dTermFormula)
        
        let tryBtn2 = ButtonNode(imageNamed: "TryItBtn", targetFunc: executeExample2)
        tryBtn2.position = CGPoint(x: 322 + tryBtn2.size.width/2, y: size.height - 506 - tryBtn2.size.height/2)
        addChild(tryBtn2)
    }
    
    public func executeExample1() {
        let carExampleStage1 = CarExampleScene(size: CGSize(width: 480, height: 640))
        carExampleStage1.initStage1()
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        carExampleStage1.scaleMode = .aspectFill
        scene?.view?.presentScene(carExampleStage1, transition: transition)
    }
    
    public func executeExample2() {
        let carExampleStage2 = CarExampleScene(size: CGSize(width: 480, height: 640))
        carExampleStage2.initStage2()
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        carExampleStage2.scaleMode = .aspectFill
        scene?.view?.presentScene(carExampleStage2, transition: transition)
    }
}
