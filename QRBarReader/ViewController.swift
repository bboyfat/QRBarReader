//
//  ViewController.swift
//  QRBarReader
//
//  Created by Andrey Petrovskiy on 4/1/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var reader: Reader?
    
   
   
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func update(history: History){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyVC") as! HistoryTableViewController
        vc.update(history: history)
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
    
    func saveScan(result: String){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context)
         history.setValue(result, forKey: "result")
         history.setValue(Date(), forKey: "date")
        
        do{
            try context.save()
            if let history = history as? History{
            self.update(history: history )
            }
            print("SAVED")
        } catch let saveErr{
            print("Unnable to Save:", saveErr)
        }
        
    }
    func fetch(fetch: History){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyVC") as! HistoryTableViewController
        vc.fetchData()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.reader?.readerDelegate(output, didOutput: metadataObjects, from: connection)
        
        guard let readebleObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = readebleObject.stringValue else { return }
        
         reader?.previewLayer?.removeFromSuperlayer()
        
        self.saveScan(result: stringValue)
        
        self.codeLabel.text = stringValue
        
       
    }
    

}

