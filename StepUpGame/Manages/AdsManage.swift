//
//  AdsManage.swift
//  StepUpGame
//
//  Created by Quynh Nguyen on 3/27/21.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import StoreKit

class AdsManage: NSObject {
    // MARK: properties
    private var _initialized: Bool = false
    
    // MARK: initial
    static let sharedInstance: AdsManage = AdsManage()
    
    // MARK: private
    private func start() {
        let id_tests = [kGADSimulatorID as! String, "47aa8c28d3e065ceec17de11816f48f1", "4c618205823bc384b5c14a86780cde34"]
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = id_tests
        GADMobileAds.sharedInstance().start { (_) in
            self._initialized = true
            AdsInterstitialManage.sharedInstance.loadAds()
            AdsRewardedManage.sharedInstance.loadAds()
            AdsAppOpenManage.sharedInstance.loadAds()
        }
    }
    
    // MARK: public
    func initialized() -> Bool {
        return _initialized
    }
    
    func requestIDFA(completion: @escaping (() -> Void)) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.start()
                DispatchQueue.main.async {
                    completion()
                }
            })
        } else {
            self.start()
            completion()
        }
    }
    
}

protocol AdsProtocol {
    func loadAds()
    func showAds()
}
