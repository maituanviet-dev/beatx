//
//  MainMenu.swift
//  StepUpGame
//
//  Created by Tuấn Việt on 14/03/2021.
//
import SpriteKit
import Foundation
import GameKit
import StoreKit
import Social

class MainMenu: SKScene, GKGameCenterControllerDelegate {
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID = "tuanviet.studio.beatx.leaderboard"
    var buttonGameCenter: MSButtonNode!
    var customButton: MSButtonNode!
    let faded = SKTransition.fade(with: .black, duration: 1)
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func didMove(to view: SKView) {
        let shareButton = self.childNode(withName: "shareButton") as? MSButtonNode
        let rateButton = self.childNode(withName: "rateButton") as? MSButtonNode
        let howPlayBlur = self.childNode(withName: "howPlayBlur") as? SKSpriteNode
        let popUpHowPlay = self.childNode(withName: "popUpHowPlay") as? SKSpriteNode
        let okButton = popUpHowPlay!.childNode(withName: "okButton") as? MSButtonNode
        let howToPlayButton = self.childNode(withName: "howToPlayButton") as? MSButtonNode
        
        howToPlayButton?.selectedHandler = {
            howPlayBlur?.alpha = 0.7
            popUpHowPlay?.alpha = 1.0
        }
        
        okButton?.selectedHandler = {
            howPlayBlur?.alpha = 0.0
            popUpHowPlay?.alpha = 0.0
        }
        
        
        shareButton?.selectedHandler = {
            self.shareAction()
        }
        rateButton?.selectedHandler = {
            MainMenu.rateAction()
        }
        authenticateLocalPlayer()
        buttonGameCenter = self.childNode(withName: "buttonGameCenter") as? MSButtonNode
        customButton = self.childNode(withName: "customButton") as? MSButtonNode
        let campaignButton = self.childNode(withName: "campaignButton") as? MSButtonNode
        
        campaignButton?.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.campain) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.loadGame()
                }
            }
            else {
                self.loadGame()
            }
        }
        
        customButton.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.custom) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.loadCustomScreen()
                }
            }
            else {
                self.loadCustomScreen()
            }
        }
        buttonGameCenter.selectedHandler = {
            if FirebaseManage.sharedInstance.canShowInterstitial(.game_center) {
                AdsInterstitialManage.sharedInstance.showAds {
                    self.gameCenterAction()
                }
            }
            else {
                self.gameCenterAction()
            }
        }
    }
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                let currentViewController:UIViewController=(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController)!
                
                currentViewController.present(ViewController!, animated: true, completion: nil)
                
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    func loadGame() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = GameScene(fileNamed: "GameScene")!
        scene.level = 1
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    func loadCustomScreen() {
        guard let skView = self.view else {
            print("Could not get Skview")
            return
        }
        let scene = CustomGame(fileNamed: "CustomGame")!
        scene.scaleMode = .aspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        skView.presentScene(scene, transition: faded)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    static func rateAction() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func gameCenterAction() {
        if #available(iOS 14.0, *) {
            let gcVC = GKGameCenterViewController.init(state: .leaderboards)
            gcVC.gameCenterDelegate = self
            let currentViewController:UIViewController=(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController)!
            currentViewController.present(gcVC, animated: true, completion: nil)
        } else {
            let gcVC = GKGameCenterViewController.init()
            gcVC.gameCenterDelegate = self
            let currentViewController:UIViewController=(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController)!
            currentViewController.present(gcVC, animated: true, completion: nil)
        }
    }
    
    private func shareAction() {
        // Setting description
        let firstActivityItem = "Try this game and play with me. It would be fun!"
        
        // Setting url
        let secondActivityItem : NSURL = NSURL(string: "http://itunes.apple.com/app/id1561528826")!
        
        // If you want to use an image
        let image : UIImage = UIImage(named: "AppIcon")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        if #available(iOS 13.0, *) {
            // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            activityViewController.isModalInPresentation = true
            let currentViewController:UIViewController=(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController)!
            currentViewController.present(activityViewController, animated: true, completion: nil)
        } else {
            let text = "Try this game and play with me. It would be fun!"
            let image = UIImage(named: "AppIcon")
            let myWebsite = NSURL(string:"http://itunes.apple.com/app/id1561528826")
            let shareAll = [text , image! , myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            let currentViewController:UIViewController=(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController)!
            currentViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
