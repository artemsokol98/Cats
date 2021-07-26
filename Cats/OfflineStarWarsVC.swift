//
//  OfflineStarWarsVC.swift
//  Cats
//
//  Created by Артем Соколовский on 22.07.2021.
//

import UIKit

class OfflineStarWarsVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var offlineData = [StarWarsCoreData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        getAllItems()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = table.indexPathForSelectedRow {
            guard let descriptionStarWarsItem = segue.destination as? DescriptionStarWarsItemVC else {
                return }
            let convert = StarWarsPeople(
                name: offlineData[indexPath.row].name ?? "",
                height: offlineData[indexPath.row].height ?? "",
                mass: offlineData[indexPath.row].mass ?? "",
                hairColor: offlineData[indexPath.row].hairColor ?? "",
                skinColor: offlineData[indexPath.row].skinColor ?? "",
                eyeColor: offlineData[indexPath.row].eyeColor ?? "",
                birthYear: offlineData[indexPath.row].birthYear ?? "",
                gender: offlineData[indexPath.row].gender ?? ""
            )
            descriptionStarWarsItem.item = convert
        }
    }
    
    func getAllItems() {
        do {
            offlineData = try context.fetch(StarWarsCoreData.fetchRequest())
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } catch {
            
        }
    }
    
    func deleteItem(item: StarWarsCoreData) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }

}

extension OfflineStarWarsVC: UITableViewDelegate {
    
}

extension OfflineStarWarsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        offlineData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offlineStarWars", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let people = offlineData[indexPath.row]
        content.text = people.name
        content.secondaryText = "Birthyear: \(people.birthYear ?? "")"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showOfflineDescription", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let item = offlineData[indexPath.row]
        deleteItem(item: item)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}
