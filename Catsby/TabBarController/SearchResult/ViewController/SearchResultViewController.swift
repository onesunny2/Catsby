//
//  SearchResultViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/30/25.
//

import UIKit

final class SearchResultViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    private let mainView = SearchResultView()
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    
    var isEmptyFirst: Bool = true
    let group = DispatchGroup()
    var currentPage = 1
    var isEnd = false
    var searchResults: [SearchResults] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isEmptyFirst {
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }

    // API 데이터 가져오기
    private func getSearchAPI(_ keyword: String) {
        
        group.enter()
        networkManager.callRequest(type: SearchMovie.self, api: .search(keyword: keyword, page: currentPage)) { value in
            
            switch self.currentPage {
            case 1:
                self.searchResults = value.results

            default:
                self.searchResults.append(contentsOf: value.results)
            }
            
            let caculatePage = (value.totalResults ?? 0 / 20)
            if self.currentPage == caculatePage {
                self.isEnd = true
            }
            
            self.group.leave()
        } failHandler: {
            print("request error")
            
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            let isTotlaZero = (self.searchResults.count == 0)
            self.mainView.tableView.isHidden = isTotlaZero ? true : false
            self.mainView.resultLabel.isHidden = isTotlaZero ? false : true
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
        
        guard let keyword = searchController.searchBar.text else { return }
        
        var savedKeywords = UserDefaultsManager.shared.getArrayData(type: .recentKeyword)
        // 중복값 있다면 제거하고 추가되도록
        if let index = savedKeywords.firstIndex(of: keyword) {
            savedKeywords.remove(at: index)
        }
        savedKeywords.append(keyword)
        UserDefaultsManager.shared.saveData(value: savedKeywords, type: .recentKeyword)
        
        print(UserDefaultsManager.shared.getArrayData(type: .recentKeyword).count)
        
        searchResults = []
        currentPage = 1
        getSearchAPI(keyword)
        
        if searchResults.count != 0 {
           mainView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
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
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = searchResults[indexPath.row]
        let genreList = Genre.genreList
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let title = row.title
        let date = row.releaseDate
        let genreArray = Array(row.genreID.prefix(2))
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[String(row.id)]
        if let posterpath = row.posterpath {
            let url = NetworkManager.pathUrl + posterpath
            
            // 가지고 있는 장르 갯수에 따라 분리
            switch genreArray.count {
            case 0:
                let genre: [String] = []
                cell.getData(url, title, date, genre, isLiked ?? false)
            case 1:
                let genre = [genreList[genreArray[0]] ?? "장르오류"]
                cell.getData(url, title, date, genre, isLiked ?? false)
            case 2:
                let genre = [genreList[genreArray[0]] ?? "장르오류", genreList[genreArray[1]] ?? "장르오류"]
                cell.getData(url, title, date, genre, isLiked ?? false)
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
                cell.getData(url, title, date, genre, isLiked ?? false)
            case 1:
                let genre = [genreList[genreArray[0]] ?? "장르오류"]
                cell.getData(url, title, date, genre, isLiked ?? false)
            case 2:
                let genre = [genreList[genreArray[0]] ?? "장르오류", genreList[genreArray[1]] ?? "장르오류"]
                cell.getData(url, title, date, genre, isLiked ?? false)
            default:
                print("genre error")
                break
            }
        }

        cell.cornerRadius()
        cell.selectionStyle = .none
        cell.tapbuttonAction = {
            let key = String(row.id)
            var savedDictionary = UserDefaultsManager.shared.getDicData(type: .likeButton)
            
            savedDictionary[key] = ((savedDictionary[key] ?? false) ? false : true)

            UserDefaultsManager.shared.saveData(value: savedDictionary, type: .likeButton)
            
            self.mainView.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MovieDetailViewController()
        
        vc.isSearchresult = true
        vc.searchResult = searchResults[indexPath.row]
        
        self.viewTransition(style: .push(animated: true), vc: vc)
        
        isEmptyFirst = false
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
        
            if (searchResults.count - 3 == indexPath.row) && (isEnd == false) {
                currentPage += 1
                guard let keyword = searchController.searchBar.text else { return }
                getSearchAPI(keyword)
            }
        }
    }
}
