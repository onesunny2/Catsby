//
//  OnboardingViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func startButtonTapped() {
        print(#function)
        viewTransition(style: .push, vc: ProfileNicknameViewController())
    }

}
