//
//  StarWarsListVC.swift
//  Cats
//
//  Created by Артем Соколовский on 07.07.2021.
//

import UIKit

class StarWarsListVC: UIViewController {
    
    @IBOutlet private weak var table: UITableView!
    
    private var loadingView = UIActivityIndicatorView()
    private var search: String!
    
    private let urlStarWars = "https://swapi.dev/api/people/?search="
    
    private let searchController = UISearchController()
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        searchController.searchBar.delegate = self
        
        table.dataSource = self
        table.delegate = self
        
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = table.indexPathForSelectedRow {
            guard let descriptionStarWarsItem = segue.destination as? DescriptionStarWarsItemVC else {
                return }
            descriptionStarWarsItem.item = DataManager.shared.starWarsPeople[indexPath.row]
        }
    }
    
    @IBAction func lastSearchesButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showLastSearches", sender: self)
    }
    
    // MARK: - Private methods
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.searchRequest(searchString: self.urlStarWars + self.search)
        }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
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
                    
                    self.table.reloadData()
                    
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
    
}

extension StarWarsListVC: UITableViewDataSource {
    // MARK: - Public methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.starWarsPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarWarsPeople", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let people = DataManager.shared.starWarsPeople[indexPath.row]
        content.text = people.name
        content.secondaryText = "Birthyear: \(people.birthYear)"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDescription", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StarWarsListVC: UITableViewDelegate {
    
}

extension StarWarsListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search = searchBar.text
        DataManager.shared.starWarsPeople = []
        DataManager.shared.lastSearches.insert(search, at: 0)
        searchRequest(searchString: urlStarWars + search)
        searchController.isActive = false
        table.reloadData()
    }
}
