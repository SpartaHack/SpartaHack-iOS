//
//  ProfileViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit
import Auth0


class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var dietaryRestrictionsLabel: UILabel!
    
//    let user = Profile(role: "Student", checked_in: true, first_name: "William", last_name: "Huynh", email: "huynhwi2@msu.edu", id: 43418793, dietary_restrictions: "nuts")
//
    override func viewDidLoad() {
        super.viewDidLoad()

        // HomeViewController.swift
        
//        loadData()
    }
    
//    func loadData() {
//        usernameLabel.text = user.first_name
//        roleLabel.text = user.role
//        dietaryRestrictionsLabel.text = user.dietary_restrictions
//    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://spartahack-dev.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    print("Credentials: \(credentials)")

                    // credentials = A returned credentials object from the credentials manager in the previous step.

                    guard let accessToken = credentials.accessToken else {
                        // Handle Error
                        return
                    }

                    Auth0
                        .authentication()
                        .userInfo(withAccessToken: accessToken)
                        .start { result in
                            switch(result) {
                            case .success(let profile):
                                print(profile.name)

                                
                                
//                                if let name = profile.name {
//                                  // Show Information
//
//                                }
                                // You've got the user's profile, good time to store it locally.
                                // e.g. self.profile = profile
                            case .failure(let error):
                                // Handle the error
                                print("Error: \(error)")
                            }
                        }
                    
                }
        }
    }
}
