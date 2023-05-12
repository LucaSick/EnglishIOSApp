//
//  TeacherGradeViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 12.05.2023.
//

import UIKit
import DropDown

class TeacherGradeViewController: UIViewController {
    var refreshToken: String!
    var accessToken: String!
    var dropDown = DropDown()
    
    var curr_student_id: String = ""
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editTextViews() {
        HomeworkTextView.layer.borderWidth = 1.0
        HomeworkTextView.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
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
    
    var name_arr: [String] = []
    var id_arr: [String] = []
    
    func getStudents() {
        guard let url = URL(string: "http://localhost:8080/teacherProfileApi/getAllStudents") else { return }
        
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
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
                        self.showAlert(title: "Ошибка", message: "Попробуйте снова")
                    }
                }
                else {
                    let data = jsonObject["data"] as! [[String: String]]
                    for student in data {
                        if student["fio"]! != "" {
                            name_arr.append(student["fio"]!)
                            id_arr.append(student["id"]!)
                        }
                    }
                    print(name_arr)
                    print(id_arr)
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
    
    @IBAction func ChooseStudent(_ sender: Any) {
        updateTokens()
        getStudents()
        dropDown.dataSource = name_arr
        dropDown.anchorView = sender as? any AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self!.curr_student_id = self!.id_arr[index]
            guard let _ = self else { return }
            (sender as AnyObject).setTitle(item, for: .normal)
        }
        name_arr.removeAll()
        id_arr.removeAll()
    }
    
    
    @IBOutlet weak var TopicTextField: UITextField!
    @IBOutlet weak var HomeworkTextView: UITextView!
    
    func getHomework() {
        guard let url = URL(string: "http://localhost:8080/homeworkTeacherApi/getHomework/" + curr_student_id + "/" + TopicTextField.text!) else { return }
        
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
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
                        self.showAlert(title: "Ошибка", message: "Попробуйте снова")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.HomeworkTextView.text = jsonObject["data"] as? String
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
    
    @IBAction func GetHomework(_ sender: Any) {
        if !TopicTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите тему домашнего задания")
            return
        }
        if (curr_student_id == "") {
            showAlert(title: "Ошибка", message: "Выберите студента")
            return
        }
        editTextViews()
        updateTokens()
        getHomework()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
