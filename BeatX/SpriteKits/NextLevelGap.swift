//
//  NextLevelGap.swift
//  StepUpGame
//
//  Created by Tuấn Việt on 14/03/2021.
//
import SpriteKit
import Foundation
import GameKit

class NextLevelGap: SKScene {
    let faded = SKTransition.fade(with: .black, duration: 1)
    var score:Int = 0
    var level = 1
    var gameOver = false
    var miss = 0
    var cool = 0
    var great = 0
    var perfect = 0
    var completePercent = 0.0
    var total = 0
    var customGame = false
    let LEADERBOARD_ID = "tuanviet.studio.beatx.leaderboard"

    override func didMove(to view: SKView) {
        total = miss + cool + great + perfect
        completePercent = ceil((1 - (Double(miss)/Double(total)))*100)
        let titleLabel = self.childNode(withName: "titleLabel") as! SKLabelNode
        let scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        let totalLabel = self.childNode(withName: "totalLabel") as! SKLabelNode
        let perfectLabel = self.childNode(withName: "perfectLabel") as! SKLabelNode
        let greatLabel = self.childNode(withName: "greatLabel") as! SKLabelNode
        let coolLabel = self.childNode(withName: "coolLabel") as! SKLabelNode
        let missLabel = self.childNode(withName: "missLabel") as! SKLabelNode
        let completeLabel = self.childNode(withName: "completeLabel") as! SKLabelNode
        let backToHomeButton = self.childNode(withName: "backToHomeButton") as! MSButtonNode
        let startGameButton = self.childNode(withName: "startGameButton") as! MSButtonNode
        
        completeLabel.text = "Complete: \(ceil((1 - (Double(miss)/Double(total)))*100))%"
        scoreLabel.text = "\(score)"
        totalLabel.text = "\(total)"
        perfectLabel.text = "\(perfect)"
        greatLabel.text = "\(great)"
        coolLabel.text = "\(cool)"
        missLabel.text = "\(miss)"

        //handler
        if (completePercent < 80 || customGame) {
            titleLabel.text = "GameOver"
        }
        if (completePercent < 80) {
            startGameButton.texture = SKTexture(imageNamed: "watchAds")
        }
        if (customGame) {
            startGameButton.alpha = 0.0
        }
        
        backToHomeButton.selectedHandler = {
            self.loadHome()
        }
        
        startGameButton.selectedHandler = {
            if (self.completePercent < 80) {
                self.retry()
            } else {
                self.loadGame()
            }
        }
        
        //save high score
        saveHighScore()
        addScoreAndSubmitToGC()
        //
        let completeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        completeLabel.run(completeAnimation)
    }
    func loadGame() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = GameScene(fileNamed: "GameScene")!
        scene.level = level + 1
        scene.score = score
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    
    func retry() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = GameScene(fileNamed: "GameScene")!
        scene.level = level
        scene.score = score
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    
    func loadHome() {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    func saveHighScore() {
        let userDefaults = UserDefaults.standard
        if let highScore = userDefaults.string(forKey: "highScore") {
            guard let highScore = Int(highScore) else {
                return
            }
            if highScore < Int(self.score) {
                userDefaults.set(String(self.score), forKey: "highScore")
            }
        }
    }
    func addScoreAndSubmitToGC() {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
}
