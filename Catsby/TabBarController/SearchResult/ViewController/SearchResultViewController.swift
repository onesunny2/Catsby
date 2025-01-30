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
    
    var testList = ["test1", "test2", "test3", "test4"]
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getSearchAPI()
        setNavigation()
        setTableView()
    }

    // API 데이터 가져오기
//    private func getSearchAPI() {
//        networkManager.callRequest(type: , api: <#T##TmdbAPI#>) { <#T#> in
//            <#code#>
//        } failHandler: {
//            <#code#>
//        }
//
//    }
    
    // 네비게이션 타이틀 및 서치바 설정
    private func setNavigation() {
        navigationItem.title = "영화 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색하고 싶은 영화를 적어주세요 :)"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        
        guard let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField else { return }
        textfield.textColor = .catsWhite
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.catsDarkgray])
        
        guard let leftImage = textfield.leftView, let rightImage = textfield.rightView else { return }
        leftImage.tintColor = .catsWhite
        rightImage.tintColor = .catsWhite
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 150
        mainView.tableView.separatorStyle = .singleLine
        mainView.tableView.separatorColor = .catsWhite
        mainView.tableView.separatorInset.left = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        cell.cornerRadius()
        
        return cell
    }
}
