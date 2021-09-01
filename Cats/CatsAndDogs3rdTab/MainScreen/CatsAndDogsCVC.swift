//
//  CatsAndDogsCVC.swift
//  Cats
//
//  Created by Артем Соколовский on 29.07.2021.
//

import UIKit

class CatsAndDogsCVC: UICollectionViewCell {
    @IBOutlet weak var catsAndDogsImage: UIImageView!
    
    @IBOutlet weak var catsAndDogsLabel: UILabel!
    
    static let identifier = "CatsAndDogsCell"
    
    static func nib() -> UINib {
        return UINib(
            nibName: "CatsAndDogsCell",
            bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        catsAndDogsImage.clipsToBounds = true
    }
    
    func configure(animal: CatsAndDogs) {
        guard let data = NetworkManager.shared.fetchImage(urlImage: animal.url) else {
            return
        }
        self.catsAndDogsImage.image = UIImage(data: data)
        self.catsAndDogsLabel.text = animal.breed
    }
}
