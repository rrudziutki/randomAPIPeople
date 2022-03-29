//
//  DetailTableViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 29/03/2022.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var userInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Personal information"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userInfo[indexPath.row]
        return cell
    }

}
