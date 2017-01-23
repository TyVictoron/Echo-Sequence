//
//  GameOverViewController.swift
//  Echo Sequance
//
//  Created by Ty Victorson on 8/25/16.
//  Copyright © 2017 Xision. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class GameOverViewController: UIViewController, GADInterstitialDelegate {

    // Variables
    @IBOutlet weak var highScoreOutlet: UILabel!
    @IBOutlet weak var scoreOutlet: UILabel!
    var highScore = 0
    var score = 0
    var gameOverSound = AVAudioPlayer()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates and loads an ad
        interstitial = createAndLoadAd()
        
        // change high score if current score is higher
        if (score > highScore) {
            highScore = score
        }
        print("HighScore: \(highScore)", "Score: \(score)")
        highScoreOutlet.text = "HighScore: \(highScore)"
        scoreOutlet.text = "Score: \(score)"
        
        // saves high score
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        defaults.synchronize()

        // assign sound and play it
        gameOverSound = self.setupAudioPlayerWithFile("Ooh you almost had it...", type:"mp3")
        gameOverSound.play()
        
        // activate ad
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    // Sound setup
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        let path = Bundle.main.path(forResource: file as String, ofType:type as String)
        let url = URL(fileURLWithPath: path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player not available")
        }
        
        //4
        return audioPlayer!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayVC" {
            let svc = segue.destination as! ViewController
            svc.score = score
            svc.highScore = highScore
        }
    }
    
    // Creates Ads using AdMob site with my own ap unit ID
    func createAndLoadAd() -> GADInterstitial
    {
        let ad = GADInterstitial(adUnitID: "ca-app-pub-5788120822235976/3631116049")
        
        let request = GADRequest()
        
        request.testDevices = ["756b788c48f23c1b559c95e5bd8d9abf"]
        ad.load(request)
        
        return ad
    }
    
    //Interstitial func (Back up func to testing)
    func createAndLoadInterstitial()->GADInterstitial {
        let interstitialM = GADInterstitial(adUnitID: "ca-app-pub-5788120822235976/3631116049")
        interstitialM.delegate = self
        interstitialM.load(GADRequest())
        
        return interstitialM
    }
}
