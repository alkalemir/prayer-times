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
    var timer: Timer?
    
    private let fajrTime = SingleTimeView(label: "İmsak", time: "--:--", image: "fajr-ic")
    private let sunriseTime = SingleTimeView(label: "Güneş", time: "--:--", image: "sunrise-ic")
    private let dhuhrTime = SingleTimeView(label: "Öğle", time: "--:--", image: "dhuhr-ic")
    private let asrTime = SingleTimeView(label: "İkindi", time: "--:--", image: "asr-ic")
    private let sunsetTime = SingleTimeView(label: "Akşam", time: "--:--", image: "sunset-ic")
    private let ishaTime = SingleTimeView(label: "Yatsı", time: "--:--", image: "isha-ic")
    
    private let cityLabel = UILabel(font: .ceraBold(size: 20), textColor: .white)
    private let dateLabel = UILabel(font: .ceraMedium(size: 20), textColor: .white)
    private let infoLabel = UILabel(font: .ceraMedium(size: 20), textColor: .white)
    private let timeLabel = UILabel(font: .ceraLight(size: 80), textColor: .white)
    private let secondLabel = UILabel(font: .ceraBold(size: 30), textColor: .white)
    
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
        backgroundColor = .separatorColor
        containerView.backgroundColor = .separatorColor
        addSubviews(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubviews(imageView, stackView, cityLabel, dateLabel, infoLabel, timeLabel, secondLabel)
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(snp.centerY).offset(-70)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalTo(snp.bottom).offset(-49 - UIApplication.insets.bottom)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(UIApplication.insets.top + 5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom)
            make.height.equalTo(50)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageView.snp.centerY).offset(-30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(infoLabel.snp.centerX).offset(-16)
            make.top.equalTo(infoLabel.snp.bottom).offset(5)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.top)
            make.leading.equalTo(timeLabel.snp.trailing).offset(5)
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
        imageView.image = UIImage(named: "\(model.currentTime)")
        cityLabel.text = model.city
        dateLabel.text = "      \(model.date)"
    
        let attrText = NSMutableAttributedString(string: model.nextTime, attributes: [.font: UIFont.ceraBold(size: 22)])
        attrText.append(NSAttributedString(string: " vaktine kalan süre", attributes: [.font: UIFont.ceraMedium(size: 20)]))
        infoLabel.attributedText = attrText
        
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
                let (hour, minute, second) = self.stringToFormattedTime(seconds: self.remainingTime!)
                self.timeLabel.text = "\(hour < 10 ? "0" : "")\(hour):\(minute < 10 ? "0" : "")\(minute)"
                self.secondLabel.text = "\(second < 10 ? "0" : "")\(second)"
            } else {
                self.timer?.invalidate()
                self.delegate?.advanceTime()
            }
            let currentTimeName: String
            
            switch model.currentTime {
            case 0:
                currentTimeName = "Güneş"
            case 1:
                currentTimeName = "Öğle"
            case 2:
                currentTimeName = "İkindi"
            case 3:
                currentTimeName = "Akşam"
            case 4:
                currentTimeName = "Yatsı"
            case 5:
                currentTimeName = "İmsak"
            default:
                currentTimeName = "bilinmiyor"
            }
            UserDefaults.standard.set(currentTimeName, forKey: "timeName")
            UserDefaults.standard.set(self.remainingTime, forKey: "remainTime")
        }
    }
    
    private func stringToFormattedTime(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PrayerTimesViewDelegate: AnyObject {
    func advanceTime()
}
