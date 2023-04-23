//
//  EmailConfirmationViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 22.04.2023.
//

import UIKit

class EmailConfirmationViewController: UIViewController {
    
    func EditTextFields() {
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, codeTextField.frame.height - 1, codeTextField.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.red.cgColor
        codeTextField.borderStyle = UITextField.BorderStyle.none
        codeTextField.layer.addSublayer(bottomLine1)
        codeTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите код",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextFields()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBAction func ConfirmEmail(_ sender: Any) {
        if (!codeTextField.hasText) {
            showAlert(title: "Ошибка во время подтверждения почты", message: "Не введен код")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/authApi/confirm/" + codeTextField.text!) else { return }
        print("http://localhost:8080/authApi/confirm/" + codeTextField.text!)
        

        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            if let httpresponse = response as? HTTPURLResponse {
                print(httpresponse.statusCode)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                let success = jsonObject["success"] as! Bool
                if (success == false) {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка во время подтверждения почты", message: "Неверный код")
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
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Ваш аккаунт был успешно создан")
                    return
                }
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }

}
