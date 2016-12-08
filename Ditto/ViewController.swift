//
//  ViewController.swift
//  Echo Sequance
//
//  Created by Ty Victorson on 8/23/16.
//  Copyright © 2016 Xision. All rights reserved.
//

/*
 1. my strengths with the creation of this app was my previous experiance and knowlege of swift and doing some on my own
 2. I need to work on asking others for help when I am stuck like on the counter play back
 3. I learned how ot overlap sounds correctly and how to use timers to play back a array with animations
 4. I am publishing ths app under "Echo Sequance", go ahead and download when it comes out :)
 5. I spent about 11 hours in and out of school
 6. I think as is the project is pretty good (Thumbs Up)
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var oneButtonOutlet: UIButton!
    @IBOutlet weak var twoButtonOutlet: UIButton!
    @IBOutlet weak var threeButtonOutlet: UIButton!
    @IBOutlet weak var fourButtonOutlet: UIButton!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var byTy: UILabel!
    
    // variables declared
    var pattern = [Int]()
    var playerPattern = [Int]()
    var random = Int(arc4random_uniform(4))
    var i = 0
    var highScore = 0
    var score = 0
    var oneNote = AVAudioPlayer()
    var twoNote = AVAudioPlayer()
    var threeNote = AVAudioPlayer()
    var fourNote = AVAudioPlayer()
    var backgroundMusic = AVAudioPlayer()
    var timer = Timer()
    
    var incramentedNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retreves saves score from the device
        let defaults: UserDefaults = UserDefaults.standard
        let savedScore = defaults.integer(forKey: "highScore")
        highScore = savedScore
        
        // Set up sounds
        oneNote = self.setupAudioPlayerWithFile("oneNote", type:"mp3")
        twoNote = self.setupAudioPlayerWithFile("twoNote", type:"mp3")
        threeNote = self.setupAudioPlayerWithFile("threeNote", type:"mp3")
        fourNote = self.setupAudioPlayerWithFile("fourNote", type:"mp3")
        backgroundMusic = self.setupAudioPlayerWithFile("ES-Main Theme", type:"wav")
        
        backgroundMusic.play()
        backgroundMusic.numberOfLoops = -1
    }
    
    // buttons calling check function with corrisponding number as input
    @IBAction func onnButton(_ sender: UIButton) {
        CheckForCorrect(0)
        
        // Animates the button to dissabear and reapear
        UIView.animate(withDuration: 0.2, animations: {
            self.oneButtonOutlet.alpha = 0
            self.oneButtonOutlet.alpha = 1
        })
        
        // play sound
        playSound(0)
    }
    
    @IBAction func twoButton(_ sender: UIButton) {
        CheckForCorrect(1)
        
        // Animates the button to dissabear and reapear
        UIView.animate(withDuration: 0.2, animations: {
            self.twoButtonOutlet.alpha = 0
            self.twoButtonOutlet.alpha = 1
        })
        
        // play sound
        playSound(1)
    }
    
    @IBAction func threeButton(_ sender: UIButton) {
        CheckForCorrect(2)
        
        // Animates the button to dissabear and reapear
        UIView.animate(withDuration: 0.2, animations: {
            self.threeButtonOutlet.alpha = 0
            self.threeButtonOutlet.alpha = 1
        })
        
        // play sound
        playSound(2)
    }
    
    @IBAction func fourButton(_ sender: UIButton) {
        CheckForCorrect(3)
        
        // Animates the button to dissabear and reapear
        UIView.animate(withDuration: 0.2, animations: {
            self.fourButtonOutlet.alpha = 0
            self.fourButtonOutlet.alpha = 1
        })
        
        // play sound
        playSound(3)
    }
    
    // Checks to see if player correctly matched the pattern else ends game
    func CheckForCorrect(_ num : Int) {
        playerPattern.append(num)
        if (pattern.count == 0) {
            print("Nothing in the arrray!")
            return
        }
        
        if (playerPattern[i] == pattern[i]) {
            i += 1
            if (i == pattern.count) {
                playerPattern = []
                GenerateRandomNum()
                pattern.append(random)
                print(pattern)
                i = 0
                score = pattern.count
                incramentedNum = 0
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
            }
        }
        else {
            print("GAME OVER!")
            score = pattern.count
            
            //passes the data over to the gameover view without story board sugue
            let svc = self.storyboard?.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverViewController
            svc.score = score
            svc.highScore = highScore
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    // Generates Number 0 - 3 and assigns it to the "random" variable
    func GenerateRandomNum() {
        random = Int(arc4random_uniform(4))
    }
    
    func update() {
        if (incramentedNum < pattern.count) {
            if (pattern[incramentedNum] == 0) {
                UIView.animate(withDuration: 0.25, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.oneButtonOutlet.alpha = 0
                    self.oneButtonOutlet.alpha = 1
                    }, completion: nil)
                playSound(0)
            }
            else if (pattern[incramentedNum] == 1) {
                UIView.animate(withDuration: 0.25, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.twoButtonOutlet.alpha = 0
                    self.twoButtonOutlet.alpha = 1
                    }, completion: nil)
                playSound(1)
            }
            else if (pattern[incramentedNum] == 2) {
                UIView.animate(withDuration: 0.25, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.threeButtonOutlet.alpha = 0
                    self.threeButtonOutlet.alpha = 1
                    }, completion: nil)
                playSound(2)
            }
            else if (pattern[incramentedNum] == 3) {
                UIView.animate(withDuration: 0.25, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.fourButtonOutlet.alpha = 0
                    self.fourButtonOutlet.alpha = 1
                    }, completion: nil)
                playSound(3)
            }
            incramentedNum += 1
        }
        else {
            // stops the timer
            timer.invalidate()
        }
    }
    
    // called when the player presses the start button
    @IBAction func startButton(_ sender: UIButton) {
        
        // hide this and game name
        startButtonOutlet.isHidden = true
        gameName.isHidden = true
        byTy.isHidden = true
        
        // adds first number to the pattern
        pattern.append(random)
        print(pattern)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: false)
        
        backgroundMusic.stop()
        
        playerPattern = [Int]()
    }
    
    // plays sounds (alows for overlap)
    func playSound(_ num: Int){
        
        if num == 0{
            if oneNote.isPlaying == false{
                oneNote.prepareToPlay()
                oneNote.play()
            }
            else{
                oneNote.stop()
                oneNote.currentTime = 0
                oneNote.prepareToPlay()
                oneNote.play()
            }
        }
        else if num == 1{
            if twoNote.isPlaying == false{
                twoNote.prepareToPlay()
                twoNote.play()
            }
            else{
                twoNote.stop()
                twoNote.currentTime = 0
                twoNote.prepareToPlay()
                twoNote.play()
            }
            
        }
        else if num == 2{
            if threeNote.isPlaying == false{
                threeNote.prepareToPlay()
                threeNote.play()
            }
            else{
                threeNote.stop()
                threeNote.currentTime = 0
                threeNote.prepareToPlay()
                threeNote.play()
            }
        }
        else if num == 3{
            if fourNote.isPlaying == false{
                fourNote.prepareToPlay()
                fourNote.play()
            }
            else{
                fourNote.stop()
                fourNote.currentTime = 0
                fourNote.prepareToPlay()
                fourNote.play()
            }
        }
    }
    
    // Sound setup (condenced to not have repeated code in each function) ***Taken from stack overflow***
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        // 1
        let path = Bundle.main.path(forResource: file as String, ofType:type as String)
        let url = URL(fileURLWithPath: path!)
        
        // 2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player not available")
        }
        
        // 4
        return audioPlayer!
    }
}

