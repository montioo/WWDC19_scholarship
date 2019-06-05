
// WWDC19 Scholarship Submission
// Author: Marius Montebaur

/* Description:
 This playground explains how a PID controller works. PID controllers
 are very common in the field of control systems engineering and can
 be used for a lot of different tasks. Their main goal is to control
 a system, e.g. a machine. The current state of this machine is permanently
 compared to the desired state and the error is then used in three
 different terms to compute the new output, i.e. the control signal.
 
 The examples use SpriteKit's Physics World to demonstrate the
 controllers reaction to gravity and other physical forces.
 
 The whole playground is structured like a paper. There are
 multiple pages, starting with the cover page and the theoretical
 aspects of a PID controller. The following pages contain interactive
 examples that utilise PID controllers to control some form of
 system with simulated physics. The parameters of the controller can
 be changed in realtime which results in an immediate change of the
 controllers output and thus the systems behaviour.
 
 The order of the pages is as follows:
 1. TitlePage.swift
 2. Theory1.swift
 3. Theory2.swift
 4. ParametersPD.swift
 5. CarExample.swift
 6. ParameterI.swift
 7. RobotArmExample.swift
 8. EndPage.swift
 */

import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 640))
let scene = TitlePageScene(size: CGSize(width: 480, height: 640))

scene.scaleMode = .aspectFill

sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
