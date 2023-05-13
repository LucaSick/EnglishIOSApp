//
//  ProfileViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 29.04.2023.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ProfileViewController: UIViewController {
    var telegramLink: String!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
//    @IBOutlet weak var FIOChangeButton: UIButton!
//    @IBOutlet weak var PhoneChangeButton: UIButton!
//    @IBOutlet weak var TelegramChangeButton: UIButton!
    
    
    weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var FIO: UILabel!
    @IBOutlet weak var Telegram: UILabel!
    @IBOutlet weak var Teacher: UILabel!
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
                    accessToken = data["accessToken"]!
                    refreshToken = data["refreshToken"]!
                    
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
    
    @IBAction func ChangeFIO(_ sender: Any) {
//        if FIO.text != "Не введено" {
//            self.showAlert(title: "Ошибка", message: "ФИО изменить нельзя, обратитесь в поддержку")
//            return;
//        }
        updateTokens()
        let FIOViewController = self.storyboard?.instantiateViewController(withIdentifier: "FIOViewController") as! FIOViewController
        self.present(FIOViewController, animated: true)
    }
    
    @IBAction func ChangePhone(_ sender: Any) {
//        if Phone.text != "Не введено" {
//            self.showAlert(title: "Ошибка", message: "Телефон изменить нельзя, обратитесь в поддержку")
//            return;
//        }
        updateTokens()
        let PhoneViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneViewController") as! PhoneViewController
        self.present(PhoneViewController, animated: true)
    }
    
    @IBAction func ChangeTelegram(_ sender: Any) {
//        if Telegram.text != "Не введено" {
//            self.showAlert(title: "Ошибка", message: "Телеграм изменить нельзя, обратитесь в поддержку")
//            return;
//        }
        updateTokens()
        let TelegramViewController = self.storyboard?.instantiateViewController(withIdentifier: "TelegramViewController") as! TelegramViewController
        TelegramViewController.telegramLink = telegramLink
        self.present(TelegramViewController, animated: true)
    }
    
    func GetData() {
        guard let url = URL(string: "http://localhost:8080/profileApi/activeStep") else { return }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization") // the request is JSON

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
                        let data = jsonObject["data"] as! [String: Any]
                        let profile = data["profile"] as! [String: Any]
                        if profile["fio"] as! String != "" {
                            self.FIO.text = profile["fio"] as? String
                        }
                        if profile["phone"] as! String != "" {
                            self.Phone.text = profile["phone"] as? String
                        }
                        if profile["telegram"] as! String != "" {
                            self.Telegram.text = profile["telegram"] as? String
                        }
                        self.telegramLink = data["telegramDeeplink"] as? String
                        
                    }
                } else {
                    DispatchQueue.main.async {
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
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func GetTeacher() {
        guard let url = URL(string: "http://localhost:8080/profileApi/teacherInfo") else { return }
        
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
                    DispatchQueue.main.async {
                        let data = jsonObject["data"] as! [String: String]
                        self.Teacher.text = data["fio"]
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
    
    @IBAction func Update(_ sender: Any) {
        GetData()
        GetTeacher()
    }
    
    @IBAction func BackToSignIn(_ sender: Any) {
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        ViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(ViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LogOutButton.layer.cornerRadius = LogOutButton.frame.height / 2
        view.backgroundColor = UIColor.systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton))
        GetData()
        GetTeacher()
    }

    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
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
