//
//  StudentTableViewCell.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 09.05.2023.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    static let identifier = "StudentCell"
    var id: String?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
