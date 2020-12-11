//
//  Plane.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Plane: Primitive{
    
    var color: SIMD4<Float>!
    
    init(device: MTLDevice, color: SIMD4<Float>){
        self.color = color
        super.init(device: device)
    }

    override func buildVertices(){

        vertices = [
                   Vertex(position: SIMD3<Float>( 1,  1,  0), //v1
                          color: color),
                   
                   Vertex(position: SIMD3<Float>(-1, 1,  0),  //v2
                          color: color),
                   
                   Vertex(position: SIMD3<Float>( 1,  -1,  0), //v3
                          color: color),
                   
                   Vertex(position: SIMD3<Float>( -1,  -1,  0), //v4
                          color: color),]
               
        indices =  [0, 1, 3,
                    0, 3, 2]

    }
    
}
