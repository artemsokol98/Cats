//
//  MyCollectionViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 26.06.2021.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    
    static let identifier = "MyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell",
                     bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(with cat: Cat) {
        self.myLabel.text = cat.name
        self.myImageView.image = UIImage(data: NetworkManager.shared.fetchImage(urlImage: cat.image.url)!)
        self.myImageView.layer.cornerRadius = UIScreen.main.bounds.width / 10
        self.myImageView.contentMode = .scaleAspectFill
    }
    
}
