//
//  SimpleTableViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 28.06.2021.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCat: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catOrigin: UILabel!
    
    static let identifier = "SimpleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SimpleTableViewCell",
                      bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = CustomColor.customBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with cat: Cat) {
        self.imageCat.image = UIImage(data: NetworkManager.shared.fetchImage(urlImage: cat.image.url)!)
        self.catName.text = cat.name
        self.catOrigin.text = "Country origin: \(cat.origin)"
        
    }
    
}
