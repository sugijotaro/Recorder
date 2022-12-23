//
//  ViewController.swift
//  Recorder
//
//  Created by JotaroSugiyama on 2022/12/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func record(){
        if !isRecording {

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            isRecording = true

            label.text = "録音中"
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false

        }else{

            audioRecorder.stop()
            isRecording = false

            label.text = "待機中"
            recordButton.setTitle("RECORD", for: .normal)
            playButton.isEnabled = true

        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    @IBAction func play(){
        if !isPlaying {

            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()

            isPlaying = true

            label.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false

        }else{

            audioPlayer.stop()
            isPlaying = false

            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true

        }
    }
    
}

