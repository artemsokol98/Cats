//
//  CatsAndDogsDetailsCVC.swift
//  Cats
//
//  Created by Артем Соколовский on 20.08.2021.
//

import UIKit

class CatsAndDogsDetailsCVC: UICollectionViewCell {
    
    @IBOutlet private weak var catsAndDogsDetailsImage: UIImageView!

    static let identifier = "CatsAndDogsDetailsCell"
    
    static func nib() -> UINib {
        UINib(
            nibName: "CatsAndDogsDetailsCell",
            bundle: nil
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureDetail(animalUrl: String, index: Int) {
        guard let data = NetworkManager.shared.fetchImage(urlImage: animalUrl) else {
            return
        }
        DataManager.shared.singleImages[index] = UIImage(data: data)
        
        catsAndDogsDetailsImage.image = DataManager.shared.singleImages[index]
    }
}
