//
//  ViewController+Extension.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/25/25.
//

import UIKit

extension UIViewController {
    
    func viewTransition(style: ViewTransition, vc: UIViewController) {
        
        switch style {
        case let .push(animated):
            navigationController?.pushViewController(vc, animated: animated)
        case .modal:
            present(vc, animated: true)
        case .naviModal:
            let nv = UINavigationController(rootViewController: vc)
            nv.modalPresentationStyle = .pageSheet
            nv.sheetPresentationController?.prefersGrabberVisible = true
            
            present(nv, animated: true)
        case .windowRoot:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
    
    func alerMessage(_ title: String, _ message: String, _ okHandler: @escaping () -> ()) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive) {_ in
            okHandler()
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        message.addAction(ok)
        message.addAction(cancel)
        
        present(message, animated: true)
    }
}
