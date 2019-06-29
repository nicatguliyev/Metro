//
//  InformationController.swift
//  Metro
//
//  Created by Nicat Guliyev on 5/14/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class InformationController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 5
    }
    


    @IBAction func nextBtnClicked(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
    }
    
}
