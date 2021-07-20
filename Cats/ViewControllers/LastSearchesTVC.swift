//
//  LastSearchesTVC.swift
//  Cats
//
//  Created by Артем Соколовский on 19.07.2021.
//

import UIKit

class LastSearchesTVC: UIViewController {
    
    @IBOutlet private weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
    }

}

extension LastSearchesTVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Last searches"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.shared.lastSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lastSearch", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = DataManager.shared.lastSearches[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
            DataManager.shared.lastSearches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension LastSearchesTVC: UITableViewDelegate {
    
}
