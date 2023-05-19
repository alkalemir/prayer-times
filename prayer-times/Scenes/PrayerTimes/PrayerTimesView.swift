//
//  PrayerTimesView.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import UIKit
import Lottie
import NetworkManager

final class PrayerTimesView: UIView {
    private let indicatorView = LottieAnimationView()
    private let containerView = UIView()
    private var remainingTime: Int?
    weak var delegate: PrayerTimesViewDelegate?
    private var timer: Timer?
    
    private let fajrTime = SingleTimeView(label: "İmsak", time: "--:--", image: "fajr-ic")
    private let sunriseTime = SingleTimeView(label: "Güneş", time: "--:--", image: "sunrise-ic")
    private let dhuhrTime = SingleTimeView(label: "Öğle", time: "--:--", image: "dhuhr-ic")
    private let asrTime = SingleTimeView(label: "İkindi", time: "--:--", image: "asr-ic")
    private let sunsetTime = SingleTimeView(label: "Akşam", time: "--:--", image: "sunset-ic")
    private let ishaTime = SingleTimeView(label: "Yatsı", time: "--:--", image: "isha-ic")
    
    private let imageView = UIImageView(imageName: "dhuhr", contenMode: .scaleAspectFill)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: 2, distribution: .fillEqually ,arrangedSubviews: [
        fajrTime, sunriseTime, dhuhrTime, asrTime, sunsetTime, ishaTime
    ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.isHidden = true
        layout()
    }
    
    private func layout() {
        backgroundColor = .white
        containerView.backgroundColor = .white
        addSubviews(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubviews(imageView, stackView)
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(snp.centerY).offset(-70)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(snp.bottom).offset(-49 - UIApplication.insets.bottom)
        }
    }
    
    func showIndicator() {
        containerView.isHidden = true
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        indicatorView.setupAndPlay(with: "spinner")
    }
    
    func showPrayerTimes(presentation: PrayerTimesPresentation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            containerView.isHidden = false
            self.indicatorView.stop()
            configure(with: presentation)
        }
    }
    
    private func configure(with model: PrayerTimesPresentation) {
        fajrTime.timeLabel.text = model.times[0]
        sunriseTime.timeLabel.text = model.times[1]
        dhuhrTime.timeLabel.text = model.times[2]
        asrTime.timeLabel.text = model.times[3]
        sunsetTime.timeLabel.text = model.times[4]
        ishaTime.timeLabel.text = model.times[5]
        
        for (idx, subview) in stackView.subviews.enumerated() {
            if idx == model.currentTime {
                (subview as! SingleTimeView).makeCurrentTime()
            } else {
                (subview as! SingleTimeView).clearCurrentTime()
            }
        }
        
        remainingTime = model.remainingTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime != 0 {
                self.remainingTime! -= 1
            } else {
                self.timer?.invalidate()
                self.delegate?.advanceTime()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PrayerTimesViewDelegate: AnyObject {
    func advanceTime()
}
