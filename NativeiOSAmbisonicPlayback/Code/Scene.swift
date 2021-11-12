//
//  Scene.swift
//  NativeiOSAmbisonicPlayback
//
//  Created by Robert Coomber on 11/11/21.
//

import Foundation
import SceneKit

public class Scene{
    
    var sceneView = SCNView()
    var pivotNode: SCNNode!
    var cameraNode: SCNNode!
    
    var startTouchX: CGFloat!
    var currentDragDelta: CGFloat!
    var startRotation: CGFloat!
    
    public var currentHeadRotation: Float = 0.0
    
    func loadScene(sceneView: SCNView){
        
        // Loads the 3D Model
        let scene = SCNScene(named: "head.obj")
        
        // Set Up Lighting
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 3000
        lightNode.position = SCNVector3(x: 25, y: 30, z: 20)
        scene?.rootNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        sceneView.backgroundColor = UIColor.black
        sceneView.scene = scene
        
        // Set up drag capability
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:)))
        sceneView.addGestureRecognizer(panRecognizer)
        
        
        self.sceneView = sceneView
        
        // Position Head
        self.sceneView.scene?.rootNode.childNode(withName: "default", recursively: true)?.eulerAngles = SCNVector3Make(0, 3.14, 0)
        self.sceneView.scene?.rootNode.childNode(withName: "default", recursively: true)?.position = SCNVector3Make(0, 0, -15)
    }
    
    
    /// This function is called when there is a drag, it takes the delta of the drag and applies it to the head rotation
    @objc func handlePan(panGesture: UIPanGestureRecognizer){
        let location = panGesture.location(in: self.sceneView)
        let headNode = self.sceneView.scene?.rootNode.childNode(withName: "default", recursively: true)
        
        switch panGesture.state {
        case .began:
            startTouchX = deg2rad(location.x)
            startRotation = CGFloat(headNode?.eulerAngles.y ?? 1.0)
            return
        case .ended:
            return
        case .changed:
            currentDragDelta = deg2rad(location.x) - startTouchX
            currentHeadRotation = Float(startRotation + (currentDragDelta ?? CGFloat(0.0)))
            headNode?.eulerAngles = SCNVector3Make(0, currentHeadRotation, 0)
            
            // Send the rotation event, so the Audio engine can use it
            Events.updateRotationValue.raise(data: Float(currentHeadRotation))
        default:
            break
        }
    }
    
    
    // helper degrees to radians function, useful for 3D rotations in iOS
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

