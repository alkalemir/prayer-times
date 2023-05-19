//
//  LottieAnimationView+.swift
//  Halka Arz
//
//  Created by Emir Alkal on 18.04.2023.
//

import Lottie

extension LottieAnimationView {
    func setupAndPlay(with name: String) {
        animation = LottieAnimation.named(name)
        animationSpeed = 1
        loopMode = .loop
        self.play()
    }
}
