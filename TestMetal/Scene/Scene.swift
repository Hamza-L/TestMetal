//
//  Scene.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Scene: Node{
    
    var device: MTLDevice!
    var sceneConstants = SceneConstants()
    var aspectRatio: Float = 1.0
    
    init(device: MTLDevice){
        self.device = device
        super.init()
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        //square.rotate(axis: SIMD3<Float>(1,1,0), angle: deltaTime)
        sceneConstants.projectionMatrix = simd_float4x4.init(
        perspectiveDegreesFov: 60,
        AspectRatio: aspectRatio,
        NearZ: 0.1,
        FarZ: 100)
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
}
