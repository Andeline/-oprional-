//
//  ViewController.swift
//  骰子比大小（進階題：壓大壓小）
//
//  Created by 蔡佳穎 on 2021/4/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var diceImageViews: [UIImageView]!
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var winOrLoseTextField: UITextField!
    @IBOutlet weak var totalAssetsTextField: UITextField!
    @IBOutlet weak var totalPointLabel: UILabel!
    
    @IBOutlet weak var betBigBtn: UIButton!
    @IBOutlet weak var betSmallBtn: UIButton!
    @IBOutlet weak var addValueBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    let player = AVPlayer()
    let imageViewNames = ["die.face.1.fill", "die.face.2.fill", "die.face.3.fill", "die.face.4.fill", "die.face.5.fill", "die.face.6.fill"]
    var dicePoint = 0
    var totalPoint = 0
    var totalAssets = 1000
    var wagerText: String = "\(0)"
    var bigOrSmall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wagerTextField.text = wagerText
    }
    
    func winSoundEffect() {
        let fileUrl = Bundle.main.url(forResource: "Yayyy", withExtension: "mp3")
        let playerItem = AVPlayerItem(url: fileUrl!)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func loseSoundEffect() {
        let fileUrl = Bundle.main.url(forResource: "Crowd Aww", withExtension: "mp3")
        let playerItem = AVPlayerItem(url: fileUrl!)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func getDicePoint() {
        for dice in diceImageViews {
            dicePoint = Int.random(in: 1...6)
            dice.image = UIImage(systemName: imageViewNames[dicePoint-1])
            totalPoint += dicePoint
            totalPointLabel.text = "\(totalPoint)"
        }
    }
    
    func winBet() {
        winSoundEffect()
        totalAssets += Int(wagerText)!
        totalAssetsTextField.text = "\(totalAssets)"
        winOrLoseTextField.text = "+" + wagerText
    }
    
    func loseBet() {
        loseSoundEffect()
        totalAssets -= Int(wagerText)!
        totalAssetsTextField.text = "\(totalAssets)"
        winOrLoseTextField.text = "-" + wagerText
    }
    
    //加值
    @IBAction func addValueBtn(_ sender: UIButton) {
        totalAssets += 1000
        totalAssetsTextField.text = "\(totalAssets)"
    }
    @IBAction func betBigOrSmall(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            bigOrSmall = "big"
        case 1:
            bigOrSmall = "small"
        default:
            break
        }
    }
    @IBAction func play(_ sender: UIButton) {
       //傳入使用者下注金額
        wagerText = "\(wagerTextField.text!)"
        let wager = Int(wagerText)
        
        //如果wager是有值
        if wager != nil {
            //優先判斷資產是否足夠下注
            if totalAssets < wager! {
                winOrLoseTextField.text = "額度不足"
            } else if wager! == 0 {
                winOrLoseTextField.text = "輸入下注金"
            } else {
                getDicePoint()
                if totalPoint >= 10{
                    if bigOrSmall == "big" {
                        winBet()
                    } else {
                        loseBet()
                    }
                } else {
                    if bigOrSmall == "small" {
                        winBet()
                    } else {
                        loseBet()
                    }
                }
            }
            //play一次後點數歸零
            totalPoint = 0
        } else {
            //如果wager是無值
            winOrLoseTextField.text = "輸入下注金"
        }
    }
}

