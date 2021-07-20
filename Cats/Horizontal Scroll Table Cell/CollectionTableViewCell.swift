//
//  CollectionTableViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 26.06.2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell,
                               UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    
    static let identifier = "CollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionTableViewCell",
                      bundle: nil)
    }
    
    func configure(with cats: [Cat]) {
        self.cats = cats
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var cats = [Cat]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.backgroundColor = CustomColor.customBackgroundColor
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyCollectionViewCell.identifier,
            for: indexPath) as! MyCollectionViewCell
        cell.configure(with: cats[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 250)
    }
    
}
