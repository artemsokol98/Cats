//
//  SimpleTableViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 28.06.2021.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    
    static let identifier = "SimpleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SimpleTableViewCell",
                      bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 1, green: 0.990055835, blue: 0.7711565214, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
