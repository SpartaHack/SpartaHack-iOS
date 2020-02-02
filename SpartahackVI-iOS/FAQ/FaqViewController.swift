//
//  FaqViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 8/7/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var allFaqs:[Faq]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://api.elephant.spartahack.com/faqs"
        
        guard let baseURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let faqs = try JSONDecoder().decode([Faq].self, from: data)
                
                self.allFaqs = [Faq]()
                
                for faq in faqs {
                    if faq.display == true {
                        let answer = faq.answer
                        let display = faq.display
                        let id = faq.id
                        let placement = faq.placement
                        let priority = faq.priority
                        let question = faq.question
                        
                        let item = Faq(answer: answer, display: display, id: id, placement: placement, priority: priority, question: question)
                        
                        self.allFaqs?.append(item)
                    }
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
        return allFaqs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FaqCell")
        
        cell.textLabel?.text = allFaqs?[indexPath.item].question
        
        cell.detailTextLabel?.text = allFaqs?[indexPath.item].answer
        
        cell.textLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = UIColor.gray
        
        cell.selectionStyle = .none
        
        return cell
    }

}
