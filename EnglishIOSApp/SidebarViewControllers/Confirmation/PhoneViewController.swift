//
//  PhoneViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 07.05.2023.
//

import UIKit

class PhoneViewController: UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }

    var accessToken: String!
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var СallButton: UIButton!
    @IBOutlet weak var CodeTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2
        СallButton.layer.cornerRadius = СallButton.frame.height / 2
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, PhoneTextField.frame.height - 1, PhoneTextField.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.red.cgColor
        PhoneTextField.borderStyle = UITextField.BorderStyle.none
        PhoneTextField.layer.addSublayer(bottomLine1)
        PhoneTextField.attributedPlaceholder = NSAttributedString(
            string: "+71234567890",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, CodeTextField.frame.height - 1, CodeTextField.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.red.cgColor
        CodeTextField.borderStyle = UITextField.BorderStyle.none
        CodeTextField.layer.addSublayer(bottomLine2)
        CodeTextField.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        

        // Do any additional setup after loading the view.
    }
    
    func requestPhone() {
        guard let url = URL(string: "http://localhost:8080/profileApi/startPhoneConfirmation") else { return }
        
        struct Body: Codable {
            let phone: String
        }
        
        let request_body = Body(phone: PhoneTextField.text!)

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
                        self.showAlert(title: "Ошибка", message: "Повторите снова")
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
    

    @IBAction func RequestCall(_ sender: Any) {
        if !PhoneTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите телефон")
            return
        }
        requestPhone()
    }
    
    func sendCode() {
        guard let url = URL(string: "http://localhost:8080/profileApi/completePhoneConfirmation") else { return }
        
        struct Body: Codable {
            let code: String
        }
        
        let request_body = Body(code: CodeTextField.text!)

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
                        self.showAlert(title: "Ошибка", message: "Повторите снова")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "", message: "Телефон успешно подтвержден")
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
    
    
    @IBAction func ConfirmCode(_ sender: Any) {
        if !CodeTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите код")
            return
        }
        sendCode()
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
