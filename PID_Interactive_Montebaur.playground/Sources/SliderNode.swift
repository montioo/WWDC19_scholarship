//
//  SliderNode.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 17.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

/* This node implements the sliders which are used throughout the whole playground to change parameters which influece the physics world of the interactive examples.
*/
public class SliderNode: SKNode {

    private var sliderBar : SKShapeNode!
    private var sliderGrip : SKShapeNode!
    private var barTitle : SKLabelNode!
    private var barValue : SKLabelNode!
    
    public var maxValue: CGFloat = 1
    public var minValue: CGFloat = -1
    public var currentValue: CGFloat = 0 {
        didSet {
            currentValue = max(min(currentValue, maxValue), minValue)
            barValue.text = String(format: "%.2f", currentValue)
            let newPosX = mapValue(currentValue, inMin: minValue, inMax: maxValue, outMin: -sliderBar.frame.size.width/2 + 4, outMax: sliderBar.frame.size.width/2 - 4)
            sliderGrip.position.x = newPosX
        }
    }
    
    init(width: CGFloat, title: String) {
        super.init()
        
        self.isUserInteractionEnabled = true
        
        sliderBar = SKShapeNode(rect: CGRect(x: -width/2, y: -2, width: width, height: 4), cornerRadius: 2)
        sliderBar.fillColor = NSColor.lightGray
        sliderBar.strokeColor = NSColor.lightGray
        addChild(sliderBar)
        
        sliderGrip = SKShapeNode(circleOfRadius: 8)
        sliderGrip.fillColor = NSColor.lightGray
        sliderGrip.strokeColor = NSColor.darkGray
        addChild(sliderGrip)
        
        if title != "" {
            barTitle = SKLabelNode(text: title)
            barTitle.verticalAlignmentMode = .baseline
            barTitle.horizontalAlignmentMode = .left
            barTitle.position = CGPoint(x: -width/2 - 2, y: 11)
            barTitle.fontColor = NSColor.black
            barTitle.fontName = "HelveticaNeue-Medium"
            barTitle.fontSize = 12
            addChild(barTitle)
        }
        
        barValue = SKLabelNode(text: String(describing: 0.0))
        barValue.verticalAlignmentMode = .baseline
        barValue.horizontalAlignmentMode = .right
        barValue.position = CGPoint(x: width/2 + 2, y: 11)
        barValue.fontColor = NSColor.black
        barValue.fontName = "HelveticaNeue-Medium"
        barValue.fontSize = 12
        addChild(barValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // mouse down: The user wants to change the sliders value.
    override public func mouseDown(with event: NSEvent) {
        let pos = event.location(in: self)

        currentValue = mapValue(pos.x, inMin: -sliderBar.frame.size.width/2 + 4, inMax: sliderBar.frame.size.width/2 - 4, outMin: minValue, outMax: maxValue)
        sliderGrip.fillColor = NSColor.darkGray
    }
    
    // mouse dragged: The user drags the mouse so the sliders grip has to follow.
    override public func mouseDragged(with event: NSEvent) {
        let pos = event.location(in: self)
        currentValue = mapValue(pos.x, inMin: -sliderBar.frame.size.width/2 + 4, inMax: sliderBar.frame.size.width/2 - 4, outMin: minValue, outMax: maxValue)
    }
    
    override public func mouseUp(with event: NSEvent) {
        sliderGrip.fillColor = NSColor.lightGray
    }
    
    // This function maps a value from one value range to another.
    private func mapValue(_ val: CGFloat, inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat) -> CGFloat {
        
        let percent = (val - inMin) / (inMax - inMin)
        let output = (outMax - outMin) * percent + outMin
        return output
    }
    
    // sets the thress parameters minimum, maximum and current values all at once.
    public func setParams(min: CGFloat, max: CGFloat, current: CGFloat) {
        minValue = min
        maxValue = max
        currentValue = current
    }
    
}
