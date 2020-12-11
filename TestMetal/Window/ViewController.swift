//
//  ViewController.swift
//  TestMetal
//
//  Created by Hamza Lahmimsi on 2020-12-11.
//  Copyright © 2020 Hamza Lahmimsi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var mainMetalView: MetalView!
    
    @IBOutlet weak var chkWireFrame: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func chkWireFrame_Click(_ sender: Any) {
        mainMetalView.toggleWireFrame(wireFrameON: Bool(truncating: chkWireFrame!.state as NSNumber))
    }
    
}
