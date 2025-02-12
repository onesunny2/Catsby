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
    private let todaymovieViewModel = TodayMovieViewModel()
    private let recentkeywordViewModel = RecentSearchKeywordViewModel()

    var selectedMovie = 0  // 영화 상세화면에서 좋아요 반영되었을 때 dataReload를 위해 저장해두는 값
    
    deinit {
        print("메인화면 VC Deinit")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 변경한 프로필 내용 전달
        NotificationCenter.default.addObserver(self, selector: #selector(receivedProfile), name: NSNotification.Name("editProfile"), object: nil)
        
        setNavigation()
        setCollectionView()
        todaymovieViewModel.input.getTodayMovieData.value = ()
        recentkeywordViewModel.input.checkKeyword.value = ()
        recentkeywordViewModel.input.requestKeywordsList.value = ()
        bindVMData()
        tapGesture()
        
        mainView.deleteAllKeywordButton.addTarget(self, action: #selector(deleteAllkeywordsButtonTapped), for: .touchUpInside)
    }
    
    private func bindVMData() {
        todaymovieViewModel.output.trendMovieResults.bind { [weak self] _ in
            self?.mainView.todayMovieCollectionView.reloadData()
        }
        
        todaymovieViewModel.output.newMovieboxTitle.bind { [weak self] title in
            self?.mainView.profileboxView.movieboxButton.changeTitle(title: title, size: 14, weight: .bold)
        }
        
        todaymovieViewModel.output.reloadIndexPath.lazyBind { [weak self] indexPath in
            self?.mainView.todayMovieCollectionView.reloadItems(at: indexPath)
        }
        
        recentkeywordViewModel.output.isKeywordIn.bind { [weak self] value in
            self?.mainView.noSearchLabel.isHidden = value ? false : true
            self?.mainView.recentKeywordCollectionView.isHidden = value ? true : false
        }
        
        recentkeywordViewModel.output.reversedKeywordsList.bind { [weak self] _ in
            self?.mainView.recentKeywordCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 무비박스 갯수 반영
        let savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
        let count = savedDictionary.map{ $0.value }.filter{ $0 == true }.count
        let newtitle = "\(count)개의 무비박스 보관중"
        mainView.profileboxView.movieboxButton.changeTitle(title: newtitle, size: 14, weight: .bold)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        // 영화 상세화면에서 좋아요 기능 적용한 것 해당 영화만 데이터 리로드 되도록
            // ❔왜인지 viewWillAppear에서 실행하면 시점이 밀리는지 정확한 index로 찾아가지 못함
        mainView.todayMovieCollectionView.reloadItems(at: [IndexPath(item: selectedMovie, section: 0)])
    }
    
    // 최근 검색어 전체 삭제 기능
    @objc func deleteAllkeywordsButtonTapped() {
        let title = recentkeywordViewModel.alertTitle
        let message = recentkeywordViewModel.alertMessage
        
        alerMessage(title, message) { [weak self] in
            
            self?.recentkeywordViewModel.input.alertAction.value = ()
            
            self?.mainView.noSearchLabel.isHidden = false
            self?.mainView.recentKeywordCollectionView.isHidden = true
        }
    }
    
    // 프로필 수정 내용 값 역전달 받기
    @objc func receivedProfile(notification: NSNotification) {
        
        guard let nickname = notification.userInfo?["nickname"] as? String, let image = notification.userInfo?["image"] as? String else { return }
        mainView.profileboxView.nicknameLabel.text = nickname
        mainView.profileboxView.profileImageView.image = UIImage(named: image)
    }
    
    @objc func profileAreaTapped() {
        let vc = EditProfileNicknameViewController()

        self.viewTransition(style: .naviModal, vc: vc)
    }
    
    @objc func searchItemTapped() {
        
        let vc = SearchResultViewController()
        vc.heartButtonActionToMainView = {
            self.mainView.todayMovieCollectionView.reloadData()
        }
        vc.viewModel.isEmptyFirst = true
        self.viewTransition(style: .push(animated: true), vc: vc)
    }
    
    private func tapGesture() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(profileAreaTapped))
        mainView.profileboxView.isUserInteractionEnabled = true
        mainView.profileboxView.addGestureRecognizer(tapgesture)
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
            return recentkeywordViewModel.output.reversedKeywordsList.value.count
        case mainView.todayMovieCollectionView:
            return todaymovieViewModel.output.trendMovieResults.value.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            
            let keywordsList = recentkeywordViewModel.output.reversedKeywordsList.value
            let keyword = keywordsList[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCollectionViewCell.id, for: indexPath) as? RecentKeywordCollectionViewCell else { return UICollectionViewCell() }

            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            
            cell.sendCellData(keyword)
            
            return cell
            
        case mainView.todayMovieCollectionView:

            let row = todaymovieViewModel.output.trendMovieResults.value[indexPath.item]
            
            todaymovieViewModel.input.cellIdAndPath.value = (row.id, row.posterpath)
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            cell.heartButton.tag = indexPath.item
            cell.heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)

            cell.getData(url: todaymovieViewModel.pathUrl, title: row.title, plot: row.overview)
            cell.heartButton.isSelected = todaymovieViewModel.isLiked
            
            return cell
            
        default:
            print("collectionview: default")
            return UICollectionViewCell()
        }
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        todaymovieViewModel.input.heartBtnTapped.value = sender.tag
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        print(#function)
        recentkeywordViewModel.input.deleteBtnTapped.value = sender.tag
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            let keyword = recentkeywordViewModel.output.reversedKeywordsList.value[indexPath.item]
            
            let vc = SearchResultViewController()
            vc.viewModel.isEmptyFirst = false
            vc.viewModel.input.recentSearchKeyword.value = keyword
            
            self.viewTransition(style: .push(animated: true), vc: vc)
            
        case mainView.todayMovieCollectionView:
            selectedMovie = indexPath.item
            
            let vc = MovieDetailViewController()
            vc.trendResult = todaymovieViewModel.output.trendMovieResults.value[indexPath.item]
            vc.isSearchresult = false
            
            self.viewTransition(style: .push(animated: true), vc: vc)
        
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.recentKeywordCollectionView {
            let text = recentkeywordViewModel.output.reversedKeywordsList.value[indexPath.row]
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
