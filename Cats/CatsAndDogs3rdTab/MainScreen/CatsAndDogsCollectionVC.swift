//
//  CatsAndDogsCollectionVC.swift
//  Cats
//
//  Created by Артем Соколовский on 29.07.2021.
//

import UIKit

class CatsAndDogsCollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: CatsAndDogsViewModelProtocol!

    private var loadingView = UIActivityIndicatorView()
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CatsAndDogsViewModel()
        self.navigationItem.title = "My Albums"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout = CatsAndDogsCollectionVC.createLayout()

        loadingView = LoadingIndicator.shared.showLoading(in: view)
        sendRequest()
    }
    
    func sendRequest() {
        viewModel.getData { [weak self] result in
            self?.loadingView.stopAnimating()
            switch result {
            case .success(()):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            guard let detailsCatsAndDogsItem = segue.destination as? CatsAndDogsDetailsCollectionVC else {
                return }
            detailsCatsAndDogsItem.animal = DataManager.shared.dogsAndCats[indexPath.row + 3 * indexPath.section].breed
            detailsCatsAndDogsItem.index = indexPath.row + 3 * indexPath.section
        }
    }

    private func showAlert(title: String, message: String) {
        
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.loadingView.startAnimating()
            self.sendRequest()
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        
        func firstLayoutSection() -> NSCollectionLayoutSection {
        
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/2)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let square = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            square.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let squareGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/2)
                ),
                subitem: square,
                count: 2
            )
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/2)
                ),
                subitems: [
                    item,
                    squareGroup
                ]
            )
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
        }
        
        func secondLayoutSection() -> NSCollectionLayoutSection {
            
            let bigSquare = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            bigSquare.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let bigSquareGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(3),
                    heightDimension: .fractionalHeight(1/2)
                ),
                subitem: bigSquare,
                count: 3
            )
            let section = NSCollectionLayoutSection(group: bigSquareGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
        
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in

            if sectionNumber % 2 == 0 {
                return firstLayoutSection()
            } else {
                return secondLayoutSection()
            }
            
        }
    }

}

extension CatsAndDogsCollectionVC: UICollectionViewDelegate {
    
}

extension CatsAndDogsCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.cats.count / 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let catsAndDogsCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CatsAndDogsCVC.identifier,
            for: indexPath) as? CatsAndDogsCVC {
            catsAndDogsCell.configure(animal: DataManager.shared.dogsAndCats[indexPath.row + 3 * indexPath.section])
            cell = catsAndDogsCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension CatsAndDogsCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
}
