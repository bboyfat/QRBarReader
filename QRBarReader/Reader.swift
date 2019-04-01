//
//  Reader.swift
//  QRBarReader
//
//  Created by Andrey Petrovskiy on 4/1/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import UIKit
import AVFoundation

class Reader: NSObject{
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private var codeHandleOutput: (_ code: String) -> Void
    
    var previewLayer: AVCaptureVideoPreviewLayer?
   
    
    private func createCaptureSession() -> AVCaptureSession?{
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{ return nil}
        
        do{
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddInput(deviceInput){
                captureSession.addInput(deviceInput)
            } else {
                return nil
            }
            if captureSession.canAddOutput(metaDataOutput){
                captureSession.addOutput(metaDataOutput)
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate{
                    metaDataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                }
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
        
       return captureSession
    }
    
    
    private func metaObjectTypes() ->[AVMetadataObject.ObjectType]{
        return [
            .qr,
            .code128
            
        ]
    }
    
    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer{
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
    
    func requestCaptureSessionStartRunning(){
        guard let captureSession = self.captureSession else {return}
        if !captureSession.isRunning{
            captureSession.startRunning()
        }
        
    }
    func requestCaptureSessionStopRunning(){
        guard let captureSession = self.captureSession else {return}
        if captureSession.isRunning{
            captureSession.stopRunning()
            
            
        }
    }
    
    
    
    func readerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        requestCaptureSessionStopRunning()
        
        
        
    }
    
    
    init(withViewController viewCotroller: UIViewController, view: UIView, codeOutputHandler: @escaping(String) -> Void){
        self.viewController = viewCotroller
        self.codeHandleOutput = codeOutputHandler
        
        super.init()
        
        if let captureSession = self.createCaptureSession(){
            self.captureSession = captureSession
            
            self.previewLayer = self.createPreviewLayer(withCaptureSession: captureSession, view: view)
            view.layer.addSublayer(previewLayer!)
        }
        
    }
}
