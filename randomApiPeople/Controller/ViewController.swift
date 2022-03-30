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
    var pressedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        usersManager.delegate = self
        usersManager.performRequest()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        userCell.setLabel(with: users[indexPath.row].username)
        userCell.backgroundColor = UIColor.randomColor
        return userCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("The selected username is : \(users[indexPath.row])")
        pressedCell = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailTableViewController
        let chosenUser = users[pressedCell]
        destinationVC.user = chosenUser
    }
}

//MARK: - UsersManagerDelegate

extension ViewController: UsersManagerDelegate {
    
    func updateUsersName(with usersData: [UserModel]) {
        for user in usersData {
            self.users.append(user)
        }
        self.collectionView.reloadData()
    }
    
    func didFailed(with error: Error) {
        print(error)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let leftAndRightPaddings: CGFloat = 50.0
        let numberOfItemsPerRow: CGFloat = 2.0
        let width = (collectionView.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
}
