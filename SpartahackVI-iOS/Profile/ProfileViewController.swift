//
//  ProfileViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var dietaryRestrictionsLabel: UILabel!
    
    
    let user = Profile(role: "Student", checked_in: true, first_name: "William", last_name: "Huynh", email: "huynhwi2@msu.edu", id: 43418793, dietary_restrictions: "nuts")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }
    
    func loadData() {
        usernameLabel.text = user.first_name
        roleLabel.text = user.role
        dietaryRestrictionsLabel.text = user.dietary_restrictions
    }
}
