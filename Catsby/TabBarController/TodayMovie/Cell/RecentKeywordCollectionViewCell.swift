//
//  RecentKeywordCollectionViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 2/1/25.
//

import UIKit
import SnapKit

final class RecentKeywordCollectionViewCell: UICollectionViewCell, BaseConfigure {
    
    static let id = "RecentKeywordCollectionViewCell"
    
    private let bgView = UIView()
    private let stackView = UIStackView()
    private var keywordLabel: BaseLabel
    private let deleteButton: BaseButton
    
    var deleteAction: (() -> ())?
    var backgroundAction: (() -> ())?
    
    override init(frame: CGRect) {
        keywordLabel = BaseLabel(text: "", align: .right, color: .catsBlack, size: 14, weight: .medium)
        
        deleteButton = BaseButton(title: "", size: 14, weight: .medium, bgColor: .clear, foreColor: .catsBlack)
        
        super.init(frame: frame)
        
        guard let image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10, weight: .medium))) else { return }
        deleteButton.buttonImage(image: image)
        bgView.backgroundColor = .catsLightgray

        configHierarchy()
        configLayout()
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        backgroundTapGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        keywordLabel.text = ""
        deleteAction = {}
        backgroundAction = {}
    }
    
    func configHierarchy() {
        self.addSubview(bgView)
        self.addSubview(stackView)
        stackView.addArrangedSubview(keywordLabel)
        stackView.addArrangedSubview(deleteButton)
    }
    
    func configLayout() {
        bgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        
    }
    
    private func backgroundTapGesture() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(tapgesture)
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
    
    @objc private func backgroundTapped() {
        backgroundAction?()
    }
    
    func getDataFromAPI(_ text: String) {
        keywordLabel.text = text
    }
    
    func cornerRadius() {
        bgView.layer.cornerRadius = 15
        bgView.clipsToBounds = true
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
