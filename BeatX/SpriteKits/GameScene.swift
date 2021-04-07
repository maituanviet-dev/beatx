//
//  GameScene.swift
//  StepUpGame
//
//  Created by Tuấn Việt on 13/03/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let faded = SKTransition.fade(with: .black, duration: 1)
    var buttonUp: MSButtonNodeCustom!
    var buttonDown: MSButtonNodeCustom!
    var buttonLeft: MSButtonNodeCustom!
    var buttonRight: MSButtonNodeCustom!
    var arrayButtonUp: Array<Step> = []
    var arrayButtonDown: Array<Step> = []
    var arrayButtonLeft: Array<Step> = []
    var arrayButtonRight: Array<Step> = []
    var level: Int = 1
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    var miss = 0
    var cool = 0
    var great = 0
    var perfect = 0
    var combo = 0
    var customBg: Int!
    var timer: Timer!
    var black_background: SKSpriteNode!
    var popup: SKSpriteNode!
    var realPaused: Bool = false {
        didSet {
            self.isPaused = realPaused
        }
    }
    override var isPaused: Bool {
        didSet {
            if (self.isPaused == false && self.realPaused == true) {
                self.isPaused = true
            }
        }
    }
    var timeBar: SKSpriteNode!
    var customGame = false
    var soundTouch = SKAction.playSoundFileNamed("touchSong.mp3", waitForCompletion: true)
    var currentScore = 0
    override func didMove(to view: SKView) {
        registerBroastcast()
        buttonUp = self.childNode(withName: "buttonUp") as? MSButtonNodeCustom
        buttonDown = self.childNode(withName: "buttonDown") as? MSButtonNodeCustom
        buttonLeft = self.childNode(withName: "buttonLeft") as? MSButtonNodeCustom
        buttonRight = self.childNode(withName: "buttonRight") as? MSButtonNodeCustom
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        timeBar = self.childNode(withName: "timeBar") as? SKSpriteNode
        let levelLabel = self.childNode(withName: "levelLabel") as? SKLabelNode
        let background = self.childNode(withName: "background") as? SKSpriteNode
        let ic_pause = self.childNode(withName: "ic_pause") as? MSButtonNode
        black_background = self.childNode(withName: "black_background") as? SKSpriteNode
        popup = self.childNode(withName: "popup") as? SKSpriteNode
        let resumeButton = popup.childNode(withName: "resumeButton") as? MSButtonNode
        let backToHomeButton = popup.childNode(withName: "backToHomeButton") as? MSButtonNode
        //handler pop up
        resumeButton?.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.resume) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.resume()
                }
            }
            else {
                self.resume()
            }
        }
        
        backToHomeButton?.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.back_home) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.backToHome()
                }
            }
            else {
                self.backToHome()
            }
        }
        
        // add background music
        if let customBg = self.customBg {
            addChild(SKAudioNode(fileNamed: "song\(customBg).mp3"))
        } else {
            addChild(SKAudioNode(fileNamed: "song\(level <= 8 ? level : (level % 8)).mp3"))
        }
        //
        levelLabel?.text = "Level: \(level)"
        updateScoreLabel()
        self.spawnStepUp()
        //next level

        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let timeBar = self.timeBar else {
                return
            }
            if (timeBar.size.width > 0 ) {
                timeBar.size = CGSize(width: timeBar.size.width - 5.0, height: 16)
            } else {
                self.nextLevel()
            }
        }
        let scaleAnimation = SKAction.scale(to: 2.5, duration: 0.3)
        let blurAnimation = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
        //background Handler
        if (customGame) {
            background?.texture = SKTexture(imageNamed: "background\(String(customBg))")
        } else {
            background?.texture = SKTexture(imageNamed: "background\(level <= 8 ? level : level % 8)")
        }
        
        ic_pause?.selectedHandler = {
            self.paused()
        }
        
        buttonUp.selectedHandler = {
            for item in self.arrayButtonUp {
                if (item.position.y < -300 && item.position.y > -420) {
                    if (item.position.y < -350 && item.position.y > -370) {
                        self.scoreUp(score: 25)
                    } else if (item.position.y < -320 && item.position.y > -400) {
                        self.scoreUp(score: 15)
                    } else {
                        self.scoreUp(score: 5)
                    }
                    
                    item.removeAllActions()
                    self.arrayButtonUp.removeFirst()
                    item.run(SKAction.group([scaleAnimation, blurAnimation])) {
                        item.removeFromParent()
                    }
                }
            }
        }
        buttonDown.selectedHandler = {
            for item in self.arrayButtonDown {
                if (item.position.y < -300 && item.position.y > -420) {
                    if (item.position.y < -350 && item.position.y > -370) {
                        self.scoreUp(score: 25)
                    } else if (item.position.y < -320 && item.position.y > -400) {
                        self.scoreUp(score: 15)
                    } else {
                        self.scoreUp(score: 5)
                    }
                    item.removeAllActions()
                    self.arrayButtonDown.removeFirst()
                    item.run(SKAction.group([scaleAnimation, blurAnimation])) {
                        item.removeFromParent()
                    }
                }
            }
        }
        buttonLeft.selectedHandler = {
            for item in self.arrayButtonLeft {
                if (item.position.y < -300 && item.position.y > -420) {
                    if (item.position.y < -350 && item.position.y > -370) {
                        self.scoreUp(score: 25)
                    } else if (item.position.y < -320 && item.position.y > -400) {
                        self.scoreUp(score: 15)
                    } else {
                        self.scoreUp(score: 5)
                    }
                    item.removeAllActions()
                    self.arrayButtonLeft.removeFirst()
                    item.run(SKAction.group([scaleAnimation, blurAnimation])) {
                        item.removeFromParent()
                    }
                }
            }
        }
        buttonRight.selectedHandler = {
            for item in self.arrayButtonRight {
                if (item.position.y < -300 && item.position.y > -420) {
                    if (item.position.y < -350 && item.position.y > -370) {
                        self.scoreUp(score: 25)
                    } else if (item.position.y < -320 && item.position.y > -400) {
                        self.scoreUp(score: 15)
                    } else {
                        self.scoreUp(score: 5)
                    }
                    item.removeAllActions()
                    self.arrayButtonRight.removeFirst()
                    item.run(SKAction.group([scaleAnimation, blurAnimation])) {
                        item.removeFromParent()
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    private func registerBroastcast() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnteredBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc func appEnteredBackground(_ notification:NSNotification) {
        self.paused()
    }
}

extension GameScene {
    func updateScoreLabel () {
        guard let scoreLabel = scoreLabel else {
            return
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        let formattedScore = formatter.string(from: score as NSNumber) ?? "0"
        scoreLabel.text = "\(formattedScore)"
    }
    func scoreUp(score: Int) {
        self.score += score
        switch score {
        case 25:
            perfect += 1
            combo += 1
            if (combo >= 2) {
                self.score += 10 * combo
                self.addChild(LabelGame(name: "Perfect x \(combo)", textColor: UIColor(red: 0.7, green: 0.63, blue: 0.91, alpha: 1.0)))
            } else {
                self.addChild(LabelGame(name: "Perfect", textColor: UIColor(red: 0.7, green: 0.63, blue: 0.91, alpha: 1.0)))
            }
        case 15:
            combo = 0
            great += 1
            self.addChild(LabelGame(name: "Great", textColor: .green))
        case 5:
            combo = 0
            cool += 1
            self.addChild(LabelGame(name: "Cool", textColor: UIColor(red: 0.19, green: 0.56, blue: 0.89, alpha: 1.0)))
        default:
            print("Score Up")
        }
        self.playSound(sound: self.soundTouch)
    }
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    func scoreDown() {
        self.addChild(LabelGame(name: "Miss", textColor: .red))
        miss += 1
        combo = 0
    }
    func createStepUp() {
        var speedTime = self.frame.size.height / (150 + CGFloat(self.level) * 20);
        if (speedTime < 0.2) {
            speedTime = 0.2
        }
        switch Int(arc4random() % 100) {
         case 0...25:
            let step = Step(name: "arrow_left_move");
            let removeAction = SKAction.run {
                if (self.arrayButtonLeft.count != 0) {
                self.arrayButtonLeft.removeFirst()
                self.scoreDown()
                }
            }
            step.position = CGPoint(x:  -165, y: self.frame.height/2)
            let moveTo = SKAction.moveTo(y: -self.frame.height/2 - step.frame.height/2, duration: TimeInterval(speedTime))
            step.run(.repeatForever(.sequence([moveTo, .removeFromParent(), removeAction])))
            arrayButtonLeft.append(step)
            addChild(step)
        case 25...50:
           let step = Step(name: "arrow_down_move");
            let removeAction = SKAction.run {
                if (self.arrayButtonDown.count != 0) {
                self.arrayButtonDown.removeFirst()
                self.scoreDown()
                }
            }
           step.position = CGPoint(x:  56, y: self.frame.height/2)
           let moveTo = SKAction.moveTo(y: -self.frame.height/2 - step.frame.height/2, duration: TimeInterval(speedTime))
           step.run(.repeatForever(.sequence([moveTo, .removeFromParent(), removeAction])))
            arrayButtonDown.append(step)
           addChild(step)
        case 50...75:
           let step = Step(name: "arrow_right_move");
            let removeAction = SKAction.run {
                if (self.arrayButtonRight.count != 0) {
                    self.arrayButtonRight.removeFirst()
                    self.scoreDown()
                }
            }
           step.position = CGPoint(x:  165, y: self.frame.height/2)
           let moveTo = SKAction.moveTo(y: -self.frame.height/2 - step.frame.height/2, duration: TimeInterval(speedTime))
           step.run(.repeatForever(.sequence([moveTo, .removeFromParent(), removeAction])))
           arrayButtonRight.append(step)
           addChild(step)
        case 75...100:
           let step = Step(name: "arrow_up_move");
            let removeAction = SKAction.run {
                if (self.arrayButtonUp.count != 0) {
                    self.arrayButtonUp.removeFirst()
                    self.scoreDown()
                }
            }
           step.position = CGPoint(x:  -56, y: self.frame.height/2)
           let moveTo = SKAction.moveTo(y: -self.frame.height/2 - step.frame.height/2, duration: TimeInterval(speedTime))
            step.run(.repeatForever(.sequence([moveTo, .removeFromParent(), removeAction ])))
            arrayButtonUp.append(step)
           addChild(step)
         default:
             break
         }
    }

    func spawnStepUp() {
        var density: Double = 2.0 - (Double(level) * 0.15)
        if (density < 0.2) {
            density = 0.2
        }
        
        run(.repeatForever(.sequence([
            .wait(forDuration: density),
             .run { [weak self] in
                switch Int(arc4random() % 100) {
                case 0...50:
                    self?.createStepUp()
                case 50...90:
                    self?.createStepUp()
                    self?.createStepUp()
                case 90...100:
                    self?.createStepUp()
                    self?.createStepUp()
                    self?.createStepUp()
                default:
                    self?.createStepUp()
                }
             }
         ])))
    }
    
    func nextLevel() {
        self.timer.invalidate()
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = NextLevelGap(fileNamed: "NextLevelGap")!
        scene.level = level
        scene.score = score
        scene.cool = cool
        scene.great = great
        scene.perfect = perfect
        scene.miss = miss
        scene.customGame = self.customGame
        scene.currentScore = self.currentScore
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    
    func backToHome() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = MainMenu(fileNamed: "MainMenu")!
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    
    func paused() {
        self.black_background.alpha = 0.7
        self.popup.alpha = 1.0
        self.realPaused = true
        self.timer.invalidate()
    }
    
    func resume() {
        self.black_background.alpha = 0.0
        self.popup.alpha = 0.0
        self.realPaused = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let timeBar = self.timeBar else {
                return
            }
            if (timeBar.size.width > 0 ) {
            timeBar.size = CGSize(width: timeBar.size.width - 5.0, height: 16)
            } else {
                self.nextLevel()
            }
        }
    }
}
