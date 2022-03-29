//
//  UserCell.swift
//  randomApiPeople
//
//  Created by Remik Makuchowski on 27/03/2022.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet var userLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.size.width / 2
        
    }
    
    func setLabel(with name: String) {
        userLabel.text = name
    }
}

extension UIColor {
    static var randomColor: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
