//
//  ButtonNode.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 20.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import SpriteKit

// Represents a button which can be pressed and then executes a function that
// was handed to the class previously.
public class ButtonNode: SKSpriteNode {

    public var target : ()->()?
    
    init(imageNamed: String, targetFunc: @escaping ()->()) {
        target = targetFunc
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: NSColor.black, size: texture.size())
        
        self.colorBlendFactor = 0
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func mouseDown(with event: NSEvent) {
        self.colorBlendFactor = 0.4
    }
    
    override public func mouseUp(with event: NSEvent) {
        self.colorBlendFactor = 0
        target()
    }
 

}
