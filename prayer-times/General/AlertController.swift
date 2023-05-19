//
//  AlertController.swift
//  Dinimiz İslam
//
//  Created by Emir Alkal on 26.04.2023.
//

import UIKit
import SnapKit

final class AlertController: UIViewController {
    private let containerView = UIView()
    private let titleLabel = UILabel(textColor: .selectedTint, font: .ceraBold(size: 18))
    
    private let bodyLabel = UILabel(textColor: #colorLiteral(red: 0.1381634322, green: 0.524965864, blue: 1, alpha: 1), font: .ceraMedium(size: 17))
    private let logoImageView = UIImageView(image: UIImage(named: "mosque")!)
    public let actionButton = UIButton(type: .system)
    
    var alertTitle: String!
    var message: String!
    var buttonTitle: String!
    let padding: CGFloat = 16
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
        titleLabel.text = alertTitle
        bodyLabel.text = message
        titleLabel.textAlignment = .center
        bodyLabel.textAlignment = .center
        actionButton.titleLabel?.font = .ceraMedium(size: 18)
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.backgroundColor = .selectedTint
        actionButton.setTitleColor(.unselectedTint, for: .normal)
        logoImageView.contentMode = .scaleAspectFit
        actionButton.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
    }
    
    private func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = .white
        
        titleLabel.text = alertTitle
        bodyLabel.text = message
        actionButton.setTitle(buttonTitle, for: .normal)
        bodyLabel.numberOfLines = 0
    }
    
    private func layout() {
        view.addSubviews(containerView, logoImageView)
        containerView.addSubviews(titleLabel, bodyLabel, actionButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(255)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.top.equalTo(logoImageView.snp.bottom).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(28)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-padding)
            make.leading.equalToSuperview().offset(padding)
            make.height.equalTo(44)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.equalTo(actionButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(containerView.snp.top)
        }
        
        logoImageView.layer.cornerRadius = 35
        logoImageView.layer.borderWidth = 2
        logoImageView.layer.borderColor = UIColor.selectedTint.cgColor
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .white
    }
    
}
