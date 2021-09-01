//
//  StarWarsListVC.swift
//  Cats
//
//  Created by Артем Соколовский on 07.07.2021.
//

import UIKit

class StarWarsListVC: UIViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    private var loadingView = UIActivityIndicatorView()
    private var search: String!
    private let urlStarWars = "https://swapi.dev/api/people/?search="
    private let searchController = UISearchController()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        searchController.searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            guard let descriptionStarWarsItem = segue.destination as? DescriptionStarWarsItemVC else {
                return }
            print(indexPath.row)
            descriptionStarWarsItem.item = DataManager.shared.starWarsPeople[indexPath.row]
            createItem(item: DataManager.shared.starWarsPeople[indexPath.row])
        }
    }
    
    @IBAction func lastSearchesButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showLastSearches", sender: self)
    }
    
    @IBAction func showOfflineButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showOffline", sender: self)
    }
    
    // MARK: - Private methods
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.searchRequest(searchString: self.urlStarWars + self.search)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func searchRequest(searchString: String) {
        loadingView = LoadingIndicator.shared.showLoading(in: view)
        NetworkManager.shared.fetchStarWars(searchString: searchString) { result in
            switch result {
            case .success(let people):
                DispatchQueue.main.async {
                    
                    self.loadingView.stopAnimating()
                    
                    if !DataManager.shared.starWarsPeople.isEmpty {
                        DataManager.shared.starWarsPeople.append(contentsOf: people.results)
                    } else {
                        DataManager.shared.starWarsPeople = people.results
                    }
                    
                    self.collectionView.reloadData()
                    
                    if people.next != nil {
                        self.searchRequest(searchString: people.next!)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Core Data
    
    func createItem(item: StarWarsPeople) {
        let newItem = StarWarsCoreData(context: context)
        newItem.name = item.name
        newItem.mass = item.mass
        newItem.height = item.height
        newItem.hairColor = item.hairColor
        newItem.gender = item.gender
        newItem.eyeColor = item.eyeColor
        newItem.birthYear = item.birthYear
        newItem.skinColor = item.skinColor
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
}

extension StarWarsListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search = searchBar.text
        DataManager.shared.starWarsPeople = []
        DataManager.shared.lastSearches.insert(search, at: 0)
        searchRequest(searchString: urlStarWars + search)
        searchController.isActive = false
        collectionView.reloadData()
    }
}

extension StarWarsListVC: UICollectionViewDelegate {
    
}

extension StarWarsListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DataManager.shared.starWarsPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let starWarsCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StarWarsCollectionViewCell.identifier,
            for: indexPath) as? StarWarsCollectionViewCell {
            
            starWarsCell.configure(starWars: DataManager.shared.starWarsPeople[indexPath.row])
            cell = starWarsCell
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDescription", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension StarWarsListVC: UICollectionViewDelegateFlowLayout {
    
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
