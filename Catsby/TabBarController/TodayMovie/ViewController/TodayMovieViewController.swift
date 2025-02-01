//
//  TodayMovieViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/26/25.
//

import UIKit
import SnapKit

final class TodayMovieViewController: UIViewController {
    
    private let mainView = TodayMovieView()
    private let networkManager = NetworkManager.shared
    var trendMovie: [TrendResults] = [] {
        didSet {
            mainView.todayMovieCollectionView.reloadData()
        }
    }
    var selectedMovie = 0  // 영화 상세화면에서 좋아요 반영되었을 때 dataReload를 위해 저장해두는 값
    var searchKeywordList = UserDefaultsManager.shared.getArrayData(type: .recentKeyword) {
        didSet {
            mainView.recentKeywordCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(receivedProfile), name: NSNotification.Name("editProfile"), object: nil)
        
        setNavigation()
        setCollectionView()
        getTodayMovieData()
        tapGesture()
        
        mainView.deleteAllKeywordButton.addTarget(self, action: #selector(deleteAllkeywordsButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 무비박스 갯수 반영
        let savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let count = savedDictionary.map{ $0.value }.filter{ $0 == true }.count
        let newtitle = "\(count)개의 무비박스 보관중"
        mainView.profileboxView.movieboxButton.changeTitle(title: newtitle, size: 14, weight: .bold)
        
        // 최근검색어 분기점
        searchKeywordList = UserDefaultsManager.shared.getArrayData(type: .recentKeyword)
        let keywordCount = UserDefaultsManager.shared.getArrayData(type: .recentKeyword).count
        mainView.noSearchLabel.isHidden = (keywordCount == 0) ? false : true
        mainView.recentKeywordCollectionView.isHidden = (keywordCount == 0) ? true : false
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        // 영화 상세화면에서 좋아요 기능 적용한 것 해당 영화만 데이터 리로드 되도록
            // ❔왜인지 viewWillAppear에서 실행하면 시점이 밀리는지 정확한 index로 찾아가지 못함
        mainView.todayMovieCollectionView.reloadItems(at: [IndexPath(item: selectedMovie, section: 0)])
    }
    
    // 최근 검색어 전체 삭제 기능
    @objc func deleteAllkeywordsButtonTapped() {
        let title = "최근검색어 삭제"
        let message = "최근검색어를 모두 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다."
        
        alerMessage(title, message) {
            var searchKeywords = UserDefaultsManager.shared.getArrayData(type: .recentKeyword)
            searchKeywords.removeAll()
            UserDefaultsManager.shared.saveData(value: searchKeywords, type: .recentKeyword)
            self.searchKeywordList = searchKeywords
            
            self.mainView.noSearchLabel.isHidden = false
            self.mainView.recentKeywordCollectionView.isHidden = true
        }
    }
    
    // 프로필 수정 내용 값 역전달 받기
    @objc func receivedProfile(notification: NSNotification) {
        
        guard let nickname = notification.userInfo?["nickname"] as? String, let image = notification.userInfo?["image"] as? String else { return }
        mainView.profileboxView.nicknameLabel.text = nickname
        mainView.profileboxView.profileImageView.image = UIImage(named: image)
    }
    
    @objc func profileAreaTapped() {
        self.viewTransition(style: .naviModal, vc: EditProfileNicknameViewController())
    }
    
    @objc func searchItemTapped() {
        
        let vc = SearchResultViewController()
        
        vc.isEmptyFirst = true
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
    
    private func tapGesture() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(profileAreaTapped))
        mainView.profileboxView.isUserInteractionEnabled = true
        mainView.profileboxView.addGestureRecognizer(tapgesture)
    }
    
    private func getTodayMovieData() {
        
        networkManager.callRequest(type: TrendMovie.self, api: .trend) { result in
            self.trendMovie = result.results
        } failHandler: {
            print(#function, "error")
        }
    }
    
    private func setNavigation() {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.catsMain, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .done, target: self, action: #selector(searchItemTapped))
        navigationItem.title = "Catsby의 영화세상"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .catsMain
    }
}

extension TodayMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCollectionView() {
        mainView.recentKeywordCollectionView.delegate = self
        mainView.recentKeywordCollectionView.dataSource = self
        mainView.todayMovieCollectionView.delegate = self
        mainView.todayMovieCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            return searchKeywordList.count
        case mainView.todayMovieCollectionView:
            return trendMovie.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            
            let keyword = searchKeywordList.reversed()[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCollectionViewCell.id, for: indexPath) as? RecentKeywordCollectionViewCell else { return UICollectionViewCell() }
            
            cell.getDataFromAPI(keyword)
            cell.deleteAction = {
                // 해당되는 키워드 삭제
                guard let index = self.searchKeywordList.firstIndex(of: keyword) else { return }
                self.searchKeywordList.remove(at: index)
                
                UserDefaultsManager.shared.saveData(value: self.searchKeywordList, type: .recentKeyword)
            }
            cell.cornerRadius()
            cell.layoutIfNeeded()
            
            return cell
            
        case mainView.todayMovieCollectionView:
            
            let row = trendMovie[indexPath.item]
            let key = String(row.id)
            let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[key]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }

            cell.buttonTapAction = {
                let key = String(row.id)
                var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
                
                savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)

                UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)
                
                // 상단 프로필에 변경된 무비박스 카운트 반영되도록
                let count = savedDictionary.map{ $0.value }.filter{ $0 == true }.count
                let newtitle = "\(count)개의 무비박스 보관중"
                self.mainView.profileboxView.movieboxButton.changeTitle(title: newtitle, size: 14, weight: .bold)

                self.mainView.todayMovieCollectionView.reloadItems(at: [IndexPath(item: indexPath.row, section: 0)])
            }
            
            let url = NetworkManager.pathUrl + row.posterpath
            cell.getData(url: url, title: row.title, plot: row.overview, isLiked: isLiked ?? false)
            cell.posterCornerRadius()
            
            return cell
            
        default:
            print("collectionview: default")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            print("recent")
        case mainView.todayMovieCollectionView:
            selectedMovie = indexPath.item
            
            let vc = MovieDetailViewController()
            vc.trendResult = trendMovie[indexPath.item]
            vc.isSearchresult = false
            
            self.viewTransition(style: .push(animated: true), vc: vc)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.recentKeywordCollectionView {
            let text = searchKeywordList.reversed()[indexPath.row]
            let fontStyle = UIFont.systemFont(ofSize: 14, weight: .medium)
            
            let cellWidth = text.size(withAttributes: [.font: fontStyle]).width + 40
            let cellHeight: CGFloat = 30
            
            return CGSize(width: cellWidth, height: cellHeight)
        } else {

            // todayMovie에 대한 값도 리턴이 필요해서 FlowLayout에 설정했던 사이즈 가져옴
            let cellWidth: CGFloat = UIScreen.main.bounds.width * 0.55
            let cellHeight: CGFloat = mainView.todayMovieCollectionView.bounds.height
 
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    
}
