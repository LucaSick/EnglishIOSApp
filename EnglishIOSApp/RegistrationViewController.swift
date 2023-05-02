//
//  RegistrationViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 19.04.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
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
    
    func EditTextFields() {
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, emailTextField.frame.height - 1, emailTextField.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.red.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bottomLine1)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, passwordTextField.frame.height - 1, passwordTextField.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.red.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine2)
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRectMake(0.0, password2TextField.frame.height - 1, password2TextField.frame.width, 1.0)
        bottomLine3.backgroundColor = UIColor.red.cgColor
        password2TextField.borderStyle = UITextField.BorderStyle.none
        password2TextField.layer.addSublayer(bottomLine3)
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        password2TextField.attributedPlaceholder = NSAttributedString(
            string: "Повторите пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Почта",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
    }

    
    @IBOutlet weak var RegistrationButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var studentTeacher: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextFields()
        RegistrationButton.layer.cornerRadius = RegistrationButton.frame.height / 2
        studentTeacher.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        if (!emailTextField.hasText) {
            showAlert(title: "Ошибка во время регистрации", message: "Не введена почта")
            return
        }
        
        if (!passwordTextField.hasText) {
            showAlert(title: "Ошибка во время регистрации", message: "Не введен пароль")
            return
        }
        
        if (!password2TextField.hasText) {
            showAlert(title: "Ошибка во время регистрации", message: "Не введено подтверждение пароля")
            return
        }
        
        if (!isValidEmail(testStr: emailTextField.text!)) {
            showAlert(title: "Ошибка во время регистрации", message: "Некорректная почта")
            return
        }
        
        if (password2TextField.text! != passwordTextField.text!) {
            showAlert(title: "Ошибка во время регистрации", message: "Пароли не совпадают")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/authApi/registration-request-mobile") else { return }
        
        struct Body: Codable {
            let email: String
            let password: String
            let role: String
        }
        
        let role = studentTeacher.titleForSegment(at: studentTeacher.selectedSegmentIndex) == "Студент" ? "Student" : "Teacher"
        print(role)
        
        let request_body = Body(email: emailTextField.text!, password: passwordTextField.text!, role: role)

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
                if (success == true) {
                    DispatchQueue.main.async {
                        let EmailConfirmationViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailConfirmationViewController") as! EmailConfirmationViewController
                        self.present(EmailConfirmationViewController, animated:true, completion:nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка во время регистрации", message: "Пользователь уже зарегистрирован")
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
