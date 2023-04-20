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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[1-9a-zA-Z_\\.]+@[a-zA-Z_\\.]+\\.[a-zA-Z]{2,3}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func SignInButton(_ sender: UIButton) { // TODO: обработку ошибок
        if (!emailField.hasText) {
            showAlert(title: "Ошибка во время входа", message: "Не введена почта")
            return
        }
        
        if (!passwordField.hasText) {
            showAlert(title: "Ошибка во время входа", message: "Не введен пароль")
            return
        }
        
        if (!isValidEmail(testStr: emailField.text!)) {
            showAlert(title: "Ошибка во время входа", message: "Некорретная почта")
            return
        }
            
        guard let url = URL(string: "http://localhost:8080/authApi/sign-in-request") else { return }
        
        struct Body: Codable {
            let email: String
            let password: String
        }
        
        let request_body = Body(email: emailField.text!, password: passwordField.text!)

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
                        self.showAlert(title: "Ошибка во время входа", message: "Попробуйте снова")
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
                        return
                    }
                }
                print(success)
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
    
    
    @IBAction func RegistrationButton(_ sender: Any) {
        let registrationViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as!RegistrationViewController
        
        self.present(registrationViewController, animated: true)
    }
    
}

