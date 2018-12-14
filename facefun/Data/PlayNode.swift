//
//  PlayNode.swift
//  facefun
//
//  Created by Derrick Showers on 12/13/18.
//  Copyright © 2018 Derrick Showers. All rights reserved.
//

import SceneKit

class PlayNode: SCNNode {

    init(width: CGFloat = 0.05, height: CGFloat = 0.05) {
        super.init()

        let sphere = SCNSphere(radius: width / 2)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        geometry = sphere
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayNode {

    /**
     Take from tutorial:
     https://www.raywenderlich.com/5491-ar-face-tracking-tutorial-for-ios-getting-started
     */
    func updatePosition(for vectors: [vector_float3]) {
        let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
        position = SCNVector3(newPos)
    }
}
