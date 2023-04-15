//
//  ViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignInButton(_ sender: UIButton) {
        print("OMG\n")
        if (!emailField.hasText) {
            print("No email")
            return
        }
        
        if (!passwordField.hasText) {
            print("No password")
            return
        }
            
        guard let url = URL(string: "http://localhost:8080/healthCheck/healthCheck") else { return }
        
        struct Body: Codable {
            let email: String
            let password: String
            let role: String
        }
        
//        let request_body = Body(email: emailField.text!, password: passwordField.text!, role: "Student")
//
//        guard let jsonData = try? JSONEncoder().encode(request_body) else {
//            print("Error: Trying to convert model to JSON data")
//            return
//        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON

//        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
//            guard let httpresponse = response as? HTTPURLResponse, (200 ..< 299) ~= httpresponse.statusCode else {
//                print("Error: HTTP request failed")
//                print(response.)
//                return
//            }
            if let httpresponse = response as? HTTPURLResponse {
                print(httpresponse.statusCode)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
        
    }
    
}

