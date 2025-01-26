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
        
        setNavigation()
        mainView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func startButtonTapped() {
        viewTransition(style: .push(animated: true), vc: ProfileNicknameViewController())
    }
    
    func setNavigation() {
        navigationController?.navigationBar.tintColor = .catsMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
    }

}
