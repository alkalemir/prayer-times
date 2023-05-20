//
//  SettingsVC.swift
//  FinalMuslim
//
//  Created by Emir Alkal on 18.06.2022.
//

import UIKit
import SwiftUI
//import GoogleMobileAds

class SettingsVC: UIViewController {

    let contentView = UIHostingController(rootView: SettingsListSwiftUI())
//    var bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background-color")
        
//        view.addSubview(bannerView)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bannerView.widthAnchor.constraint(equalToConstant: 320),
//            bannerView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIApplication.insets.bottom + 49)
        ])

    }
}
