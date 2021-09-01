//
//  StarWarsCollectionViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 23.07.2021.
//

import UIKit

class StarWarsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    static let identifier = "StarWarsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(
            nibName: "StarWarsCollectionViewCell",
            bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configure(starWars: StarWarsPeople) {
        mainLabel.text = starWars.name
    }

}
