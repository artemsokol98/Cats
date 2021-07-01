//
//  NewTableViewController.swift
//  Cats
//
//  Created by Артем Соколовский on 26.06.2021.
//

import UIKit

class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    private var cats: [Cat] = []
    private var loadingView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 0.990055835, blue: 0.7711565214, alpha: 1)
        table.backgroundColor = #colorLiteral(red: 1, green: 0.990055835, blue: 0.7711565214, alpha: 1)
        
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.register(SimpleTableViewCell.nib(), forCellReuseIdentifier: SimpleTableViewCell.identifier)
        table.register(SquareTableViewCell.nib(), forCellReuseIdentifier: SquareTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        loadingView = showLoading(in: view)
        sendRequest()
    }
    
    //MARK: - Public Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cats.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 3 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell", for: indexPath) as! SimpleTableViewCell
            cell.configure(with: cats[2 * indexPath.row])

            return cell
            
        } else if indexPath.row % 3 == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SquareTableViewCell", for: indexPath) as! SquareTableViewCell
            cell.configure(with: Array(cats[(2 * indexPath.row - 1)...(2 * indexPath.row)]))

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            cell.configure(with: Array(cats[(2 * indexPath.row - 1)...(2 * indexPath.row + 1)]))

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 3 == 0 {
            return 100.0
            
        } else if indexPath.row % 3 == 1 {
            return 200.0
            
        } else {
            return 250.0
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Private Methods
    private func sendRequest() {
        NetworkManager.shared.fetchCats { result in
            switch result {
            case .success(let cats):
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.cats = cats
                    self.table.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showLoading(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
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
}
