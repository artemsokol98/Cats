//
//  DescriptionStarWarsItemVC.swift
//  Cats
//
//  Created by Артем Соколовский on 09.07.2021.
//

import UIKit

class DescriptionStarWarsItemVC: UIViewController {

    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    var item: StarWarsPeople!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemDescriptionLabel.text =
        """
        Name: \(item.name)
        Height: \(item.height)
        Mass: \(item.mass)
        Hair color: \(item.hair_color)
        Skin color: \(item.skin_color)
        Eye color: \(item.eye_color)
        Birthyear: \(item.birth_year)
        Gender: \(item.gender)
        """
    }

}
