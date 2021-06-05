//
//  CarExample.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 17.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//


import SpriteKit

/* This scene contains the first interactive example: Steering a car with a PID controller.
The example has two stages. At first (stage 1), the controller only uses the parameter Kp to control the proportional part of the controller's calculations. This leads to the car overshooting the center of the road and oscillating around the road without following it precisely. The user has the option to tune the value of the parameter Kd but this alone will not improve the controller's performance much.
With the push of a button, the user can return to the previous scene, where the derivative part of the PID controller with the parameter Kd is introduced. The user can now test the car example again (stage 2), but this time he can also tune the PID controller's parameter which influences the derivative part. Now the cars movement is much better, as it lowers the steering angle as it approaches the center of the road.
 */
public class CarExampleScene: SKScene {
    
    private var descLabel : PaperText!
    private var navBtn : ButtonNode!
    
    private var sbKp : SliderNode!
    private var sbKd : SliderNode!
    
    private var car : SKShapeNode!
    private var way : SKShapeNode!
    
    private var carPID : PIDController!
    
    private var lastDot : Double = 0
    private let dotInterval : Double = 0.45
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white

        addChild(PaperText(type: .SectionTitle, text: "Interactive Example I: Steering a Car"))
        addChild(PaperText(type: .PageNumber, text: "Page 5"))
        
        let intactImgDesc = PaperText(type: .ImageDescription, text: "Interactive Figure 1")
        intactImgDesc.position = CGPoint(x: size.width/2, y: size.height - 548)
        addChild(intactImgDesc)
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        physicsBody?.isDynamic = false
        
        carPID = PIDController()
        carPID.maxChange = 0.2
        
        let pWay = CGMutablePath()
        pWay.move(to: CGPoint(x: 90, y: 180))
        pWay.addLine(to: CGPoint(x: 185, y: 180))
        
        pWay.move(to: CGPoint(x: 185, y: 160))
        pWay.addLine(to: CGPoint(x: 280, y: 160))
        pWay.addArc(center: CGPoint(x: 280, y: 90), radius: 70, startAngle: CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        pWay.addLine(to: CGPoint(x: 185, y: 20))
        
        pWay.move(to: CGPoint(x: 185, y: 0))
        pWay.addLine(to: CGPoint(x: 90, y: 0))
        pWay.addArc(center: CGPoint(x: 90, y: 90), radius: 90, startAngle: 1.5 * CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: true)
        
        way = SKShapeNode(path: pWay)
        way.position = CGPoint(x: (size.width - 350) / 2, y: 120)
        way.strokeColor = .black
        addChild(way)
        
        let pCar = CGMutablePath()
        pCar.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: -16.8, y: 7), CGPoint(x: -16.8, y: -7), CGPoint(x: 0, y: 0)])
        
        car = SKShapeNode(path: pCar)
        car.position = CGPoint(x: size.width/2 - 68, y: size.height/2)
        car.fillColor = .orange
        car.strokeColor = .black
        car.zPosition = 1
        car.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: -16.8, height: 14), center: CGPoint(x: -8.4, y: 0))
        car.physicsBody?.affectedByGravity = false
        
        addChild(car)
        
        let resetBtn = ButtonNode(imageNamed: "ResetButton", targetFunc: resetCar)
        resetBtn.position = CGPoint(x: 35 + navBtn.size.width/2, y: size.height - 557 - navBtn.size.height/2)
        addChild(resetBtn)
    }
    
    // Displays the text and controls necessary to experience stage 1 (only P control)
    public func initStage1() {
        sbKp = SliderNode(width: 150, title: "Change Kp")
        sbKp.position = CGPoint(x: size.width/2, y: size.height / 2 + 30)
        sbKp.maxValue = 0.4; sbKp.minValue = 0; sbKp.currentValue = 0.08
        addChild(sbKp)
        
        let descText = "This first example uses only the proportional part of the controller to compute the output, while the other two parameters are set to zero. As you can see, the car doesn't follow the line very precisely. Try to change the parameter Kp with the slider to gain a feeling for the proportional part's influence."
        descLabel = PaperText(type: .TextSection, text: descText)
        addChild(descLabel)
        
        navBtn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: returnToParametersPD)
        navBtn.position = CGPoint(x: 480 - 35 - navBtn.size.width/2, y: size.height - 557 - navBtn.size.height/2)
        addChild(navBtn)
    }
    
    // Displays the text and controls necessary to experience stage 2 (PD control)
    public func initStage2() {
        initStage1()
        
        sbKd = SliderNode(width: 150, title: "Change Kd")
        sbKd.position = CGPoint(x: size.width * (3/4), y: size.height / 2 + 30)
        sbKd.maxValue = 0.6; sbKd.minValue = 0; sbKd.currentValue = 0 // 0.38
        addChild(sbKd)
        
        sbKp.currentValue = 0.28
        
        sbKp.position.x = size.width/4
        
        let text = "Adjust the parameter Kd to be around 0.4 to add the derivative part to the controller's calculations. This leads to a huge improvement. The car's steering is damped before the car crosses the line. This prevents the overshooting which occured when only the proportional part was used. Try adjusting the values to gain an understanding for their influence."
        descLabel.setAttrText(text: text)
        
        navBtn.target = nextPage
    }
    
    // Calculates the output of the PID controller and adds the blue lines which mark the cars way.
    override public func update(_ currentTime: TimeInterval) {
        var Kp : CGFloat = 0
        if let s = sbKp {
            Kp = s.currentValue
        }
        
        var Kd : CGFloat = 0
        if let s = sbKd {
            Kd = s.currentValue
        }
        
        let measurement = carsDistanceToStreet()
        carPID.setParams(p: Kp, i: 0, d: Kd)
        carPID.goal = 0
        let steering = carPID.calculate(measurement: measurement) * 0.1
        let speed : CGFloat = 30
        let r = car.zRotation
        let velo = CGVector(dx: sin(-r) * steering + cos(-r) * speed, dy: cos(r) * steering + sin(r) * speed)
        car.physicsBody!.velocity = velo
        car.zRotation = atan2(velo.dy, velo.dx)
 
        let time = NSDate().timeIntervalSince1970
        if time - lastDot > dotInterval {
            lastDot = time
            let dot = SKShapeNode(rect: CGRect(x: -7, y: -1.5, width: 6, height: 3))
            dot.fillColor = NSColor.blue
            dot.lineWidth = 0
            dot.position = car.position
            dot.zPosition = 0.5
            dot.zRotation = car.zRotation
            dot.name = "dot"
            addChild(dot)
            let fadeOutAction = SKAction.fadeOut(withDuration: 10)
            dot.run(fadeOutAction, completion: {
                dot.removeFromParent()
            })
        }
    }
    
    // Calculates the current distance of the car to the path that draws the street.
    func carsDistanceToStreet() -> CGFloat {
        let cPosOnTrack = car.convert(CGPoint(x: 0, y: 0), to: way)
        
        if cPosOnTrack.x < 90 {
            // left half circle
            return CGFloat(sqrt(Double(pow((cPosOnTrack.x - 90), 2) + pow(cPosOnTrack.y - 90, 2)))) - 90
        }
        
        if cPosOnTrack.x < 185 {
            // left straight piece of the road
            if cPosOnTrack.y > 90 {
                return cPosOnTrack.y - 180
            }
            return cPosOnTrack.y * (-1)
        }
        
        if cPosOnTrack.x < 280 {
            // right straight piece of the road
            if cPosOnTrack.y > 90 {
                return cPosOnTrack.y - 160
            }
            return cPosOnTrack.y * (-1) + 20
        }
        
        // right half circle
        return CGFloat(sqrt(Double(pow((cPosOnTrack.x - 280), 2) + pow(cPosOnTrack.y - 90, 2)))) - 70
    }
    
    // Resets the cars position and the values of the PID controller that change over time. This is necessary because with a very bad tuned controller, the car might move away from the street too far.
    func resetCar() {
        car.position = CGPoint(x: size.width/2 - 68, y: size.height/2)
        car.zRotation = 0
        car.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        carPID.reset()
        _ = self["dot"].map({ $0.removeFromParent() })
    }
    
    // Loads the last scene again but now also displays the explaination for the derivative part of the control.
    func returnToParametersPD() {
        let parametersPD = ParametersPDPageScene(size: CGSize(width: 480, height: 640))
        parametersPD.initStage2()
        let transition = SKTransition.moveIn(with: .left, duration: 0.7)
        parametersPD.scaleMode = .aspectFill
        scene?.view?.presentScene(parametersPD, transition: transition)
    }
    
    // Loads the next page. Now, that the user has gained an understanding of the proportional and derivative parts influences, the integral part can be explained.
    func nextPage() {
        let parameterI = ParameterIPageScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        parameterI.scaleMode = .aspectFill
        scene?.view?.presentScene(parameterI, transition: transition)
    }
}

