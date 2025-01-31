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
    var searchMovie = SearchMovie(page: 0, results: [], totalPages: 0, totalResults: 0) {
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
        
        networkManager.callRequest(type: SearchMovie.self, api: .search(keyword: keyword)) { result in
            self.searchMovie = result
            print(self.searchMovie.results.count)
        } failHandler: {
            print("request error")
        }

    }
    
    // 네비게이션 타이틀 및 서치바 설정
    private func setNavigation() {
        navigationItem.title = "영화 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        
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
        
        getSearchAPI(keyword)
    }
}

// MARK: - tableView 관련 설정
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 150
        mainView.tableView.separatorStyle = .singleLine
        mainView.tableView.separatorColor = .catsDarkgray
        mainView.tableView.separatorInset.left = 0
        mainView.tableView.tableHeaderView = UIView() // 가장 상단 줄 없애기
        mainView.tableView.keyboardDismissMode = .onDrag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovie.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = searchMovie.results[indexPath.row]
        let genreList = Genre.genreList
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let url = NetworkManager.pathUrl + row.posterpath
        let title = row.title
        let date = row.releaseDate
        let genreArray = Array(row.genreID.prefix(2))
        let isLiked = UserDefaultsManager.shared.getDicData(type: .likeButton)[String(row.id)]
        
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

        cell.cornerRadius()
        cell.selectionStyle = .none
        
        return cell
    }
}
