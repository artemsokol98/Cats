//
//  SquareCollectionViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 28.06.2021.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var catLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    
    static let identifier = "SquareCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SquareCollectionViewCell",
                      bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with cat: Cat) {
        self.catLabel.text = cat.name
        self.catImage.image = UIImage(data: NetworkManager.shared.fetchImage(urlImage: cat.image.url)!)
    }
}
