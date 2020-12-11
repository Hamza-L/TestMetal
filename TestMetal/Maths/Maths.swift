//
//  Maths.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

extension simd_float4x4{
    
    init(perspectiveDegreesFov fov: Float, AspectRatio: Float, NearZ :Float, FarZ: Float){
        //self.init()
        let fovRad = fov*(Float.pi/180)
        var result = matrix_identity_float4x4
        
        let tp : Float = NearZ*tan(fovRad/2)
        let b  : Float = -tp
        let r  : Float = AspectRatio*tp
        let l  : Float = -r
        
        
        self.init()
        result.columns = (  SIMD4<Float>((2*NearZ)/(r-l),               0,        (r+l)/(r-l), 0),
                            SIMD4<Float>(              0,(2*NearZ)/(tp-b),      (tp+b)/(tp-b), 0),
                            SIMD4<Float>(0, 0, (NearZ+FarZ)/(NearZ-FarZ), (2*NearZ*FarZ)/(NearZ-FarZ)),
                            SIMD4<Float>(0, 0, -1, 0)    )
        result = result.transpose
        self = result
       //self = matrix_multiply(self, result)
    }
    
    mutating func scale( axis: SIMD3<Float>){
        var result = matrix_identity_float4x4
        let x = axis.x
        let y = axis.y
        let z = axis.z
        
        result.columns = (SIMD4<Float>(x, 0, 0, 0),
                          SIMD4<Float>(0, y, 0 ,0),
                          SIMD4<Float>(0, 0, z, 0),
                          SIMD4<Float>(0, 0, 0, 1))
        
        result = result.transpose
        
        self = matrix_multiply(self, result)
    
    }
    
    mutating func translate( axis: SIMD3<Float>){
        var result = matrix_identity_float4x4
        
        let x = axis.x
        let y = axis.y
        let z = axis.z
        
        result.columns = (SIMD4<Float>(1, 0, 0, x),
                          SIMD4<Float>(0, 1, 0, y),
                          SIMD4<Float>(0, 0, 1, z),
                          SIMD4<Float>(0, 0, 0, 1))
        
        result = result.transpose
        
        self = matrix_multiply(self, result)
    
    }
    
    mutating func rotate( axis: SIMD3<Float>, angle: Float){
        var result = matrix_identity_float4x4
        
        let c: Float = cos(angle * (Float.pi/180))
        let nc: Float = 1-c
        let s: Float = sin(angle * (Float.pi/180))
        
        let axis_norm: SIMD3<Float> = axis/(sqrt(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z))
        let x: Float = axis_norm.x
        let y: Float = axis_norm.y
        let z: Float = axis_norm.z
        
        
        result.columns = (SIMD4<Float>(c + x * x * nc,      x * y * nc - z * s,     x * z * nc + y * s, 0),
                          SIMD4<Float>(y * x * nc + z * s,  c + y * y * nc,         y * z * nc - x * s, 0),
                          SIMD4<Float>(z * x * nc - y * s,  z * y * nc + x * s,     c + z * z * nc,0),
                          SIMD4<Float>(0, 0, 0, 1))
        
        result = result.transpose
        
        self = matrix_multiply(self, result)
    
    }
    
}
