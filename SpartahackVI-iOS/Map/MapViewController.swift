//
//  MapViewController.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n  \"email\": \"hack1if2you3can@gmail.com\",\n  \"password\": \"frogslllasd\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://api.elephant.spartahack.com//sessions")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token={{token}}", forHTTPHeaderField: "Authorization")
        request.addValue("vnd.example.v2", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}
