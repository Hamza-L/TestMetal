 //
//  Renderer.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-07.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

 class Renderer:NSObject  {
    
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var vertices: [Vertex]!
    var indices: [uint16]!
    
    var constants = Constants()
     
    init(device: MTLDevice){
        super.init()
        
        buildCommandQueue(device: device)
        buildPipelineState(device: device)
        buildVertices()
        buildBuffers(device: device)
    }
    
    func buildCommandQueue(device : MTLDevice){
        commandQueue = device.makeCommandQueue()
    }
    
    func buildPipelineState(device : MTLDevice){
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        
        //describing how to descripe the vertex for the shader in metal (it knows nothing). These refer to the attributes in the shader.
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.size
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError{
            Swift.print("\(error)")
        }
    }
    
    func buildVertices(){
        
        let size: Float = 0.5
        
        vertices = [
            Vertex(position: size*SIMD3<Float>( 1,  1,  0), //v1
                   color: SIMD4<Float>(1,  1,  0,  1)),
            
            Vertex(position: size*SIMD3<Float>(-1, 1,  0),  //v2
                   color: SIMD4<Float>(0,  1,  1,  1)),
            
            Vertex(position: size*SIMD3<Float>( 1,  -1,  0), //v3
                   color: SIMD4<Float>(1,  1,  0,  1)),
            
            Vertex(position: size*SIMD3<Float>( -1,  -1,  0), //v4
                   color: SIMD4<Float>(0,  1,  1,  1)),
        ]
        
        indices = [0,1,2,3]
    }
    
    func buildBuffers(device : MTLDevice){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<uint16>.stride * indices.count, options: [])
        
    }
    
 }

 extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        constants.animateBy += deltaTime;
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1) //0 has already been used
         //command encoder stuff
        
        //commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.drawIndexedPrimitives(type: .triangleStrip, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
 }
