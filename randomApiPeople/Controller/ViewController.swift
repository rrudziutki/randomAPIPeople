//
//  ViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 27/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    private var pressedCell = 0
    private var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        configure()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userViewModel.users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.selfIdentifier, for: indexPath) as? UserCell else { fatalError("Unable to deque cell as UserCell") }
        userCell.userCellConfigure(with: userViewModel.users[indexPath.row])
        return userCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressedCell = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? DetailTableViewController else { fatalError("DetailVC") }
        let chosenUser = userViewModel.users[pressedCell]
        destinationVC.user = chosenUser
    }
    
    //MARK: - Navigation Bar Button Configuration
    @IBAction func refreshPressed(_ sender: UIButton) {
        userViewModel.getUsers()
        self.presentAlert(message: "", title: "Reloaded Data")
    }
}

//MARK: - VC Private Extenstion
private extension ViewController {
    func configure() {
        userViewModel.delegate = self
        userViewModel.getUsers()
    }
}

//MARK: - UserViewModelDelegate
extension ViewController: UserViewModelDelegate {
    func presentAlert(message: String, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
