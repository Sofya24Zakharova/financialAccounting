//
//  TableViewCell.swift
//  Учет финансов
//
//  Created by mac on 17.08.2020.
//  Copyright © 2020 Sofya Zakharova. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var recordImage: UIImageView!
    
    @IBOutlet weak var recordCategory: UILabel!
    
    @IBOutlet weak var recordCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
