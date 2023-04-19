//
//  RegistrationViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 19.04.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[1-9a-zA-Z_\\.]+@[a-zA-Z_]+\\.[a-zA-Z]{2,3}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var studentTeacher: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        guard let url = URL(string: "http://localhost:8080/authApi/registration-request") else { return }
        
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
        showAlert(title: "Регистрация прошла успешно", message: "Ваш аккаунт был успешно создан")
//        do {
//            sleep(1)
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
