//
//  ViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 27/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {

    var users = [UserModel]()
    var usersManager = UsersManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        usersManager.delegate = self
        usersManager.performRequest()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        userCell.setLabel(with: users[indexPath.row].name)
        userCell.backgroundColor = UIColor.randomColor
        return userCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("The selected username is : \(users[indexPath.row])")
    }
}

//MARK: - UsersManagerDelegate

extension ViewController: UsersManagerDelegate {
    func updateUsersName(with usersData: [UserModel]) {
        DispatchQueue.main.async {
            for user in usersData {
                self.users.append(user)
            }
            self.collectionView.reloadData()
        }
        
    }
    
    func didFailed(with error: Error) {
        print(error)
    }
}
