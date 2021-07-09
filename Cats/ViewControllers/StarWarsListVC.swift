//
//  StarWarsListVC.swift
//  Cats
//
//  Created by Артем Соколовский on 07.07.2021.
//

import UIKit

class StarWarsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    private var starWarsPeople: [StarWarsPeople] = []
    private var loadingView = UIActivityIndicatorView()
    private var search: String!
    
    private let urlStarWars = "https://swapi.dev/api/people/?search="
    
    private let searchController = UISearchController()
    
    //MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        searchController.searchBar.delegate = self
        
        table.dataSource = self
        table.delegate = self
        
        navigationItem.searchController = searchController
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = table.indexPathForSelectedRow {
            guard let descriptionStarWarsItem = segue.destination as? DescriptionStarWarsItemVC else {
                return }
            descriptionStarWarsItem.item = starWarsPeople[indexPath.row]
        }
    }
    
    //MARK: - Public methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search = searchBar.text
        self.starWarsPeople = []
        searchRequest(searchString: urlStarWars + search)
        searchController.isActive = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        starWarsPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarWarsPeople", for: indexPath)
        let people = starWarsPeople[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = people.name
        content.secondaryText = "Birthyear: \(people.birth_year)"
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Private methods

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
                    
                    if (!self.starWarsPeople.isEmpty) {
                        self.starWarsPeople.append(contentsOf: people.results)
                    } else {
                        self.starWarsPeople = people.results
                    }
                    
                    self.table.reloadData()
                    
                    if (people.next != nil) {
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
