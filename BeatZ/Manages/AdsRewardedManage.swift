//
//  AdsRewardedManage.swift
//  StepUpGame
//
//  Created by Quynh Nguyen on 3/27/21.
//

import UIKit
import GoogleMobileAds

enum RewardedType {
    case no_ads
    case did_earn_reward
    case will_present
    case error
}

class AdsRewardedManage: NSObject, GADFullScreenContentDelegate {
    // MARK: properties
    fileprivate var _rewardedInterstitialAd: GADRewardedInterstitialAd?
    fileprivate var _onRewardedCompletion: ((_ type: RewardedType) -> Void)?
    fileprivate var _type: RewardedType = .no_ads
    
    // MARK: initial
    static let sharedInstance: AdsRewardedManage = AdsRewardedManage()
    
    // MARK: private
    
    // MARK: public
    func loadAds() {
        // Admob hasn't completed the initialization
        if !AdsManage.sharedInstance.initialized() {
            return
        }
        _rewardedInterstitialAd = nil
        
        let data = FirebaseManage.sharedInstance.data()
        GADRewardedInterstitialAd.load(withAdUnitID: data.id_rewarded_interstitial, request: GADRequest()) { [self] ad, error in
            if error != nil {
                return
            }
            self._rewardedInterstitialAd = ad
            self._rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func showAds(_ completion: @escaping ((_ type: RewardedType) -> Void)) {
        _type = .no_ads
        _onRewardedCompletion = nil
        
        if let ad = _rewardedInterstitialAd {
            _onRewardedCompletion = completion
            guard let rootVC = UIApplication.getTopController() else { return }
            _type = .will_present
            ad.present(fromRootViewController: rootVC) {
                self._type = .did_earn_reward
            }
        }
        else {
            loadAds()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self._type = .error
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let onRewarded = self._onRewardedCompletion {
            onRewarded(self._type)
        }
        loadAds()
    }
}
