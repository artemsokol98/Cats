//
//  DescriptionStarWarsItemVC.swift
//  Cats
//
//  Created by Артем Соколовский on 09.07.2021.
//

import UIKit

class DescriptionStarWarsItemVC: UIViewController {

    @IBOutlet private weak var itemDescriptionLabel: UILabel!
    var item: StarWarsPeople!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemDescriptionLabel.text =
        """
        Name: \(item.name)
        Height: \(item.height)
        Mass: \(item.mass)
        Hair color: \(item.hairColor)
        Skin color: \(item.skinColor)
        Eye color: \(item.eyeColor)
        Birthyear: \(item.birthYear)
        Gender: \(item.gender)
        """
    }

}
