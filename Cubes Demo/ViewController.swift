//
//  ViewController.swift
//  Cubes Demo
//
//  Created by Олег Адамов on 05.09.17.
//  Copyright © 2017 AdamovOleg. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let objectNode = SCNNode()
    var startYPan: CGFloat = 0
    var yPosition: Float = 0
    var cubes = [CubeNode]()
    let colors = [UIColor.red, UIColor.green, UIColor.lightGray, UIColor.black, UIColor.purple]
        /*
        UIColor(red: 0, green: 144, blue: 255, alpha: 1),
        UIColor(red: 0, green: 220, blue: 99, alpha: 1),
        UIColor(red: 0, green: 236, blue: 235, alpha: 1),
        UIColor(red: 255, green: 79, blue: 0, alpha: 1),
        UIColor(red: 219, green: 29, blue: 0, alpha: 1)]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self

        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

        sceneView.scene.rootNode.addChildNode(objectNode)
        
        appendNode(with: SCNVector3(0, 0, -0.3))
        
        let button = UIButton(frame: CGRect(x: 4, y: 26, width: 80, height: 30))
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        sceneView.addSubview(button)
        
        setupPan()
    }
    
    
    @objc func backButtonPressed() {
        guard cubes.count > 0 else { return }
        let last = cubes.removeLast()
        last.removeFromParentNode()
    }
    
    
    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        let scnView = self.view as! SCNView
        
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        guard let result = hitResults.first, let cube = result.node as? CubeNode else { return }
        
        if let face = cube.findFace(with: result.geometryIndex) {
            print("face: \(face)")
            let pos = cube.newPosition(from: face)
            if isUnique(position: pos) {
                appendNode(with: pos)
            } else {
                print("not uniqie position!")
            }
        } else {
            print("no face!")
        }
    }
    
    
    func appendNode(with position: SCNVector3) {
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        let cube = CubeNode(position: position, color: self.colors[index])
        objectNode.addChildNode(cube)
        cubes.append(cube)
    }
    
    
    func isUnique(position: SCNVector3) -> Bool {
        for node in sceneView.scene.rootNode.childNodes {
            if node.position == position { return false }
        }
        return true
    }
    
    
    private func setupPan() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        switch gesture.state {
        case .began:
            self.startYPan = location.y
            willChangeYPosition()
        case .changed:
            var deltaY = (location.y - startYPan)/300
            deltaY = CGFloat(round(100 * deltaY) / 100)
            didChangeYPosition(Float(deltaY))
        case .ended: break
        default: break
        }
    }
    
    
    func willChangeYPosition() {
        self.yPosition = objectNode.position.y
    }
    
    func didChangeYPosition(_ value: Float) {
        var delta = self.yPosition - value
        delta = max(min(20, delta), -20)
        objectNode.position.y = delta
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
