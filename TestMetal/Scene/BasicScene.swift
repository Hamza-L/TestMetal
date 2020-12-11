//
//  BasicScene.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class BasicScene: Scene{
        var cube: Cube!
    
    override init(device: MTLDevice){
        super.init(device: device)
        
        
        cube = Cube(device: device, color: SIMD4<Float>(repeating: 1))
        
        cube.translate(position: SIMD3<Float>(0,0,-5))
        
        
        
        //cube.rotation_axis = SIMD3<Float>(1,0,0)
        //cube.rotation_angle = 15
        
        add(childNode: cube)
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        cube.rotate(axis: SIMD3<Float>(1,0,0), angle: deltaTime*60)
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
}
