//
//  ViewController.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 27/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private let usersURL = "https://jsonplaceholder.typicode.com/users"
    private var userViewModel = [UserViewModel]()
    private var pressedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userViewModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.selfIdentifier, for: indexPath) as? UserCell else { fatalError("Unable to deque cell as UserCell") }
        userCell.userCellConfigure(with: userViewModel[indexPath.row])
        userCell.backgroundColor = UIColor.randomColor
        return userCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressedCell = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //force downcast zostal bo zawsze sie uda
        let destinationVC = segue.destination as! DetailTableViewController
        let chosenUser = userViewModel[pressedCell]
        destinationVC.userViewModel = chosenUser
    }
    
    //MARK: - Navigation Bar Button Configuration
    @IBAction func refreshPressed(_ sender: UIButton) {
        fetchData()
        self.presentAlert(message: "", title: "Reloaded Data")
    }
    
    
}

//MARK: - Private ViewController Configuration
private extension ViewController {
    
    func fetchData() {
        guard let url = URL(string: usersURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, _ in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.presentAlert(message: "No response from the server")
                    return
                }
                if httpResponse.isSucces {
                    if let safeData = data {
                        if let unwrapedData = self.parseJSON(safeData) {
                            self.userViewModel = unwrapedData.map({UserViewModel(user: $0)})
                            self.collectionView.reloadData()
                        }
                    }
                } else {
                    let message = httpResponse.statusCodeErrorHandler()
                    self.presentAlert(message: message)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> [User]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([User].self, from: data)
            return decodedData
        } catch {
            self.presentAlert(message: "Error while parsing data")
            return nil
        }
    }
    
    func presentAlert(message: String, title: String = "Something went wrong") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
