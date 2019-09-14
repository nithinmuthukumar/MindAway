//
//  SpeechRecorder.swift
//  MindAway
//
//  Created by nithin muthukumar on 2019-09-14.
//  Copyright © 2019 nithin muthukumar. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation
import Speech

class SpeechRecorder: UIViewController,SFSpeechRecognizerDelegate {
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func micTapped(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        micButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.micButton.isEnabled = isButtonEnabled
            }
        }
    }
}

