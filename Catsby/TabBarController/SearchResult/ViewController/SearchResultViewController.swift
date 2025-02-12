//
//  SearchResultViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit

final class SearchResultViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    private let mainView = SearchResultView()
    let viewModel = SearchResultViewModel()
    private let searchController = UISearchController(searchResultsController: nil)

    var currentPage = 1
    var isEnd = false
    
    var heartButtonActionToMainView: (() -> ())?
    var currentId = 0  // 메인화면에 전달
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setTableView()
        bindVMData()
        
        if !viewModel.isEmptyFirst {
            searchController.searchBar.text = viewModel.input.recentSearchKeyword.value
        }
    }
    
    deinit {
        print("검색결과 VC Deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isEmptyFirst {
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    private func bindVMData() {
        viewModel.output.isResultsZero.lazyBind { [weak self] value in
            self?.mainView.resultLabel.isHidden = value ? false : true
            self?.mainView.tableView.isHidden = value ? true : false
        }
        
        viewModel.output.searchResults.lazyBind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.output.scrollToTop.lazyBind { [weak self] _ in
            self?.mainView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.output.reloadIndexPath.lazyBind { [weak self] indexPath in
            self?.mainView.tableView.reloadRows(at: indexPath, with: .none)
        }
    }
    
    // 네비게이션 타이틀 및 서치바 설정
    private func setNavigation() {
        navigationItem.title = "영화 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonTitle = ""
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "영화를 검색해보세요."
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        
        guard let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField else { return }
        textfield.textColor = .catsWhite
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.catsDarkgray])
        
        guard let leftImage = textfield.leftView else { return }
        leftImage.tintColor = .catsWhite
    }
}

// MARK: - searchbar 관련 설정
extension SearchResultViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키워드와 함께 로직 전달하기
        viewModel.input.clickedSearchBtn.value = searchController.searchBar.text
    }
}

// MARK: - tableView 관련 설정
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
        mainView.tableView.rowHeight = 150
        mainView.tableView.separatorStyle = .singleLine
        mainView.tableView.separatorColor = .catsDarkgray
        mainView.tableView.separatorInset.left = 0
        mainView.tableView.tableHeaderView = UIView() // 가장 상단 줄 없애기
        mainView.tableView.keyboardDismissMode = .onDrag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.searchResults.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = viewModel.output.searchResults.value[indexPath.row]
        let genreList = Genre.genreList
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let title = row.title
        let date = row.releaseDate
        let genreArray = Array(row.genreID.prefix(2))
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[String(row.id)] ?? false
        if let posterpath = row.posterpath {
            let url = NetworkManager.pathUrl + posterpath
            
            // 가지고 있는 장르 갯수에 따라 분리
            switch genreArray.count {
            case 0:
                let genre: [String] = []
                cell.getData(url, title, date, genre)
            case 1:
                let genre = [genreList[genreArray[0]] ?? "장르오류"]
                cell.getData(url, title, date, genre)
            case 2:
                let genre = [genreList[genreArray[0]] ?? "장르오류", genreList[genreArray[1]] ?? "장르오류"]
                cell.getData(url, title, date, genre)
            default:
                print("genre error")
                break
            }
        } else {
            // 포스터 없으면 기본값으로 사용할 이미지
            let url = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYaqjTuNYAbIxAk0GzMiX8-ah3Q63B8cIBMyFJE1zx-4Ty8ZIOSAneIuNysLOXvIffm2o&usqp=CAU"
            
            // 가지고 있는 장르 갯수에 따라 분리
            switch genreArray.count {
            case 0:
                let genre: [String] = []
                cell.getData(url, title, date, genre)
            case 1:
                let genre = [genreList[genreArray[0]] ?? "장르오류"]
                cell.getData(url, title, date, genre)
            case 2:
                let genre = [genreList[genreArray[0]] ?? "장르오류", genreList[genreArray[1]] ?? "장르오류"]
                cell.getData(url, title, date, genre)
            default:
                print("genre error")
                break
            }
        }

        cell.cornerRadius()
        cell.selectionStyle = .none
        
        cell.heartButton.tag = indexPath.item
        cell.heartButton.addTarget(self, action: #selector(heartbuttonTapped), for: .touchUpInside)
        cell.heartButton.isSelected = isLiked
        
//        cell.tapbuttonAction = {
//            let key = String(row.id)
//            var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
//            
//            savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)
//
//            UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)
//            
//            self.mainView.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
//            
//            // 메인 화면에 전달 할 좋아요 내용(검색결과에서 누른 영화가 오늘의 영화에 있을 가능성 고려)
//            self.heartButtonActionToMainView?()
//        }
        
        return cell
    }
    
    @objc func heartbuttonTapped(_ sender: UIButton) {
        print(#function)
        viewModel.input.heartBtnTapped.value = sender.tag
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = viewModel.output.searchResults.value[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell else { return }
        
        let vc = MovieDetailViewController()
        
        vc.isSearchresult = true
        vc.searchResult = viewModel.output.searchResults.value[indexPath.row]
        // 검색결과를 타고 들어간 상세화면에서 좋아요를 눌렀을 경우 검색결과로 되돌아왔을 때 반영되도록 구현
        vc.heartButtonStatus = {
            let savedStatus = UserDefaultsManager.shared.getDicData(type: .likeButton)[String(row.id)] ?? false
            
            cell.heartButton.configuration?.image = UIImage(systemName: savedStatus ? "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16)))
            
            self.heartButtonActionToMainView?()  // 여기서 변동된 것도 메인화면에 가야하니까
        }
        
        self.viewTransition(style: .push(animated: true), vc: vc)
        
        viewModel.isEmptyFirst = false
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        viewModel.input.tableIndexPaths.value = indexPaths
    }
}
