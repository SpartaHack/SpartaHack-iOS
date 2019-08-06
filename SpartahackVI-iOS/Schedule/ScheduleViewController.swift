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
    @IBOutlet weak var tableView: UITableView!
    
    var schedule:[Schedule]?
    var timer = Timer()
    
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
    
        runTimer()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "scheduleCell")
        
        let event = schedule?[indexPath.item].title
        let timeOf = formatTime(scheduledTime: (schedule?[indexPath.item].time)!)
        cell.textLabel?.text = "\(timeOf) - \(event ?? "(-_-)")"
        cell.textLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        cell.selectionStyle = .none
        return cell
    }
    
    func formatTime(scheduledTime: String) -> String {
        
        let string = scheduledTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @objc func countdown() {
        // here we set the current date
        
        let date = NSDate()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date as Date)
        
        let currentDate = calendar.date(from: components)
        
        let userCalendar = Calendar.current
        
        // here we set the due date. When the timer is supposed to finish
        let competitionDate = NSDateComponents()
        competitionDate.year = 2020
        competitionDate.month = 1
        competitionDate.day = 23
        competitionDate.hour = 00
        competitionDate.minute = 00
        competitionDate.second = 00
        let competitionDay = userCalendar.date(from: competitionDate as DateComponents)!
        
        //here we change the seconds to hours,minutes and days
        let CompetitionDayDifference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: competitionDay)
        
        
        //finally, here we set the variable to our remaining time
        let daysLeft = CompetitionDayDifference.day
        let hoursLeft = CompetitionDayDifference.hour
        let minutesLeft = CompetitionDayDifference.minute
        let secondsLeft = CompetitionDayDifference.second
        
        //Set countdown label text
        countdownLabel.text = "\(daysLeft ?? 0) : \(hoursLeft ?? 0) : \(minutesLeft ?? 0) : \(secondsLeft ?? 0)"
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(countdown)), userInfo: nil, repeats: true)
    }
}
