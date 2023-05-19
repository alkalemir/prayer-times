//
//  PrayerItemView.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 13.04.2023.
//

import UIKit

final class SingleTimeView: UIView {
    
    var getCurrentTimeName: String {
        nameLabel.text ?? ""
    }
    
    private let imageView = UIImageView(imageName: "imsak", contenMode: .scaleAspectFit)
    private let nameLabel = UILabel(font: .ceraBold(size: 20), textColor: .selectedTint)
    public let timeLabel = UILabel(font: .ceraBlack(size: 20), textColor: .selectedTint)
    private lazy var stackView = UIStackView(axis: .horizontal, arrangedSubviews: [
        nameLabel, UIView() ,timeLabel
    ])
    
    private let currentTimeLabel = UILabel(font: .ceraBlack(size: 16), textColor: .secondaryText)
    
    func updateLabel(with timeString: String) {
        timeLabel.text = timeString
    }
    
    func makeCurrentTime() {
        backgroundColor = .separatorColor
        
        addSubview(currentTimeLabel)
        currentTimeLabel.text = "•  Şu Anki Vakit"
        currentTimeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func clearCurrentTime() {
        backgroundColor = .white
        currentTimeLabel.removeFromSuperview()
        layer.borderWidth = 0
    }

    convenience init(label: String, time: String, image: String) {
        self.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
        setupViews(label: label, time: time, image: image)
    }
    
    private func setupViews(label: String, time: String, image: String) {
        imageView.image = UIImage(named: image)
        nameLabel.text = label
        timeLabel.text = time
    }
    
    private func setupLayout() {
        addSubviews(imageView, stackView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(snp.top).offset(18)
            make.bottom.equalTo(snp.bottom).offset(-18)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
