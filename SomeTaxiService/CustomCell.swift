//
//  CustomCell.swift
//  SomeTaxiService
//
//  Created by Nik on 02.11.16.
//  Copyright © 2016 Gafurov. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    
    @IBOutlet weak var requestNumber: UILabel!
   
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var createdAt: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
