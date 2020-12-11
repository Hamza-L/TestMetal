//
//  Node.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Node {
    
    var children: [Node] = []
    
    var position: SIMD3<Float> = SIMD3<Float>(repeating: 0)
    var rotation_axis: SIMD3<Float> = SIMD3<Float>(repeating: 0)
    var rotation_angle: Float = 0
    var initScale: SIMD3<Float> = SIMD3<Float>(repeating: 1)
    
    var modelMatrix: simd_float4x4 = matrix_identity_float4x4
    
    func add(childNode: Node){
        children.append(childNode)
    }
    
    func scale(scale: SIMD3<Float>){
        modelMatrix.scale(axis: scale)
    }
    
    func translate(position: SIMD3<Float>){
        modelMatrix.translate(axis: position)
    }
    
    func rotate(axis: SIMD3<Float>, angle: Float){
        modelMatrix.rotate(axis: axis, angle: angle)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        for childNode in children{
            childNode.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    
        //only draws renderable types among the nodes.
        if let renderable = self as? Renderable{
            renderable.draw(commandEncoder: commandEncoder)
        }
    
    }
    
    
    
    
}
