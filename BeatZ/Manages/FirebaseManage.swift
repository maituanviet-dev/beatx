//
//  FirebaseManage.swift
//  StepUpGame
//
//  Created by Quynh Nguyen on 3/27/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class FirebaseManage: NSObject {
    // MARK: properties
    private var _data = RemoteConfigObject()
    private var _initialized: Bool = false
    private var _reference: DatabaseReference!
    
    // MARK: initial
    static let sharedInstance: FirebaseManage = FirebaseManage()
    
    // MARK: private
    
    // MARK: public
    func canShowInterstitial(_ widthButton: ButtonID) -> Bool {
        return _data.buttons_show_interstitial.contains(widthButton)
    }
    
    func data() -> RemoteConfigObject {
        return _data
    }
    
    func initialized() -> Bool {
        return _initialized
    }
    
    func configure(completion: @escaping (() -> Void)) {
        // config firebase
        FirebaseApp.configure()
        
        // fetch data
        _reference = Database.database().reference()
        _reference.child("/").observeSingleEvent(of: .value, with: { (snapshot) in
            if let json = snapshot.value as? [String:Any] {
                self._data.update(json)
            }
            self._initialized = true
            DispatchQueue.main.async {
                completion()
            }
        }) { (error) in
            self._initialized = true
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}
