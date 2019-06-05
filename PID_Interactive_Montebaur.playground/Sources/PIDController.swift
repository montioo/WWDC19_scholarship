//
//  PIDController.swift
//  PID_Interactive_Montebaur
//
//  Created by Marius Montebaur on 18.03.19.
//  Copyright © 2019 Marius Montebaur. All rights reserved.
//

import Foundation

/* This class represents a PID controller.
Of course the parameters Kp, Ki and Kd can be tuned to influence the controlers output. To add more realism to the behaviour, it is also possible to specify a maxChange value which limits the difference between two values outputed by the controller. This is useful, because a cars steering wheel can't just be rotated by 720 degree but needs some time.
 It's also possible to limit the absolute value the controler outputs because real systems can't provide unlimited force / torque / rotation / ....
 */
class PIDController {
    
    public var paramP : CGFloat = 0
    public var paramI : CGFloat = 0
    public var paramD : CGFloat = 0
    
    public var maxOut : CGFloat?
    
    public var goal : CGFloat = 0

    public var maxChange : CGFloat = 0.5
    
    private var lastCall : Double = NSDate().timeIntervalSince1970
    private var integral : CGFloat = 0
    private var previousError : CGFloat = 0
    private var previousOutput : CGFloat = 0
    
    init() {
    }
    
    func calculate(measurement: CGFloat) -> CGFloat {
        let now = NSDate().timeIntervalSince1970
        let dt = CGFloat(now - lastCall)
        lastCall = now
        
        let setPoint : CGFloat = goal
        let error = setPoint - measurement
        integral = integral + error * dt
        let derivative = (error - previousError) / dt
        var output = paramP * error + paramI * integral + paramD * derivative
        previousError = error

        output = inBoundsWithMaxRateOfChange(value: output, center: previousOutput, offset: maxChange)
        previousOutput = output
        
        if let m = maxOut {
            let clippedOut = min(abs(output), m) * (output / abs(output))
            return clippedOut
        }
        
        return output
    }
    
    // Stes all of the three parameters at once.
    func setParams(p: CGFloat, i: CGFloat, d: CGFloat) {
        paramP = p
        paramI = i
        paramD = d 
    }
    
    // Limits the given value to not change more than the specified amount.
    func inBoundsWithMaxRateOfChange(value: CGFloat, center: CGFloat, offset: CGFloat) -> CGFloat {
        if value > center - offset && value < center + offset {
            return value
        }

        if value < center - offset {
            return center - offset
        }
        
        return center + offset
    }
    
    // resets the parameters of the controller that change over time.
    public func reset() {
        previousError = 0
        integral = 0
        previousOutput = 0
        lastCall = 0
    }
    
    public func resetIntegral() {
        integral = 0
    }
}
