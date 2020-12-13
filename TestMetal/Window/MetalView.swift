//
//  MetalView.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-07.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var renderer:Renderer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.colorPixelFormat = .bgra8Unorm
        self.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.depthStencilPixelFormat = .depth32Float
        
        renderer = Renderer(device: device!)
        
        renderer.updateTrackingArea(view: self)
        
        self.delegate = renderer
        
    }
    
    
    func toggleWireFrame(wireFrameON: Bool){
        renderer.toggleWireFrame(wireFrameON: wireFrameON)
    }
    
    override func mouseMoved(with event: NSEvent) {
        let x: Float = Float(event.locationInWindow.x)
        let y: Float = Float(event.locationInWindow.y)
        
        renderer.mousePos = SIMD2<Float>(x,y)
        
    }
    
}
