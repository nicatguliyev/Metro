//
//  AppealViewCell.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/14/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class AppealViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
