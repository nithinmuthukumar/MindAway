//
//  ViewController.swift
//  MindAway
//
//  Created by nithin muthukumar on 2019-09-14.
//  Copyright © 2019 nithin muthukumar. All rights reserved.
//
//
import UIKit
import AVFoundation

class ViewController : UIViewController {
    @IBOutlet weak var StationName: UITextField!
    @IBAction func Record(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad(){
        SpeechRecorder()
    
    }
}
