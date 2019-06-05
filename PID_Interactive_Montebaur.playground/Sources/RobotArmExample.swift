//
//  RobotArmExample.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 18.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* This example shows a robotic arm which the user can tune and control.
As the integral component of a PID controller is able to compensate a constant influence on the system, an example made to demonstrate this parameters purpose should also offer some form of constant influence.
 The robotic arm has a weight attatched to it which pulls the arm down. The force normally used to hold the arm in place is not enough to hold the arms position. The parameters Ki can compensate this behaviour.
 The user can also change the mass of the weight that the arm carries, to make sure the chosen parameter Ki does not only work for one weight.
 */
public class RobotArmExampleScene: SKScene {
    
    private var sbKp : SliderNode!
    private var sbKi : SliderNode!
    private var sbKd : SliderNode!
    
    private var lastKi : CGFloat = 0
    
    private var joint1AngleSlider : SliderNode!
    private var joint2AngleSlider : SliderNode!
    
    private var weightSlider : SliderNode!
    
    private var robotBase : SKSpriteNode!
    private var weight : SKSpriteNode!
    
    private var joint1PID : PIDController!
    private var joint2PID : PIDController!
    
    private var angleIndicator1 : SKSpriteNode!
    private var angleIndicator2 : SKSpriteNode!
    
    override public func didMove(to view: SKView) {
        backgroundColor = NSColor.white
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        physicsBody?.isDynamic = false
        
        joint1PID = PIDController()
        joint1PID.maxChange = 0.2

        joint2PID = PIDController()
        joint2PID.maxChange = 0.2
        
        sbKp = SliderNode(width: 150, title: "Change Kp")
        sbKp.position = CGPoint(x: size.width * 0.25, y: size.height - 80)
        sbKp.maxValue = 10; sbKp.minValue = 0; sbKp.currentValue = 5.21
        sbKp.isHidden = true
        addChild(sbKp)
        
        sbKi = SliderNode(width: 150, title: "Change Ki")
        sbKi.position = CGPoint(x: 363, y: 321 + 0.85 * 213)
        sbKi.maxValue = 2; sbKi.minValue = 0; sbKi.currentValue = 0
        addChild(sbKi)
        
        sbKd = SliderNode(width: 150, title: "Change Kd")
        sbKd.position = CGPoint(x: size.width * 0.75, y: size.height - 80)
        sbKd.maxValue = 10; sbKd.minValue = 0; sbKd.currentValue = 1.56
        sbKd.isHidden = true
        addChild(sbKd)
        
        joint1AngleSlider = SliderNode(width: 150, title: "Joint 1 Angle")
        joint1AngleSlider.position = CGPoint(x: 363, y: 321 + 0.55 * 213)
        joint1AngleSlider.setParams(min: 0, max: 1.3, current: 0.8)
        addChild(joint1AngleSlider)
        
        joint2AngleSlider = SliderNode(width: 150, title: "Joint 2 Angle")
        joint2AngleSlider.position = CGPoint(x: 363, y: 321 + 0.35 * 213)
        joint2AngleSlider.setParams(min: -1.3, max: 0.0, current: -0.5)
        addChild(joint2AngleSlider)
        
        weightSlider = SliderNode(width: 150, title: "Change Weight")
        weightSlider.position = CGPoint(x: 363, y: 321 + 0.05 * 213)
        weightSlider.setParams(min: 1, max: 2.5, current: 1)
        addChild(weightSlider)
      
        
        robotBase = SKSpriteNode(imageNamed: "RobotBase")
        robotBase.position = CGPoint(x: 62 + robotBase.size.width/2, y: size.height - 223 - robotBase.size.height/2)
        robotBase.physicsBody = SKPhysicsBody(rectangleOf: robotBase.size)
        robotBase.physicsBody?.isDynamic = false
        addChild(robotBase)
        
        let armSec1 = SKSpriteNode(imageNamed: "Arm1")
        armSec1.position = CGPoint(x: 6 + 40, y: 2.5 + 10)
        armSec1.physicsBody = SKPhysicsBody(rectangleOf: armSec1.size)
        armSec1.name = "armSec1"
        armSec1.zPosition = -1
        robotBase.addChild(armSec1)
        
        let pin1Pos = armSec1.convert(CGPoint(x: -30, y: 0), to: scene!)
        let joint1 = SKPhysicsJointPin.joint(withBodyA: robotBase.physicsBody!, bodyB: armSec1.physicsBody!, anchor: pin1Pos)
        joint1.shouldEnableLimits = true
        joint1.lowerAngleLimit = -0.1
        joint1.upperAngleLimit = 1.4
        joint1.frictionTorque = 0.1
        scene?.physicsWorld.add(joint1)
        
        angleIndicator1 = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 3))
        angleIndicator1.anchorPoint.x = 0
        angleIndicator1.position = pin1Pos
        angleIndicator1.zPosition = 20
        addChild(angleIndicator1)
        
        let armSec2 = SKSpriteNode(imageNamed: "Arm2")
        armSec2.position = CGPoint(x: 20 + armSec2.size.width/2, y: 0)
        armSec2.physicsBody = SKPhysicsBody(rectangleOf: armSec2.size)
        armSec2.zPosition = 5
        armSec2.name = "armSec2"
        armSec1.addChild(armSec2)
        
        let pin2Pos = armSec2.convert(CGPoint(x: -21.5, y: 0), to: scene!)
        let joint2 = SKPhysicsJointPin.joint(withBodyA: armSec1.physicsBody!, bodyB: armSec2.physicsBody!, anchor: pin2Pos)
        joint2.shouldEnableLimits = true
        joint2.lowerAngleLimit = -1.4
        joint2.upperAngleLimit = 0.1
        joint2.frictionTorque = 0.1
        scene?.physicsWorld.add(joint2)
        
        angleIndicator2 = SKSpriteNode(color: .green, size: CGSize(width: 32, height: 3))
        angleIndicator2.anchorPoint.x = 0
        angleIndicator2.position = armSec2.convert(CGPoint(x: -21.5, y: 0), to: armSec1)
        angleIndicator2.zPosition = 20
        armSec1.addChild(angleIndicator2)
        
        weight = SKSpriteNode(imageNamed: "Weight")
        weight.anchorPoint.y = 1
        weight.position = CGPoint(x: 25.5, y: 0)
        weight.physicsBody = SKPhysicsBody(rectangleOf: weight.size, center: CGPoint(x: 0, y: -weight.size.height/2))
        weight.name = "weight"
        weight.zPosition = -1
        armSec2.addChild(weight)
        
        let pin3Pos = weight.convert(CGPoint(x: 0, y: 0), to: scene!)
        let joint3 = SKPhysicsJointPin.joint(withBodyA: armSec2.physicsBody!, bodyB: weight.physicsBody!, anchor: pin3Pos)
        joint3.frictionTorque = 0.005
        scene?.physicsWorld.add(joint3)
        
        let imageBorderPath = CGMutablePath()
        imageBorderPath.addRects([CGRect(x: 0, y: 0, width: 213, height: 213)])
        
        let imageBorder = SKShapeNode(path: imageBorderPath)
        imageBorder.position = CGPoint(x: 39, y: size.height - 108 - imageBorder.frame.size.height)
        imageBorder.fillColor = .clear
        imageBorder.strokeColor = .black
        addChild(imageBorder)
        
        let imageTitle = PaperText(type: .ImageDescription, text: "Interactive Figure 2")
        imageTitle.position = CGPoint(x: 39 + 213/2, y: size.height - 337)
        addChild(imageTitle)
        
        addChild(PaperText(type: .SectionTitle, text: "Interactive Example II: Robotic Arm"))
        addChild(PaperText(type: .PageNumber, text: "Page 7"))
        
        let descText = "The parameters of the controller for the left joint are already tuned. When changing the weight the arm has to lift, the torque used before to hold the arms position is not longer the right value. Try to increase the weight and see the arm lower. Then adjust the parameter Ki to be around 1.4 and see the arms movement compensates the weight. The green lines show the angle that each joint is supposed to hold."
        let desc = PaperText(type: .TextSection, text: descText)
        desc.position.y = size.height - 387
        addChild(desc)
        
        let navBtn = ButtonNode(imageNamed: "NextPageBtn", targetFunc: nextPage)
        navBtn.position = CGPoint(x: 480 - 35 - navBtn.size.width/2, y: size.height - 557 - navBtn.size.height/2)
        addChild(navBtn)
    }
    
    // Updates the UI with the currently desired rotations of each joint and also updates the PID controllers outputs.
    override public func update(_ currentTime: TimeInterval) {
        angleIndicator1.zRotation = joint1AngleSlider.currentValue
        angleIndicator2.zRotation = joint2AngleSlider.currentValue
        
        joint1PID.setParams(p: 5.39, i: 1.31, d: 7.5)
        joint1PID.goal = joint1AngleSlider.currentValue
        let thrust1 = joint1PID.calculate(measurement: robotBase["armSec1"][0].zRotation)
        robotBase["armSec1"][0].physicsBody?.applyAngularImpulse(thrust1 * 0.02) // 0.01
        
        if lastKi == 0 && sbKi.currentValue > 0 {
            joint2PID.resetIntegral()
        }
        lastKi = sbKi.currentValue
        
        joint2PID.setParams(p: sbKp.currentValue, i: sbKi.currentValue, d: sbKd.currentValue)
        joint2PID.goal = joint2AngleSlider.currentValue
        let thrust2 = joint2PID.calculate(measurement: robotBase["armSec1/armSec2"][0].zRotation)
        robotBase["armSec1/armSec2"][0].physicsBody?.applyAngularImpulse(thrust2 * 0.005) // 0.005
        
        let wSc = weightSlider.currentValue
        weight.physicsBody!.density = wSc
        let scale = 0.7 + (wSc / 8.33)
        weight.setScale(scale)
    }
    
    // Transitions to the next page which is in this case the last of the interactive paper.
    func nextPage() {
        let endPage = EndPageScene(size: CGSize(width: 480, height: 640))
        let transition = SKTransition.reveal(with: .left, duration: 0.7)
        endPage.scaleMode = .aspectFill
        scene?.view?.presentScene(endPage, transition: transition)
    }
}

