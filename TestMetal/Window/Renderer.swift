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
    
    var depthStencilState: MTLDepthStencilState!
    
    var scene: BasicScene!
     
    var wireFrameON: Bool = false
    
    init(device: MTLDevice){
        super.init()
        commandQueue = device.makeCommandQueue()
        self.scene = BasicScene(device: device)
        buildDepthStencilState(device: device)
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less //which one first.
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func toggleWireFrame(wireFrameON: Bool){
        self.wireFrameON = wireFrameON
    }
 }

 extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.aspectRatio = Float(Float(view.bounds.width)/Float(view.bounds.height))
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder!.setDepthStencilState(depthStencilState)
        
        if(wireFrameON){
            commandEncoder?.setTriangleFillMode( .lines )
        }
       
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
 }
