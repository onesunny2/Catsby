//
//  SearchResultTableViewCell.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

/*
 포스터 - imageView
 영화 제목 & 개봉날짜 - StackView(Label, Label)
 영화 장르 - StackView(Label)
 하트 버튼 - UIButton
 */

final class SearchResultTableViewCell: UITableViewCell, BaseConfigure {

    static let id = "SearchResultTableViewCell"
    
    private let posterImageView: BaseImageView
    private let titleReleaseStackView = UIStackView()
    private let titleLabel: BaseLabel
    private let releaseDateLabel: BaseLabel
    private var genreStackView = UIStackView()
    private var genreLabel: [BaseLabel]
    private var genreBgView: [UIView]
    let heartButton = UIButton()
    var genreList = ["", ""]  // 갯수에 따라 달라지도록
    var tapbuttonAction: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        posterImageView = BaseImageView(type: UIImage(), bgcolor: .catsLightgray)
        
        titleLabel = BaseLabel(text: "진격의 이원선", align: .left, size: 16, weight: .bold, line: 2)
        
        releaseDateLabel = BaseLabel(text: "2222. 22. 22", align: .left, color: .catsDarkgray, size: 14, weight: .regular)
        
        genreLabel = []
        genreBgView = []
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .catsBlack
        configHierarchy()
        configLayout()
        configView()
        
        heartButton.addTarget(self, action: #selector(heartbuttonTapped), for: .touchUpInside)
    }
    
    func configHierarchy() {
        [posterImageView, titleReleaseStackView, genreStackView, heartButton].forEach {
            contentView.addSubview($0)
        }
        [titleLabel, releaseDateLabel].forEach {
            titleReleaseStackView.addArrangedSubview($0)
        }
    }
    
    func configLayout() {
        posterImageView.snp.makeConstraints {
          
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(118 * 0.8)
        }
        
        titleReleaseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(18)
        }
        
        titleReleaseStackView.axis = .vertical
        titleReleaseStackView.alignment = .leading
        titleReleaseStackView.spacing = 3
 
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        genreStackView.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(18)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        genreStackView.axis = .horizontal
        genreStackView.alignment = .leading
        genreStackView.spacing = 4

        heartButton.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom)
            $0.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 정확한 이유는 모르겠지만.. prepareForReuse에서 초기화 하면 2개씩 걸러내는게 무시당해지고 해결하지 못함
          // ㄴ 📌 스택뷰에 앞서 사용했던 모든 데이터가 누적되고 있는 것이 문제 였음을 확인 ㅠ
            // 여기서 아예 새로 데이터를 받아올 때마다 arrange된 값 다 지우고 초기화 시키는 방법으로 강행
        
        genreStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        genreLabel = []
        genreBgView = []
        
        tapbuttonAction = {}
    }
    
    private func configView() {
        heartButton.configuration = .filled()
        heartButton.configuration?.imagePadding = 0
        heartButton.configuration?.baseForegroundColor = .catsMain
        heartButton.configuration?.baseBackgroundColor = .clear
    }
    
    @objc func heartbuttonTapped() {
        print(#function)
        tapbuttonAction?()
    }
    
    func getData(_ url: String, _ title: String, _ date: String, _ genre: [String], _ isLiked: Bool) {
        
        // 이미지
        let processor = DownSampling.processor(posterImageView)
        posterImageView.kf.setImage(with: URL(string: url),
                                    options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .cacheOriginalImage
                                    ])
        
        // 타이틀
        titleLabel.text = title
        
        // 날짜
        guard let stringToDate = UserDefaultsManager.dateformatter.date(from: date) else { return }
        UserDefaultsManager.dateformatter.dateFormat = "yyyy. MM. dd"
        let newDate = UserDefaultsManager.dateformatter.string(from: stringToDate)
        releaseDateLabel.text = newDate
        
        // 장르
        genreList = genre

        if genreList.count != 0 {
            for index in 0...genreList.count - 1 {
                // 📌 순서 잘 지키기..+ 빈배열이었다가 데이터를 넣었기 때문에 다시 다 그려줘야하는 점..!
                // stackView - UIView - UILabel의 관계 구조 혼동하지 않도록
                genreLabel.append(BaseLabel(text: genreList[index], align: .center, size: 13, weight: .medium))
                genreBgView.append(UIView())
                genreBgView[index].backgroundColor = .darkGray
                genreBgView[index].layer.cornerRadius = 5
                genreBgView[index].clipsToBounds = true
                
                genreStackView.addArrangedSubview(genreBgView[index])
                genreBgView[index].addSubview(genreLabel[index])
                
                genreLabel[index].snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(5)
                }
            }
        }
   
        // 하트
        heartButton.configuration?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16)))
        
        self.layoutIfNeeded()
    }
    
    func cornerRadius() {
        posterImageView.clipCorner(5)
        self.layoutIfNeeded()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
