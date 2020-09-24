//
//  ItemTableViewCell.swift
//  AppleSearch
//
//  Created by Deven Day on 9/23/20.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var item: AppStoreItem? {
        didSet {
            guard let item = item else {return}
            
            itemTitleLabel.text = item.title
            itemSubtitleLabel.text = item.subtitle
            itemImageView.image = nil
            
            AppStoreItemController.getImageFor(item: item) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.itemImageView.image = image
                    }
                } else {
                    print("image was nil :/")
                }
            }
        }
    }
}//END OF CLASS
