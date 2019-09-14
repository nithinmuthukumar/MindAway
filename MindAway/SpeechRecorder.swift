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

class LiveTranscribeViewController: UIViewController {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
    var transcriptionOutputLabel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
}

extension LiveTranscribeViewController {
    fileprivate func startRecording() throws {
        mostRecentlyProcessedSegmentDuration = 0
        
        self.transcriptionOutputLabel = ""
        // 1
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        // 2
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        // 3
        audioEngine.prepare()
        try audioEngine.start()
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                self.updateUIWithTranscription(transcription)
            }
        }
    }
    
    fileprivate func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }
    fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
        self.transcriptionOutputLabel = transcription.formattedString
        
        // 2
        if let lastSegment = transcription.segments.last,
            lastSegment.duration > mostRecentlyProcessedSegmentDuration {
            mostRecentlyProcessedSegmentDuration = lastSegment.duration
        }
    }
}


