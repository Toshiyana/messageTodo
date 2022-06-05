//
//  BannerAdView.swift
//  messageTodo
//
//  Created by Toshiyana on 2022/06/05.
//

import UIKit
import GoogleMobileAds

class BannerAdView: NSObject {
    var bannerView: GADBannerView!
    private var parentView: UIView!
    private let bottomPadding: CGFloat = -10.0
    
    init(attachedToView view: UIView) {
        super.init()
        
        parentView = view
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner) // Banner size is "320x50"
        parentView.addSubview(bannerView)
        installConstraints()
        
        // set properties of GADBannerView
        bannerView.adUnitID = K.Admob.myId
        bannerView.load(GADRequest())
    }
    
    private func installConstraints() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = parentView.safeAreaLayoutGuide
        bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: bottomPadding).isActive = true
    }
}
