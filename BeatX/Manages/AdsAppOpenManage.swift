//
//  AdsAppOpenManage.swift
//  StepUpGame
//
//  Created by Quynh Nguyen on 3/27/21.
//

import UIKit
import GoogleMobileAds

class AdsAppOpenManage: NSObject, GADFullScreenContentDelegate {
    // MARK: properties
    fileprivate var _appOpenAd: GADAppOpenAd?
    fileprivate var _loadTime: Date?
    
    // MARK: initial
    static let sharedInstance: AdsAppOpenManage = AdsAppOpenManage()
    
    // MARK: private
    private func wasLoadTimeLessThanNHoursAgo(_ n: Double) -> Bool {
        if _loadTime == nil { return false }
        
        let timeIntervalBetweenNowAndLoadTime = Date().timeIntervalSince(_loadTime!)
        let secondsPerHour: Double = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < n
    }
    
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
        
        _appOpenAd = nil
        
        let orientation = UIApplication.shared.statusBarOrientation
        GADAppOpenAd.load(withAdUnitID: data.id_app_open, request: GADRequest(), orientation: orientation) { (ad, error) in
            if error != nil {
                return
            }
            self._appOpenAd = ad
            self._appOpenAd?.fullScreenContentDelegate = self
            self._loadTime = Date()
        }
    }
    
    func showAds() {
        if !FirebaseManage.sharedInstance.data().enable_ads {
            return
        }
        
        if let ad = self._appOpenAd, self.wasLoadTimeLessThanNHoursAgo(4.0) {
            guard let rootVC = UIApplication.getTopController() else { return }
            
            ad.present(fromRootViewController: rootVC)
        }
        else {
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
        loadAds()
    }
}
