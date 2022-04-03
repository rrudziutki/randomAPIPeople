//
//  ViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 27/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private var users = [User]()
    private var usersManager = UsersManager()
    private var pressedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        configure()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.selfIdentifier, for: indexPath) as? UserCell else { fatalError("Unable to deque cell as UserCell") }
        userCell.userCellConfigure(with: users[indexPath.row].username)
        userCell.backgroundColor = UIColor.randomColor
        return userCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressedCell = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailTableViewController
        let chosenUser = users[pressedCell]
        destinationVC.user = chosenUser
    }
}

//MARK: - Private ViewController
private extension ViewController {
    func configure() {
        usersManager.delegate = self
        usersManager.performRequest()
    }
}

//MARK: - UsersManagerDelegate
extension ViewController: UsersManagerDelegate {
    
    func updateUsersName(with usersData: [User]) {
        _ = usersData.map { users.append($0) }
        self.collectionView.reloadData()
    }
    
    func presentError(with message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
