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
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "scheduleCell")
        
        let event = schedule?[indexPath.item].title
        let timeOf = formatTime(scheduledTime: (schedule?[indexPath.item].time)!)
        let room = schedule?[indexPath.item].location
        
        cell.detailTextLabel?.text = "\(event ?? "")"
        
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        cell.selectionStyle = .none
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = "\(timeOf)\n\(room ?? "")"
        cell.textLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 75
        
    }

    
    func formatTime(scheduledTime: String) -> String {
        
        let string = scheduledTime
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formatter.date(from: string)!
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"

        
        let dateString = formatter.string(from: date)

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
        competitionDate.month = 2
        competitionDate.day = 2
        competitionDate.hour = 00
        competitionDate.minute = 00
        competitionDate.second = 00
        let competitionDay = userCalendar.date(from: competitionDate as DateComponents)!
        
        //here we change the seconds to hours,minutes and days
        let CompetitionDayDifference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: competitionDay)
        
        
        //finally, here we set the variable to our remaining time
        let daysLeft = (CompetitionDayDifference.day! < 10 ? "0\(CompetitionDayDifference.day ?? 0)" : "\(CompetitionDayDifference.day ?? 0)")
        let hoursLeft = (CompetitionDayDifference.hour! < 10 ? "0\(CompetitionDayDifference.hour ?? 0)" : "\(CompetitionDayDifference.hour ?? 0)")
        let minutesLeft = (CompetitionDayDifference.minute! < 10 ? "0\(CompetitionDayDifference.minute ?? 0)" : "\(CompetitionDayDifference.minute ?? 0)")
        let secondsLeft = (CompetitionDayDifference.second! < 10 ? "0\(CompetitionDayDifference.second ?? 0)" : "\(CompetitionDayDifference.second ?? 0)")
        
        //Set countdown label text
        countdownLabel.text = "\(daysLeft) : \(hoursLeft) : \(minutesLeft) : \(secondsLeft)"
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(countdown)), userInfo: nil, repeats: true)
    }
}
