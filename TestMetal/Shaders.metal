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
    simd_float3 normal [[ attribute(2)]];
    //simd_float3 posMod [[ position ]];
};

struct VertexOut {
    simd_float4 position [[ position ]];
    simd_float4 color;
    simd_float3 normal;
    simd_float4 posMod;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

struct SceneConstants{
    float4x4 PerspectiveMatrix;
};

struct Light{
    float3 lightPos;
    float4 color;
    float diffIntensity;
    float specIntensity;
    float shinniness;
};


vertex VertexOut basic_vertex_function(const VertexIn vIn [[  stage_in ]],
                                       constant ModelConstants &modelConstants [[ buffer(1) ]],
                                       constant SceneConstants &sceneConstants [[ buffer(2) ]]){
    
    VertexOut vOut;
    simd_float4 norm = (modelConstants.modelMatrix * simd_float4(vIn.normal,0));
    
    vOut.position = sceneConstants.PerspectiveMatrix * modelConstants.modelMatrix * simd_float4(vIn.position,1);
    vOut.posMod = modelConstants.modelMatrix * simd_float4(vIn.position,1);
    vOut.color = vIn.color;
    vOut.normal = normalize(norm.xyz);
    
    return vOut;
}

fragment simd_float4 basic_fragment_function( VertexOut vIn [[ stage_in ]],
                                             constant Light &light [[ buffer(1) ]]){
    
    simd_float3 lightvec = light.lightPos - vIn.posMod.xyz;
    simd_float3 viewDir = simd_float3(0,0,0) - vIn.posMod.xyz;
    lightvec = normalize(lightvec);
    viewDir = normalize(viewDir);
    simd_float3 h = normalize(viewDir + lightvec);
    
    float diffuse = light.diffIntensity * max(dot(vIn.normal, lightvec),0.0);
    float specular = light.specIntensity * max(dot(vIn.normal, h), 0.0);
    
    if (diffuse == 0) {
        specular = 0;
    } else {
        specular = pow(specular,light.shinniness);
    }
    
    simd_float4 scatteredLight = specular * vIn.color * light.color;
    simd_float4 diffuseLight = diffuse * vIn.color * light.color;
    simd_float4 ambient = 0.2 * vIn.color;
    
    
    return min(scatteredLight + diffuseLight + ambient,simd_float4(1,1,1,1));
}

