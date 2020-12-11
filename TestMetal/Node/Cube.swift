//
//  Cube.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-10.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Cube: Primitive{
    
    var color: SIMD4<Float>!
    
    init(device: MTLDevice, color: SIMD4<Float>){
        self.color = color
        super.init(device: device)
    }

    override func buildVertices(){

        vertices = [
            Vertex(position: SIMD3<Float>(-1,  -1,   1),     color: SIMD4<Float>(1,0,0,1)),
                   
            Vertex(position: SIMD3<Float>( 1,  -1,   1),     color: SIMD4<Float>(0,1,0,1)),
                
            Vertex(position: SIMD3<Float>( 1,   1,   1),     color: SIMD4<Float>(0,0,1,1)),
                   
            Vertex(position: SIMD3<Float>(-1,   1,   1),     color: SIMD4<Float>(1,1,0,1)),
            
            Vertex(position: SIMD3<Float>(-1,  -1,  -1),     color: SIMD4<Float>(1,0,1,1)),
                   
            Vertex(position: SIMD3<Float>( 1,  -1,  -1),     color: SIMD4<Float>(0,1,1,1)),
                   
            Vertex(position: SIMD3<Float>( 1,   1,  -1),     color: SIMD4<Float>(1,1,1,1)),
                   
            Vertex(position: SIMD3<Float>(-1,   1,  -1),     color: SIMD4<Float>(1,0,0.5,1))]
               
        indices =  [0, 1, 2,    2, 3, 0, // front
                    1, 5, 6,    6, 2, 1, // right
                    7, 6, 5,    5, 4, 7, // back
                    4, 0, 3,    3, 7, 4, // left
                    4, 5, 1,    1, 0, 4, // bottom
                    3, 2, 6,    6, 7, 3] // top
                    //2, 6, 6, 5  ]
    }
    
}
