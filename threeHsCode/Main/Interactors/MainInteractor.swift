//
//  MainInteractor.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import networkLayer

protocol MainInteractorInterface: class {
    func fetchBooks()
    var interactorToPresenterProductFromApiSubject: PublishSubject<[Book]> { get set }
}

class MainInteractor {
    private var apiURL: String
    private let httpClient = HttpClient.shared
    
    var interactorToPresenterProductFromApiSubject = PublishSubject<[Book]>()
    var interactorToPresenterErrorSubject = PublishSubject<Error>()
    init() {
        self.apiURL = Bundle.main.infoDictionary?["API_ENDPOINT"] as! String
    }
}

extension MainInteractor: MainInteractorInterface {
    func fetchBooks() {
        httpClient.callGet(
            serviceUrl: "\(apiURL)",
            success: { (arrayBooks: [Book], response: HttpResponse?) in
                // lanzar evento para acrtualizar la view
                self.interactorToPresenterProductFromApiSubject.onNext(arrayBooks)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.interactorToPresenterProductFromApiSubject.onError(error)
        })
    }
}
