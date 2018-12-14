//
//  FaceViewController.swift
//  facefun
//
//  Created by Derrick Showers on 12/9/18.
//  Copyright © 2018 Derrick Showers. All rights reserved.
//

import UIKit
import ARKit

class FaceViewController: UIViewController {

    @IBOutlet private var sceneView: ARSCNView!
    fileprivate var faceNode: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        sceneView.session.pause()

        faceNode?.geometry?.firstMaterial?.transparency = 1
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func didTapToggleMeshButton(_ sender: UIButton) {
        let currentTransperency = faceNode?.geometry?.firstMaterial?.transparency ?? 0
        faceNode?.geometry?.firstMaterial?.transparency = currentTransperency == 0 ? 1 : 0
    }

    @IBAction func didTapToggleNoseButton(_ sender: UIButton) {
        let isHidden = faceNode?.childNode(withName: "sample", recursively: false)?.isHidden ?? false
        faceNode?.childNode(withName: "sample", recursively: false)?.isHidden = !isHidden
    }
}

// MARK: - ARSCNViewDelegate
extension FaceViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }

        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.transparency = 0

        let sampleNode = PlayNode()
        let verticies = [(anchor as! ARFaceAnchor).geometry.vertices[9]]
        sampleNode.name = "sample"
        sampleNode.updatePosition(for: verticies)
        node.addChildNode(sampleNode)

        self.faceNode = node

        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }

        let sampleNode = node.childNode(withName: "sample", recursively: false) as? PlayNode
        let verticies = [(anchor as! ARFaceAnchor).geometry.vertices[9]]
        sampleNode?.updatePosition(for: verticies)

        faceGeometry.update(from: faceAnchor.geometry)
    }
}
