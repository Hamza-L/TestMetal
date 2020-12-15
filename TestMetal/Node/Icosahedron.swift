//
//  File.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-13.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Icosahedron: Primitive{
    
    var color: SIMD4<Float>!
    
    
    init(device: MTLDevice, color: SIMD4<Float>){
        self.color = color
        super.init(device: device)
    }

    override func buildVertices(){
        let phi: Float = (1 + sqrt(5)) / 2
        var tempVert: [Vertex]!
        var tempInd: [uint16]!

        tempVert = [
            Vertex(position: SIMD3<Float>(-1,  phi,   0),     color: color),
            Vertex(position: SIMD3<Float>( 1,  phi,   0),     color: color),
            Vertex(position: SIMD3<Float>(-1, -phi,   0),     color: color),
            Vertex(position: SIMD3<Float>( 1, -phi,   0),     color: color),
            
            Vertex(position: SIMD3<Float>( 0,  -1,   phi),     color: color),
            Vertex(position: SIMD3<Float>( 0,   1,   phi),     color: color),
            Vertex(position: SIMD3<Float>( 0,  -1,  -phi),     color: color),
            Vertex(position: SIMD3<Float>( 0,   1,  -phi),     color: color),
            
            Vertex(position: SIMD3<Float>( phi,   0,  -1),     color: color),
            Vertex(position: SIMD3<Float>( phi,   0,   1),     color: color),
            Vertex(position: SIMD3<Float>(-phi,   0,  -1),     color: color),
            Vertex(position: SIMD3<Float>(-phi,   0,   1),     color: color),]
               
        tempInd =  [ 0, 11,  5,
                     0,  5,  1,
                     0,  1,  7,
                     0,  7, 10,
                     0, 10, 11,
                    
                     1,  5,  9,
                     5, 11,  4,
                    11, 10,  2,
                    10,  7,  6,
                     7,  1,  8,
                     
                     3,  9,  4,
                     3,  4,  2,
                     3,  2,  6,
                     3,  6,  8,
                     3,  8,  9,
                     
                     4,  9,  5,
                     2,  4, 11,
                     6,  2, 10,
                     8,  6,  7,
                     9,  8,  1  ]
        /*
        tempVert = [
                    Vertex(position: SIMD3<Float>( 1,    1,   1),     color: color),
                    Vertex(position: SIMD3<Float>( 1,   -1,  -1),     color: color),
                    Vertex(position: SIMD3<Float>(-1,    1,  -1),     color: color),
                    Vertex(position: SIMD3<Float>(-1,   -1,   1),     color: color),
    
                    Vertex(position: SIMD3<Float>(-1,   -1,  -1),     color: color),
                    Vertex(position: SIMD3<Float>(-1,    1,   1),     color: color),
                    Vertex(position: SIMD3<Float>( 1,   -1,   1),     color: color),
                    Vertex(position: SIMD3<Float>( 1,    1,  -1),     color: color)]
                    
        tempInd =         [ 0,  1,  2,
                            1,  2,  3,
                            2,  3,  1,
                            3,  1,  0,]*/
        
        for _ in 1...4{
            (tempInd,tempVert) = subdivide(indices: tempInd, vertices: tempVert, color: color)
        }
        
        vertices = tempVert
        indices = tempInd
        
    }
    
    func spherify(vector: SIMD3<Float>) -> SIMD3<Float>{
        let x = vector.x
        let y = vector.y
        let z = vector.z
        let scale : Float = sqrtf(x * x + y * y + z * z)
        
        return (vector/scale)
    }
    
    func subdivide(indices: [uint16], vertices: [Vertex], color: SIMD4<Float>) -> ([uint16],[Vertex]){
        
        var newIndices: [uint16] = []
        var newVertices: [Vertex] = []
        var v1 : Vertex!
        var v2 : Vertex!
        var v3 : Vertex!
        var v4 : Vertex!
        var v5 : Vertex!
        var v6 : Vertex!
        
        for i in 0...(indices.count/3)-1{
            
            let posv1 = spherify(vector: SIMD3<Float>(vertices[Int(indices[i*3    ])].position))
            let posv2 = spherify(vector: SIMD3<Float>(vertices[Int(indices[i*3 + 1])].position))
            let posv3 = spherify(vector: SIMD3<Float>(vertices[Int(indices[i*3 + 2])].position))
            
            v1 = Vertex(position: posv1, color: color, normal: posv1)
            v2 = Vertex(position: posv2, color: color, normal: posv2)
            v3 = Vertex(position: posv3, color: color, normal: posv3)
            
            let posv4 = spherify( vector: (v1.position + v2.position) / 2)
            let posv5 = spherify( vector: (v2.position + v3.position) / 2)
            let posv6 = spherify( vector: (v3.position + v1.position) / 2)
            
            v4 = Vertex(position: posv4, color: color, normal: posv4)
            v5 = Vertex(position: posv5, color: color, normal: posv5)
            v6 = Vertex(position: posv6, color: color, normal: posv6)
            
            let indicestoAppend: [uint16] = [uint16(0+6*i),uint16(5+6*i),uint16(3+6*i),
                                             uint16(3+6*i),uint16(5+6*i),uint16(4+6*i),
                                             uint16(4+6*i),uint16(5+6*i),uint16(2+6*i),
                                             uint16(1+6*i),uint16(3+6*i),uint16(4+6*i)]
            
            newVertices.append(contentsOf: [v1,v2,v3,v4,v5,v6])
            newIndices.append(contentsOf: indicestoAppend)
            
        }
        
        
        return (newIndices,newVertices)
    }
    
}

