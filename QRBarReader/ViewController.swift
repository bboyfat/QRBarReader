//
//  ViewController.swift
//  QRBarReader
//
//  Created by Andrey Petrovskiy on 4/1/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var reader: Reader?
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    func handleCode(code: String){
        self.codeLabel.text = code
    }
    @IBAction func startScanBtn(_ sender: Any) {
        self.reader = Reader(withViewController: self, view: self.view, codeOutputHandler: self.handleCode)
        if let reader = self.reader{
            reader.requestCaptureSessionStartRunning()
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.reader?.readerDelegate(output, didOutput: metadataObjects, from: connection)
        
        guard let readebleObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = readebleObject.stringValue else { return }
        
         reader?.previewLayer?.removeFromSuperlayer()
        self.codeLabel.text = stringValue
       
    }
    

}

