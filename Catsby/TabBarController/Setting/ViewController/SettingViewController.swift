//
//  SettingViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let mainView = SettingView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        setTableView()
    }

    private func setNavigation() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.catsWhite]
        navigationItem.backButtonTitle = ""
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menu = menuTitle.menu[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.getTitle(menu)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            let title = "탈퇴하기"
            let message = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?"
            alerMessage(title, message) {
                print("탈퇴 success")
 
                let nav = UINavigationController(rootViewController: OnboardingViewController())
                self.viewTransition(style: .windowRoot, vc: nav)
                
                UserDefaultsManager.shared.resetData()
            }
        }
        
    }
}

extension SettingViewController {
    enum menuTitle {
        static let menu = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    }
}
