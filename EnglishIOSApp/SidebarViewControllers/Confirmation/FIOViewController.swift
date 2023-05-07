//
//  FIOViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 07.05.2023.
//

import UIKit

class FIOViewController: UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var FIOTextField: UITextField!
    func updateFIO() {
        
        guard let url = URL(string: "http://localhost:8080/profileApi/setFio") else { return }
        
        struct Body: Codable {
            let newFio: String
        }
        
        let request_body = Body(newFio: FIOTextField.text!)

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
                        self.showAlert(title: "", message: "ФИО успешно обновлено")
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
    
    var accessToken: String!


    @IBOutlet weak var ConfirmButton: UIButton!
    @IBAction func ChangeFIO(_ sender: Any) {
        if !FIOTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите ФИО")
            return
        }
        updateFIO()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2

        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, FIOTextField.frame.height - 1, FIOTextField.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.red.cgColor
        FIOTextField.borderStyle = UITextField.BorderStyle.none
        FIOTextField.layer.addSublayer(bottomLine1)
        FIOTextField.attributedPlaceholder = NSAttributedString(
            string: "ФИО",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
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
