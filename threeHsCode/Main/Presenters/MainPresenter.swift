//
//  MainPresenter.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol MainPresenterInterface: class {
    func getBooks()
    func getBookDetail(book: Book)
    func orderByPopularity(order: Order)
    func orderByAvailability(availability: Availability)
    var presenterToViewProductFromApiSubject: PublishSubject<[Book]> { get set }
}

class MainPresenter {
    var presenterToViewProductFromApiSubject = PublishSubject<[Book]>()
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    
    private let mainInteractor: MainInteractorInterface
    private let mainRouter: MainRouterInterface
    
    var originalBooks: [Book] = []
    
    init(interactor: MainInteractorInterface, router: MainRouterInterface) {
        mainInteractor = interactor
        mainRouter = router
        subscribeToObserver(self.mainInteractor.interactorToPresenterProductFromApiSubject)
    }
    
}
// extension of observers
extension MainPresenter {
    // subscribe to searched products observable
    func subscribeToObserver (_ subject: PublishSubject<[Book]>) {
        subject.subscribe(
            onNext: {(arraySearchedProducts) in
                self.originalBooks = arraySearchedProducts
                self.orderByPopularity(order: .ASC)
        },
            onError: {(error) in
                self.mainRouter.navigateToErrorView(error: error)
        }).disposed(by: disposeBag)
    }
}

extension MainPresenter: MainPresenterInterface {
    func getBookDetail(book: Book) {
        self.mainRouter.navigateToBookDetail(book: book)
    }
    
    func getBooks() {
        self.mainInteractor.fetchBooks()
    }
    
    func orderByPopularity(order: Order) {
        var orderedBooks = self.originalBooks
        if order == .ASC {
            orderedBooks = orderedBooks.sorted(by: { $0.popularidad > $1.popularidad })
        } else {
            orderedBooks = orderedBooks.sorted(by: { $0.popularidad < $1.popularidad })
        }
        self.presenterToViewProductFromApiSubject.onNext(orderedBooks)
    }
    
    func orderByAvailability(availability: Availability) {
        var orderedBooks = self.originalBooks
        switch availability {
        case .available:
            orderedBooks =  orderedBooks.filter { $0.disponibilidad == true }
        case .notAvailable:
            orderedBooks =  orderedBooks.filter { $0.disponibilidad == false }
        default:
            break
        }
        self.presenterToViewProductFromApiSubject.onNext(orderedBooks)
    }
}
