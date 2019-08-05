//
//  ScheduleViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    var schedule:[Schedule]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://api.elephant.spartahack.com/schedule"
        
        guard let baseURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let events = try JSONDecoder().decode([Schedule].self, from: data)
                
                self.schedule = [Schedule]()
                
                for event in events {
                    let description = event.description
                    let id = event.id
                    let location = event.location
                    let time = event.time
                    let title = event.title
                    let updated_at = event.updated_at
                    
                    let item = Schedule(description: description, id: id, location: location, time: time, title: title, updated_at: updated_at)
                    
                    self.schedule?.append(item)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            } catch let jsonError {
                print("Found JSON Error:\(jsonError)")
            }
            
            if let err = err {
                print(err.localizedDescription)
            }
        }.resume()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "scheduleCell")
        
        cell.textLabel?.text = schedule?[indexPath.item].title
        cell.textLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        
        return cell
    }
    
}
