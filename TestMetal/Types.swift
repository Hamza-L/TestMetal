//
//  Types.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-07.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

struct Vertex{
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

struct ModelConstants{
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstants{
    var projectionMatrix = matrix_identity_float4x4
}

struct Light{
    var lightPos = SIMD3<Float>(repeating: 0)
}
