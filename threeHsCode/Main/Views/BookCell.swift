//
//  BookCell.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    var bookURLImage: String?
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if let bookURLImage = bookURLImage {
            // while we get the image set a provisional image
            self.bookImage.image = UIImage(named: "empty_image")
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
                            
                            self.bookImage.image = img
                        })
                    } catch {
                        return
                    }
                }
            }
        }
    }
}
