//
//  DetailTableViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 29/03/2022.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var user: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            createUsersCell(cell, with: user, userAttribute: .id)
        case 1:
            createUsersCell(cell, with: user, userAttribute: .name)
        case 2:
            createUsersCell(cell, with: user, userAttribute: .username)
        default:
            cell.textLabel?.text = "No information"
        }
        return cell
    }
    
    enum UserAttribute {
    case id, name, username
    }
    
    func createUsersCell(_ cell: UITableViewCell, with user: UserModel, userAttribute: UserAttribute) {
        switch userAttribute {
        case .id:
            cell.textLabel?.text = "User ID: \(user.id)"
        case .name:
            cell.textLabel?.text = "User Name: \(user.name)"
        case .username:
            cell.textLabel?.text = "User Username: \(user.username)"
        }
    }
    
}
