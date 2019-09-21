//
//  MainRouter.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit

protocol MainRouterInterface: class {
    func setRootView(rootViewController: UITableViewController) -> UINavigationController
    func navigateToErrorView(error: Error)
    func navigateToBookDetail(book: Book)
}

class MainRouter {
    // private init for singleton router
    public static let shared = MainRouter()
    private var navigationController = UINavigationController()
    
    private init() { }
}

extension MainRouter: MainRouterInterface {
    func setRootView(rootViewController: UITableViewController) -> UINavigationController {
        navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func navigateToErrorView(error: Error) {
        
    }
    
    func navigateToBookDetail(book: Book) {
        navigationController.pushViewController(BookDetailView(book: book), animated: false)
    }
}
