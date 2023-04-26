//
//  FirstPasswordChangeViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 25.04.2023.
//

import UIKit

class FirstPasswordChangeViewController: UIViewController {
    
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
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Почта",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ConfirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextFields()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2

        // Do any additional setup after loading the view.
    }
    @IBAction func ConfirmEmailForReset(_ sender: Any) {
        if (!emailTextField.hasText) {
            showAlert(title: "Ошибка во время регистрации", message: "Не введена почта")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/authApi/startChangePassword-mobile") else { return }
        
        struct Body: Codable {
            let email: String
        }
        
        let request_body = Body(email: emailTextField.text!)

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
                    let reason = jsonObject["reason"] as! String
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка во время смены пароля", message: reason)
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
                    let SecondPasswordChangeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondPasswordChangeViewController") as! SecondPasswordChangeViewController
                    self.present(SecondPasswordChangeViewController, animated:true, completion:nil)
                }
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
