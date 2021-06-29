//
//  CollectionTableViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 26.06.2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "CollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionTableViewCell",
                      bundle: nil)
    }
    
    func configure(with cats: Cat) {
        self.cats = cats
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var cats = Cat(name: "", life_span: "", origin: "", image: Image(url: ""), description: "")

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 0.990055835, blue: 0.7711565214, alpha: 1)
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.configure(with: cats)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 250)
    }
    
}
