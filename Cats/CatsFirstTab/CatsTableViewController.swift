//
//  NewTableViewController.swift
//  Cats
//
//  Created by Артем Соколовский on 26.06.2021.
//

import UIKit

class CatsTableViewController: UIViewController {
    
    @IBOutlet private var table: UITableView!
    
    private var loadingView = UIActivityIndicatorView()
    
    private var viewModel: CatsTableViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CatsTableViewModel()
        
        view.backgroundColor = CustomColor.customBackgroundColor
        
        table.backgroundColor =  CustomColor.customBackgroundColor
        
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.register(SimpleTableViewCell.nib(), forCellReuseIdentifier: SimpleTableViewCell.identifier)
        table.register(SquareTableViewCell.nib(), forCellReuseIdentifier: SquareTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        loadingView =  LoadingIndicator.shared.showLoading(in: view)
        sendRequest()
    }
  
}

// MARK: - Private Methods

private extension CatsTableViewController {
    
    func sendRequest() {
        viewModel.fetchCats { result in
            self.loadingView.stopAnimating()
            switch result {
            case .success():
                self.table.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
    
    func showAlert(title: String, message: String) {
        
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

extension CatsTableViewController: UITableViewDelegate {
    
}

extension CatsTableViewController: UITableViewDataSource {
    
    // MARK: - Public Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 3 == 0 {
            var generalCell = SimpleTableViewCell()
           if let cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleTableViewCell.identifier,
                for: indexPath
           ) as? SimpleTableViewCell {
                cell.configure(with: viewModel.cats[2 * indexPath.row])
                generalCell = cell
           }
            return generalCell
            
        } else if indexPath.row % 3 == 1 {
            var generalCell = SquareTableViewCell()
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SquareTableViewCell",
                                                        for: indexPath) as? SquareTableViewCell {
                cell.configure(with: Array(viewModel.cats[(2 * indexPath.row - 1)...(2 * indexPath.row)]))
                generalCell = cell
            }
            return generalCell
            
        } else {
            var generalCell = CollectionTableViewCell()
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell",
                                                        for: indexPath) as? CollectionTableViewCell {
                cell.configure(with: Array(viewModel.cats[(2 * indexPath.row - 1)...(2 * indexPath.row + 1)]))
                generalCell = cell
            }
            return generalCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 3 {
        case 0:
            return 100.0
        case 1:
            return 200.0
        default:
            return 250.0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
