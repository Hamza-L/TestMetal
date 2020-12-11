//
//  VertexShader.metal
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-07.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    simd_float3 position [[ attribute(0)]];
    simd_float4 color [[ attribute(1)]];
};

struct VertexOut {
    simd_float4 position [[ position ]];
    simd_float4 color;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

struct SceneConstants{
    float4x4 PerspectiveMatrix;
};


vertex VertexOut basic_vertex_function(const VertexIn vIn [[  stage_in ]],
                                       constant ModelConstants &modelConstants [[ buffer(1) ]],
                                       constant SceneConstants &sceneConstants [[ buffer(2) ]]){
    
    VertexOut vOut;
    vOut.position = sceneConstants.PerspectiveMatrix * modelConstants.modelMatrix*simd_float4(vIn.position,1);
    vOut.color = vIn.color *1;
    
    return vOut;
}

fragment simd_float4 basic_fragment_function( VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}

