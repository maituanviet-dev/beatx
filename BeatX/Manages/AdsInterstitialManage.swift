//
//  AdsInterstitialManage.swift
//  StepUpGame
//
//  Created by Quynh Nguyen on 3/27/21.
//

import UIKit
import GoogleMobileAds

class AdsInterstitialManage: NSObject, GADFullScreenContentDelegate {
    // MARK: properties
    private var _interstitial: GADInterstitialAd?
    
    fileprivate var _onCompletion: (() -> Void)?
    
    // MARK: initial
    static let sharedInstance: AdsInterstitialManage = AdsInterstitialManage()
    
    // MARK: private
    
    // MARK: public
    func loadAds() {
        // Admob hasn't completed the initialization
        if !AdsManage.sharedInstance.initialized() {
            return
        }
        let data = FirebaseManage.sharedInstance.data()
        if !data.enable_ads {
            return
        }
        
        _interstitial = nil
        GADInterstitialAd.load(withAdUnitID: data.id_interstitial, request: GADRequest()) { [self] ad, error in
            if error != nil {
                return
            }
            self._interstitial = ad
            self._interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func showAds(_ completion: @escaping (() -> Void)) {
        _onCompletion = nil
        if !FirebaseManage.sharedInstance.data().enable_ads {
            completion()
            return
        }
        
        if let ad = _interstitial {
            guard let rootVC = UIApplication.getTopController() else { return }
            
            _onCompletion = completion
            ad.present(fromRootViewController: rootVC)
        }
        else {
            completion()
            loadAds()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let block = _onCompletion {
            block()
        }
        loadAds()
    }
    
}
