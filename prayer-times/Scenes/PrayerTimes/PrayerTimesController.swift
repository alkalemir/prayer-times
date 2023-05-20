//
//  ViewController.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import UIKit
import NetworkManager

final class PrayerTimesController: UIViewController {
    let viewModel = PrayerTimesViewModel()
    let vc1 = AlertController(alertTitle: "Konum bilgine ihtiyacımız var!", message: "Konum bilgini paylaşmak için hazır mısın? Yalnızca uygulamayı kullanırken konumunuzu kullanıyor olacağız.", buttonTitle: "Konum İzni İste")
    let vc2 = AlertController(alertTitle: "Konum bilgine ihtiyacımız var!", message: "Görünüşe göre konum bilgisine izin vermemişsiniz. Konuma izin vermek için Ayarlar -> Gizlilik & Güvenlik ve daha sonra uygulamamızı seçerek izin verebilirsin.", buttonTitle: "Konum İzni İste")

    public var prayerTimesView: PrayerTimesView? {
        guard isViewLoaded else { return nil }
        return view as? PrayerTimesView
    }
    
    override func loadView() {
        view = PrayerTimesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "background")
        prayerTimesView?.delegate = self
        viewModel.delegate = self
    }
    
    @objc private func handleRequestLocationButton() {
        viewModel.requestLocation()
    }
    
    @objc private func handleOpenSettingsButton() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
}

extension PrayerTimesController: PrayerTimesDelegate {
    func waitForResponse() {
        prayerTimesView?.showIndicator()
    }
    
    func locationRequestDeclined() {
        showUserHowToChangeLocationAuth()
    }
    
    func locationRequestAccepted() {
        removeChild(vc: vc1)
        removeChild(vc: vc2)
        tabBarController?.tabBar.isHidden = false
    }
    
    func showPrayerTimes(prayerTimes: PrayerTimesModel) {
        prayerTimesView?.showPrayerTimes(presentation: prayerTimes.toPresentation(date: Date()))
    }
    
    func requestLocation() {
        removeChild(vc: vc2)
        addChild(vc: vc1)
        vc1.actionButton.addTarget(self, action: #selector(handleRequestLocationButton), for: .touchUpInside)
        tabBarController?.tabBar.isHidden = true
    }
        
    func showUserHowToChangeLocationAuth() {
        tabBarController?.selectedIndex = 0
        removeChild(vc: vc1)
        addChild(vc: vc2)
        vc2.actionButton.addTarget(self, action: #selector(handleOpenSettingsButton), for: .touchUpInside)
        tabBarController?.tabBar.isHidden = true
    }
}

extension PrayerTimesController: PrayerTimesViewDelegate {
    func advanceTime() {
        viewModel.fetchTimes()
    }
}
