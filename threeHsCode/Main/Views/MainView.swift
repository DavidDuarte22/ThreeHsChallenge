//
//  MainView.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class MainView: UITableViewController {
    
    let mainPresenter: MainPresenterInterface
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    
    var allBooks: [Book] = []
    var order: Order = Order.ASC
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(presenter: MainPresenterInterface) {
        self.mainPresenter = presenter
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bienvenido a la biblioteca Ualá"
        self.tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "bookCell")
        // observer of books
        subscribeToObserver(self.mainPresenter.presenterToViewProductFromApiSubject)
        self.mainPresenter.getBooks()
        customizeSearchBar()
        
        
    }
    
    // MARK: TableView Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.restore()
        if self.allBooks.count == 0 {
            tableView.setEmptyView(title: "We couldn't find this :(", message: "Please, make another search")
        }
        return allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookCell
        cell.title.text = allBooks[indexPath.row].nombre
        cell.author.text = allBooks[indexPath.row].autor
        if allBooks[indexPath.row].disponibilidad {
            cell.available.text = "Disponible"
        } else {
            cell.available.text = "No disponible"
        }
        cell.popularity.text = "Popularidad: \(allBooks[indexPath.row].popularidad)"
        cell.bookURLImage = allBooks[indexPath.row].imagen
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainPresenter.getBookDetail(book: allBooks[indexPath.row])
    }
    
}

extension MainView {
    func subscribeToObserver (_ subject: PublishSubject<[Book]>) {
        subject.subscribe(
            onNext: {(arrayBooks) in
                self.allBooks = arrayBooks
                self.tableView.reloadData()
        },
            onError: {(error) in
        }).disposed(by: disposeBag)
    }
    
}


// MARK: SearchBar()

extension MainView: UISearchBarDelegate {    // se agrega la barra de busqueda
    
    func customizeSearchBar () {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Todos", "Disponibles", "No Disponibles"]
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "change_order"), for: .bookmark, state: .normal)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return }
        if scopeString == "Cambiar Orden" {
            
        }
        let selectedElement = Availability(rawValue: scopeString) ?? Availability.all
        self.mainPresenter.orderByAvailability(availability: selectedElement)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if self.order == Order.ASC {
            self.order = Order.DESC
        } else {
            self.order = Order.ASC
        }
        self.mainPresenter.orderByPopularity(order: self.order)
    }
}

