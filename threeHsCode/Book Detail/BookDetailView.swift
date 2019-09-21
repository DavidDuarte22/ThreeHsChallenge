//
//  BookDetailView.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class BookDetailView: UIViewController {
    
    
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAvailability: UILabel!
    @IBOutlet weak var bookPopularity: UILabel!
    
    let book: Book
    
    required init(book: Book) {
        self.book = book
        
        super.init(nibName: "BookDetailView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bookTitle.text = book.nombre
        bookAuthor.text = book.autor
        if book.disponibilidad {
            bookAvailability.text = "Disponible"
        } else {
            bookAvailability.text = "No disponible"
        }
        bookPopularity.text = "Popularidad: \(book.popularidad)"
        
        if  book.imagen != "" {
            self.loadImage(bookURLImage: book.imagen)
        }
    }
}

extension BookDetailView {
    func loadImage (bookURLImage: String) {
        // while we get the image set a provisional image
        self.imageBook.image = UIImage(named: "empty_image")
        let queue = OperationQueue()
        if bookURLImage != "" {
            queue.addOperation {() -> Void in
                do {
                    /* block for fetch photo */
                    let url = URL(string: bookURLImage)!
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    /* */
                    
                    // display in cell when has it image
                    OperationQueue.main.addOperation({ () -> Void in
                        
                        self.imageBook.image = img
                    })
                } catch {
                    return
                }
            }
        }
    }
}
