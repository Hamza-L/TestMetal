//
//  Primitive.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-09.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class Primitive: Node{
       
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexFuncName : String
    var fragmentFuncName : String
    
    // to comform to renderable
    var vertexDescriptor: MTLVertexDescriptor{
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.size
        
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].offset = MemoryLayout<simd_float3>.size + MemoryLayout<simd_float4>.size
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
    

    
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var vertices: [Vertex]!
    var indices: [uint16]!
    
    var modelConstants = ModelConstants()
    
    init (device: MTLDevice){
        vertexFuncName = "basic_vertex_function"
        fragmentFuncName = "basic_fragment_function"
        super.init()
        buildVertices()
        buildBuffers(device: device)
        renderPipelineState = buildPipelineState(device: device)
        
    }
    
    
    
    func buildVertices(){}
    
    func buildBuffers(device : MTLDevice){
           vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
           indexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<uint16>.stride * indices.count, options: [])
           
       }
    
}

extension Primitive: Renderable {
    
    func draw(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(renderPipelineState)
        
        modelConstants.modelMatrix = modelMatrix
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                              indexCount: indices.count,
                                              indexType: .uint16,
                                              indexBuffer: indexBuffer,
                                              indexBufferOffset: 0)
    }
}
