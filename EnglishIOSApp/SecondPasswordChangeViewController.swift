//
//  SecondPasswordChangeViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 25.04.2023.
//

import UIKit

class SecondPasswordChangeViewController: UIViewController {
    
    func EditTextFields() {
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, CodeTextField.frame.height - 1, CodeTextField.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.red.cgColor
        CodeTextField.borderStyle = UITextField.BorderStyle.none
        CodeTextField.layer.addSublayer(bottomLine1)
        CodeTextField.attributedPlaceholder = NSAttributedString(
            string: "Код",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, NewPasswordTextField.frame.height - 1, NewPasswordTextField.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.red.cgColor
        NewPasswordTextField.borderStyle = UITextField.BorderStyle.none
        NewPasswordTextField.layer.addSublayer(bottomLine2)
        NewPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Новый пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRectMake(0.0, NewPassword2TextField.frame.height - 1, NewPassword2TextField.frame.width, 1.0)
        bottomLine3.backgroundColor = UIColor.red.cgColor
        NewPassword2TextField.borderStyle = UITextField.BorderStyle.none
        NewPassword2TextField.layer.addSublayer(bottomLine3)
        NewPassword2TextField.attributedPlaceholder = NSAttributedString(
            string: "Повторите новый пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
    }

    @IBOutlet weak var CodeTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var NewPassword2TextField: UITextField!
    @IBOutlet weak var ChangePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextFields()
        ChangePasswordButton.layer.cornerRadius = ChangePasswordButton.frame.height / 2
        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ChangePassword(_ sender: Any) {
        if (!CodeTextField.hasText) {
            showAlert(title: "Ошибка во время смены пароля", message: "Не введен код")
            return
        }
        
        if (!NewPasswordTextField.hasText) {
            showAlert(title: "Ошибка во время смены пароля", message: "Не введен новый пароль")
            return
        }
        
        if (!NewPassword2TextField.hasText) {
            showAlert(title: "Ошибка во время смены пароля", message: "Не введено подтверждение нового пароля")
            return
        }
        
        if (NewPasswordTextField.text! != NewPassword2TextField.text!) {
            showAlert(title: "Ошибка во время смены пароля", message: "Пароли не совпадают")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/authApi/restore-password/" + CodeTextField.text!) else { return }
        
        struct Body: Codable {
            let newPassword: String
        }
        
        let request_body = Body(newPassword: NewPasswordTextField.text!)

        guard let jsonData = try? JSONEncoder().encode(request_body) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON

        request.httpBody = jsonData
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
            if let httpresponse = response as? HTTPURLResponse {
                print(httpresponse.statusCode)
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                let success = jsonObject["success"] as! Bool
                print(success)
                if (success == false) {
//                    let reason = jsonObject["reason"] as! String
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка во время смены пароля", message: "Неверный код")
                        return
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
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Пароль успешно изменён")
                    return
                }
//                DispatchQueue.main.async {
//                    let EmailConfirmationViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailConfirmationViewController") as! EmailConfirmationViewController
//                    self.present(EmailConfirmationViewController, animated:true, completion:nil)
//                }
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
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
