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
            present(nv, animated: true)
        case .windowRoot:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            
            window.rootViewController = vc
        }
    }
}
