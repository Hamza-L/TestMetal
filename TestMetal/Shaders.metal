//
//  VertexShader.metal
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-07.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex_function(){
    return float4(1);
}

fragment float4 basic_fragment_function(){
    return float4(1);
}

