//
//  MBTICollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/9/25.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: UICollectionViewCell, BaseConfigure {
    
    static let id = "MBTICollectionViewCell"
    
    let topButton: BaseButton
    let bottomButton: BaseButton
    var buttonAction: ((Int) -> ())?
    
    override init(frame: CGRect) {
        topButton = BaseButton(title: "", size: 20, weight: .regular, bgColor: .catsBlack, foreColor: .catsDarkgray)
         
        bottomButton = BaseButton(title: "", size: 20, weight: .regular, bgColor: .catsBlack, foreColor: .catsDarkgray)
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        [topButton, bottomButton].forEach {
            $0.cornerRadius(self.frame.width / 2)
            $0.stroke(.catsDarkgray, 1)
        }
        
        configHierarchy()
        configLayout()
        
        topButton.tag = 0
        bottomButton.tag = 1
        
        topButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
    }
    
    @objc private func tappedMbtiButton(_ sender: UIButton) {
        buttonAction?(sender.tag)
    }
    
    func configHierarchy() {
        self.addSubview(topButton)
        self.addSubview(bottomButton)
    }
    
    func configLayout() {
        topButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.size.equalTo(self.frame.width)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(topButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.size.equalTo(self.frame.width)
        }
    }
    
    func configBind(_ viewModel: ProfileNicknameViewModel, index: Int) {
        
        viewModel.outputIsTopOn.bind { [weak self] values in
            
            let value = values[index]
            
            self?.topButton.stroke(value ? .clear : .catsDarkgray, value ? 0 : 1)
            self?.topButton.configuration?.baseBackgroundColor = value ? .catsMain : .catsBlack
            self?.topButton.configuration?.baseForegroundColor = value ? .catsBlack : .catsDarkgray
        }
        
        viewModel.outputIsBottomOn.bind { [weak self] values in
            
            let value = values[index]
            
            self?.bottomButton.stroke(value ? .clear : .catsDarkgray, value ? 0 : 1)
            self?.bottomButton.configuration?.baseBackgroundColor = value ? .catsMain : .catsBlack
            self?.bottomButton.configuration?.baseForegroundColor = value ? .catsBlack : .catsDarkgray
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
