//
//  ScheduleViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://api.elephant.spartahack.com/schedule"
        
        guard let baseURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let events = try JSONDecoder().decode([Schedule].self, from: data)
                
                for event in events {
                    print(event.title)
                }
            } catch let jsonError {
                print("Found JSON Error:\(jsonError)")
            }
            
            if let err = err {
                print(err.localizedDescription)
            }
        }.resume()
    }
}
