//
//  RemoteConfigObject.swift
//  BeatX
//
//  Created by Quynh Nguyen on 4/5/21.
//

import UIKit

enum ButtonID: String {
    case campain
    case custom
    case start
    case how_to_play
    case game_center
    case next_level
    case back_home
    case resume
}

class RemoteConfigObject: NSObject {
    var id_banner: String = "ca-app-pub-6567326132643016/1465560456"
    var id_interstitial: String = "ca-app-pub-6567326132643016/9152478780"
    var id_rewarded_interstitial: String = "ca-app-pub-6567326132643016/5213233778"
    var id_app_open: String = "ca-app-pub-6567326132643016/3900152109"
    var enable_ads: Bool = false
    var rate_game: Bool = false
    var buttons_show_interstitial: [ButtonID] = []
    
    override init() {
        super.init()
    }
    
    init(_ data: [String:Any]) {
        super.init()
        self.update(data)
    }
    
    func update(_ data: [String:Any]) {
        if let value = data["id_banner"] as? String {
            id_banner = value
        }
        if let value = data["id_interstitial"] as? String {
            id_interstitial = value
        }
        if let value = data["id_rewarded_interstitial"] as? String {
            id_rewarded_interstitial = value
        }
        if let value = data["id_app_open"] as? String {
            id_app_open = value
        }
        if let value = data["enable_ads"] as? Bool {
            enable_ads = value
        }
        if let value = data["rate_game"] as? Bool {
            rate_game = value
        }
        if let value = data["buttons_show_interstitial"] as? [String] {
            for item in value {
                if let id = ButtonID(rawValue: item) {
                    buttons_show_interstitial.append(id)
                }
            }
        }
    }
}
