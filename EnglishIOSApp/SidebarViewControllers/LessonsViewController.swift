//
//  LessonsViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 30.04.2023.
//

import UIKit

class LessonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var times_arr: [(String, String)] = []
    
    var curr_id: String = ""
    var curr_date: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times_arr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curr_id = times_arr[indexPath.row].1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TimesTableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentTableViewCell
        if (times_arr.isEmpty) {
            cell.textLabel?.text = ""
            cell.id = ""
            return cell
        }
        cell.textLabel?.text = times_arr[indexPath.row].0
        cell.id = times_arr[indexPath.row].1
        return cell
    }
    //UITableViewDelegate, UITableViewDataSource {
    
    var refreshToken: String!
    var accessToken: String!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTokens() {
        guard let url = URL(string: "http://localhost:8080/authApi/refresh") else { return }
        
        struct Body: Codable {
            let refreshToken: String
        }
        
        let request_body = Body(refreshToken: refreshToken)

        guard let jsonData = try? JSONEncoder().encode(request_body) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON

        request.httpBody = jsonData
        var success = true
        var code = 200
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            if let httpresponse = response as? HTTPURLResponse {
                code = httpresponse.statusCode
                if (code == 500) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Попробуйте снова")
                        return
                    }
                }
                print(code)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                success = jsonObject["success"] as! Bool
                if (success == false) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка во время входа", message: "Неверная почта или пароль")
                    }
                }
                else {
                    let data = jsonObject["data"] as! [String: String]
                    accessToken = data["accessToken"]
                    refreshToken = data["refreshToken"]
                    
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
        }
        task.resume()
    }
    
    
    @IBOutlet weak var TimesTableView: UITableView!
    
    @IBOutlet weak var DateTextField: UITextField!
    
    func insertTime(time: String, id: String) {
        times_arr.append((time, id))
        let indexPath = IndexPath(row: times_arr.count - 1, section: 0)
        TimesTableView.beginUpdates()
        TimesTableView.insertRows(at: [indexPath], with: .automatic)
        TimesTableView.endUpdates()
        view.endEditing(true)
    }
    
    func GetTimesFromDate() {
        TimesTableView.register(StudentTableViewCell.self, forCellReuseIdentifier: StudentTableViewCell.identifier)
        guard let url = URL(string: "http://localhost:8080/teacherScheduleApi/freeSlotsByDay") else { return }
        
        struct Body: Codable {
            let day: String
        }
        
        let request_body = Body(day: DateTextField.text!)

        guard let jsonData = try? JSONEncoder().encode(request_body) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization") // the request is JSON

        request.httpBody = jsonData
        var success = true
        var code = 200
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            if let httpresponse = response as? HTTPURLResponse {
                code = httpresponse.statusCode
                if (code == 500) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Дата введена неверно")
                        return
                    }
                }
                print(code)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                success = jsonObject["success"] as! Bool
                if (success == false) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Повторите снова")
                    }
                } else {
                    DispatchQueue.main.async {
                        let data = jsonObject["data"] as! [[String: String]]
                        for time_obj in data {
                            let title = time_obj["startTime"]! + "-" + time_obj["endTime"]!
                            self.insertTime(time: title, id: time_obj["id"]!)
                        }
                        
                    }
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
        }
        task.resume()
    }
    
    @IBAction func GetTimesFunc(_ sender: Any) {
        times_arr.removeAll()
        TimesTableView.reloadData()
        if !DateTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите дату в нужном формате")
        }
        curr_date = DateTextField.text!
        updateTokens()
        GetTimesFromDate()
        
    }
    
    func Request() {
        guard let url = URL(string: "http://localhost:8080/teacherScheduleApi/startClassConfirmation") else { return }
        
        struct Body: Codable {
            let timeSlotId: String
            let date: String
        }
        
        let request_body = Body(timeSlotId: curr_id, date: curr_date)

        guard let jsonData = try? JSONEncoder().encode(request_body) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization") // the request is JSON

        request.httpBody = jsonData
        var success = true
        var code = 200
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            if let httpresponse = response as? HTTPURLResponse {
                code = httpresponse.statusCode
                if (code == 500) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Дата введена неверно")
                        return
                    }
                }
                print(code)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                success = jsonObject["success"] as! Bool
                if (success == false) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Повторите снова")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "", message: "Занятие успешно запрошено")
                    }
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
        }
        task.resume()
    }
    
    
    @IBAction func RequestLesson(_ sender: Any) {
        if curr_id == "" {
            showAlert(title: "Ошибка", message: "Выберите дату")
            return
        }
        print(curr_id)
        updateTokens()
        Request()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
