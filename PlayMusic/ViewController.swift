//
//  ViewController.swift
//  PlayMusic
//
//  Created by Nguyễn Văn Tuấn on 2/13/17.
//  Copyright © 2017 Nguyễn Văn Tuấn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audio = AVAudioPlayer()
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var slider: UISlider!
    var isMusicOn = true
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var maxDuration: UILabel!
    @IBOutlet weak var slider_Duration: UISlider!
    @IBOutlet weak var sw_Loop: UISwitch!
    
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: ".mp3")!))
        audio.prepareToPlay()
        addThumbImageForSlider()
        
        slider_Duration.maximumValue = Float(audio.duration)
        fortmatTime(minu: Int(audio.duration / 60), sec: Int(audio.duration.truncatingRemainder(dividingBy: 60)), label: maxDuration)
        sw_Loop.setOn(false, animated: true)
        audio.delegate = self
        }
    
    @IBAction func slider_CurrentTime(_ sender: UISlider) {
        audio.currentTime = TimeInterval(sender.value)
    }

    @IBAction func acc_Play(_ sender: UIButton) {
        if isMusicOn {
            audio.play()
            btn_Play.setBackgroundImage(UIImage(named: "pause.png"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            
        }else{
            audio.pause()
            btn_Play.setBackgroundImage(UIImage(named: "play.png"), for: .normal)
        }
        isMusicOn = !isMusicOn
    }
    
    @IBAction func acc_ChangeVolumn(_ sender: UISlider) {
        audio.volume = sender.value
    }
    
    func UpdateTime() {
        let minu: Int = Int(audio.currentTime / 60)
        let sec: Int = Int(audio.currentTime.truncatingRemainder(dividingBy: 60))

        fortmatTime(minu: minu, sec: sec, label: duration)
        
        let minu2: Int = Int((audio.duration - audio.currentTime) / 60)
        let sec2 = Int(audio.duration - audio.currentTime) % 60
        fortmatTime(minu: minu2, sec: sec2, label: maxDuration)

        slider_Duration.value = Float(audio.currentTime)

    }
    
    func fortmatTime(minu: Int, sec: Int, label: UILabel) {
        if (sec < 10 && minu < 10){
            label.text = "0\(minu):0\(sec) "
            
        }else{
            if sec < 10 {
                label.text = "\(minu):0\(sec) "
            } else if minu < 10 {
                label.text = "0\(minu):\(sec) "
            }else{
                label.text = "\(minu):\(sec) "
            }
            
        }
    }
    
    func addThumbImageForSlider()
    {
        slider.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        slider.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if audio.numberOfLoops == 0 {
            btn_Play.setBackgroundImage(UIImage(named: "play.png"), for: .normal)
            isMusicOn = !isMusicOn
        }
    }
    
    @IBAction func sld_switch(_ sender: UISwitch) {
        if sender.isOn {
            audio.numberOfLoops = -1
        }else{
            audio.numberOfLoops = 0
        }
    }




}

