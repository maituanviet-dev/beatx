//
//  Custom.swift
//  StepUpGame
//
//  Created by Tuấn Việt on 14/03/2021.
//
import SpriteKit

class CustomGame: SKScene {
    let faded = SKTransition.fade(with: .black, duration: 1)
    var modeButtonRight: MSButtonNode!
    var modeButtonLeft: MSButtonNode!
    var LabelMode: SKLabelNode!
    var modeArray = ["Easy", "Normal", "Hard"]
    var songArray = ["BG_circle_1", "BG_circle_2", "BG_circle_3", "BG_circle_4","BG_circle_5","BG_circle_6","BG_circle_7","BG_circle_8","BG_circle_9"]
    var selectedMode = 0
    var selectedSong = 0
    override func didMove(to view: SKView) {
        let startButton = self.childNode(withName: "startButton") as? MSButtonNode
        modeButtonRight = self.childNode(withName: "modeButtonRight") as? MSButtonNode
        modeButtonLeft = self.childNode(withName: "modeButtonLeft") as? MSButtonNode
        let songButtonRight = self.childNode(withName: "songButtonRight") as? MSButtonNode
        let songButtonLeft = self.childNode(withName: "songButtonLeft") as? MSButtonNode
        var songImage = self.childNode(withName: "songImage") as? SKSpriteNode
        
        LabelMode = self.childNode(withName: "labelMode") as? SKLabelNode
        let backButton = self.childNode(withName: "backButton") as? MSButtonNode
        
        let moveRightAnimation = SKAction.move(to: CGPoint(x: 100, y: 205), duration: 0.3)
        let moveLeftAnimation = SKAction.move(to: CGPoint(x: -100, y: 205), duration: 0.3)
        let blurAnimation = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
        let songMoveRightAnimation = SKAction.move(to: CGPoint(x: 100, y: -32), duration: 0.3)
        let songMoveLeftAnimation = SKAction.move(to: CGPoint(x: -100, y: -32), duration: 0.3)
        
        //handler
        startButton?.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.start) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.loadGame()
                }
            }
            else {
                self.loadGame()
            }
        }
        
        songButtonRight?.selectedHandler = {
            songImage?.run(SKAction.group([songMoveRightAnimation,blurAnimation])) {
                songImage?.removeFromParent()
                if (self.selectedSong == (self.songArray.count - 1)) {
                    self.selectedSong = 0
                } else {
                    self.selectedSong += 1
                }
                songImage = SKSpriteNode(texture: SKTexture(imageNamed:  self.songArray[self.selectedSong]), color: .clear, size: CGSize(width: 200, height: 200))
                songImage?.position = CGPoint(x: -100, y: -32)
                self.setLabelSongProps(node: songImage!)
            }
        }
        
        songButtonLeft?.selectedHandler = {
            songImage?.run(SKAction.group([songMoveLeftAnimation,blurAnimation])) {
                songImage?.removeFromParent()
                if (self.selectedSong == 0) {
                    self.selectedSong = (self.songArray.count - 1)
                } else {
                    self.selectedSong -= 1
                }
                songImage = SKSpriteNode(texture: SKTexture(imageNamed:  self.songArray[self.selectedSong]), color: .clear, size: CGSize(width: 200, height: 200))
                songImage?.position = CGPoint(x: 100, y: -32)
                self.setLabelSongProps(node: songImage!)
            }
        }
        
        backButton?.selectedHandler = {
            self.goBack()
        }
        
        modeButtonRight.selectedHandler = {
            self.LabelMode.run(SKAction.group([moveRightAnimation,blurAnimation])) {
                self.LabelMode.removeFromParent()
                if (self.selectedMode == self.modeArray.count - 1) {
                    self.selectedMode = 0
                } else {
                    self.selectedMode += 1
                }
                self.LabelMode = SKLabelNode(text: self.modeArray[self.selectedMode])
                self.LabelMode.position = CGPoint(x: -100, y: 205)
                self.setLabelModeProps(label: self.LabelMode)
            }
        }
        modeButtonLeft.selectedHandler = {
            self.LabelMode.run(SKAction.group([moveLeftAnimation,blurAnimation])) {
                self.LabelMode.removeFromParent()
                if (self.selectedMode == 0) {
                    self.selectedMode = self.modeArray.count - 1
                } else {
                    self.selectedMode -= 1
                }
                self.LabelMode = SKLabelNode(text: self.modeArray[self.selectedMode])
                self.LabelMode.position = CGPoint(x: 100, y: 205)
                self.setLabelModeProps(label: self.LabelMode)
            }
        }
    }
    
    func loadGame() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = GameScene(fileNamed: "GameScene")!
        scene.level = (selectedMode * 10) == 0 ? 1 : (selectedMode * 10)
        scene.customBg = selectedSong
        scene.customGame = true
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    
    func goBack() {
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
    
    func setLabelModeProps(label: SKLabelNode ) {
        let displayAnimation = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        let moveCenterAnimation = SKAction.move(to: CGPoint(x: 0, y: 205), duration: 0.3)
        label.zPosition = 1.0
        label.alpha = 0.0
        label.fontName = "Your Dreams DEMO Brush"
        label.fontSize = 40
        self.addChild(label)
        label.run(SKAction.group([displayAnimation,moveCenterAnimation]))
    }
    
    func setLabelSongProps(node: SKNode) {
        let displayAnimation = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        let moveCenterAnimation = SKAction.move(to: CGPoint(x: 0, y: -32), duration: 0.3)
        node.zPosition = 1.0
        node.alpha = 0.0
        self.addChild(node)
        node.run(SKAction.group([displayAnimation,moveCenterAnimation]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
