//
//  CatsAndDogsDetailsCollectionVC.swift
//  Cats
//
//  Created by Артем Соколовский on 30.07.2021.
//

import UIKit

class CatsAndDogsDetailsCollectionVC: UIViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    private var viewModel: CatsAndDogsDetailsViewModelProtocol!

    private var loadingView = UIActivityIndicatorView()
    
    var animal: String!
    var index: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CatsAndDogsDetailsViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout = CatsAndDogsDetailsCollectionVC.createLayout()
        
        loadingView = LoadingIndicator.shared.showLoading(in: view)
        sendRequest()
        
    }
    
    func sendRequest() {
        viewModel.getData(index: index, breed: animal) { [weak self] result in
            self?.loadingView.stopAnimating()
                switch result {
                case .success(()):
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            guard let singleImage = segue.destination as? SingleImageVC else {
                return }
            singleImage.imageIndex = indexPath.row
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
        
        let section = NSCollectionLayoutSection(group: squareGroup)
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}

extension CatsAndDogsDetailsCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "singleImage", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension CatsAndDogsDetailsCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index < 6 {
            return viewModel.cats.count
        } else {
            return viewModel.dogs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let catsAndDogsCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CatsAndDogsDetailsCVC.identifier,
            for: indexPath) as? CatsAndDogsDetailsCVC {
            if index < 6 {
                catsAndDogsCell.configureDetail(animalUrl: viewModel.cats[indexPath.row].url, index: indexPath.row)
            } else {
                catsAndDogsCell.configureDetail(animalUrl: viewModel.dogs[indexPath.row], index: indexPath.row)
            }
            cell = catsAndDogsCell
        }
        
        return cell
    }
    
}

extension CatsAndDogsDetailsCollectionVC: UICollectionViewDelegateFlowLayout {
    
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
