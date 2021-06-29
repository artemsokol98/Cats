//
//  SquareCollectionViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 28.06.2021.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var someLabel: UILabel!
    
    static let identifier = "SquareCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SquareCollectionViewCell",
                      bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with cat: Cat) {
        self.someLabel.text = cat.description
    }
    
    
}
