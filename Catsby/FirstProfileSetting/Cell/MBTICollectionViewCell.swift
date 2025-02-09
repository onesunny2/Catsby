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
    
    override init(frame: CGRect) {
        topButton = BaseButton(title: "E", size: 20, weight: .regular, bgColor: .catsBlack, foreColor: .catsDarkgray)
         
        bottomButton = BaseButton(title: "I", size: 20, weight: .regular, bgColor: .catsBlack, foreColor: .catsDarkgray)
        
        super.init(frame: frame)
        
        [topButton, bottomButton].forEach {
            $0.cornerRadius(self.frame.width / 2)
            $0.stroke(.catsDarkgray, 1)
        }
        
        configHierarchy()
        configLayout()
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
