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
    
    var mousePos = SIMD2<Float>(0,0)
    var width: Float!
    var height: Float!
    
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
        updateTrackingArea(view: view)
    }
    
    func updateTrackingArea(view: MTKView){
        let area = NSTrackingArea(rect: view.bounds,
                                  options: [NSTrackingArea.Options.activeAlways,NSTrackingArea.Options.mouseMoved,NSTrackingArea.Options.enabledDuringMouseDrag],
                                  owner: view,
                                  userInfo: nil)
        view.addTrackingArea(area)
        self.width = Float(view.bounds.width)
        self.height = Float(view.bounds.height)
        
    }
    
   
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder!.setDepthStencilState(depthStencilState)
        
        if(wireFrameON){
            commandEncoder?.setTriangleFillMode( .lines )
            
        }
        
        let mousePos = MetalView.getMousePosition()
        let posX: Float = Float(mousePos.x/width - 0.5)*4
        let posY: Float = Float(mousePos.y/height - 0.5)*4
        
        scene.light.lightPos = SIMD3<Float>(posX,posY,-2.4)
        
        //print(scene.light.lightPos)
               
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
 }
