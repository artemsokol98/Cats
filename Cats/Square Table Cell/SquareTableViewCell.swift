//
//  SquareTableViewCell.swift
//  Cats
//
//  Created by Артем Соколовский on 28.06.2021.
//

import UIKit

class SquareTableViewCell: UITableViewCell,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    
    static let identifier = "SquareTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SquareTableViewCell",
                     bundle: nil)
    }
    
    func configure(with cats: [Cat]) {
        self.cat = cats
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var cat = [Cat]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.backgroundColor = CustomColor.customBackgroundColor
        
        collectionView.register(SquareCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: SquareCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cat.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SquareCollectionViewCell.identifier,
            for: indexPath) as! SquareCollectionViewCell
        cell.configure(with: cat[indexPath.row])
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2, height: self.frame.width / 2)
    }
    
}
