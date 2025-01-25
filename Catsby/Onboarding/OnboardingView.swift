//
//  OnboardingView.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    
    let onboardingImageView: BaseImageView
    
    override init(frame: CGRect) {
        guard let image = UIImage(named: "onboarding") else { return }
        onboardingImageView = BaseImageView(type: image)
        
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func configHierarchy() {
        self.addSubview(onboardingImageView)
    }
    
    override func configLayout() {
        <#code#>
    }
    
    override func configView() {
        <#code#>
    }
}
