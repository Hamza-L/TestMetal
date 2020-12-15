//
//  BasicScene.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class BasicScene: Scene{
        var cube: Node!
        var icos: Icosahedron!
        
    
    override init(device: MTLDevice){
        super.init(device: device)
        
        light.color = SIMD3<Float>(repeating: 1)
        light.diffIntensity = 1
        light.specIntensity = 1.01
        light.shinniness = 32
        
        //cube = Cube(device: device, color: SIMD4<Float>(repeating: 1))
        icos = Icosahedron(device: device, color: SIMD4<Float>(0.3,0.3,0.3,1))
        icos.translate(position: SIMD3<Float>(0,0,-3))
        icos.scale(scale: SIMD3<Float>(repeating: 0.5))
        
        let plane = Plane(device: device, color: SIMD4<Float>(0.3,0.3,0.3,1))
        plane.translate(position: SIMD3<Float>(0,-0.5,-3))
        plane.rotate(axis: SIMD3<Float>(1,0,0), angle: -90)
        plane.scale(scale: SIMD3<Float>(repeating: 5))

        cube = makeCube(device: device, color: SIMD4<Float>(0.3,0.3,0.3,1))
        cube.translate(position: SIMD3<Float>(0,0,-3))
        

        add(childNode: icos)
        
        
    }
    
    func makeCube(device: MTLDevice, color: SIMD4<Float>)->Node {
        
        let node = Node()
        
        let front = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        front.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        front.translate(position: SIMD3<Float>(0,0,1))
        
        let rside = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        rside.rotate(axis: SIMD3<Float>(0,1,0), angle: 90)
        rside.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        rside.translate(position: SIMD3<Float>(0,0,1))
        
        let back = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        back.rotate(axis: SIMD3<Float>(0,1,0), angle: 180)
        back.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        back.translate(position: SIMD3<Float>(0,0,1))
        
        let lside = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        lside.rotate(axis: SIMD3<Float>(0,1,0), angle: -90)
        lside.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        lside.translate(position: SIMD3<Float>(0,0,1))
        
        let top = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        top.rotate(axis: SIMD3<Float>(1,0,0), angle: 90)
        top.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        top.translate(position: SIMD3<Float>(0,0,1))
        
        let bottom = Plane(device: device, color: SIMD4<Float>(repeating: 1))
        bottom.rotate(axis: SIMD3<Float>(1,0,0), angle: -90)
        bottom.scale(scale: SIMD3<Float>(0.5, 0.5, 0.5))
        bottom.translate(position: SIMD3<Float>(0,0,1))
        
        node.add(childNode: front)
        node.add(childNode: rside)
        node.add(childNode: back)
        node.add(childNode: lside)
        node.add(childNode: top)
        node.add(childNode: bottom)
        
        return node
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        cube.rotate(axis: SIMD3<Float>(1,0,0), angle: deltaTime*30)
        cube.rotate(axis: SIMD3<Float>(0,1,0), angle: deltaTime*30)
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
}
