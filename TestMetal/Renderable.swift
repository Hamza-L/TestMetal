//
//  Renderable.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-10.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

protocol Renderable {
    
    var vertexDescriptor: MTLVertexDescriptor {get }
    var renderPipelineState: MTLRenderPipelineState! {get set}
    var vertexFuncName : String {get set}
    var fragmentFuncName : String {get set}
    
    func draw(commandEncoder: MTLRenderCommandEncoder)

}

extension Renderable {
    func buildPipelineState(device : MTLDevice) -> MTLRenderPipelineState {
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexFuncName)
        let fragmentFunction = library?.makeFunction(name: fragmentFuncName)
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        var renderPipelineState: MTLRenderPipelineState! = nil
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError{
            Swift.print("\(error)")
        }
        
        return renderPipelineState
    }
}
