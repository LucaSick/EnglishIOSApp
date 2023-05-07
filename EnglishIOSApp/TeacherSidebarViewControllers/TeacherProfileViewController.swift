//
//  ProfileViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 29.04.2023.
//

import UIKit

protocol TeacherProfileViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class TeacherProfileViewController: UIViewController {

    var refreshToken: String!
    var accessToken: String!
    
    weak var delegate: TeacherProfileViewControllerDelegate?
    

    @IBOutlet weak var FIOTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var TelegramTextField: UITextField!
    
    
    @IBAction func ChangeFIO(_ sender: Any) {
        let TeacherFIOViewController = self.storyboard?.instantiateViewController(withIdentifier: "TeacherFIOViewController") as! TeacherFIOViewController
        // change to accessToken
        TeacherFIOViewController.accessToken = refreshToken
        self.present(TeacherFIOViewController, animated: true)
    }
    
    @IBAction func ChangePhone(_ sender: Any) {
        let TeacherPhoneViewController = self.storyboard?.instantiateViewController(withIdentifier: "TeacherPhoneViewController") as! TeacherPhoneViewController
        // change to accessToken
        TeacherPhoneViewController.accessToken = refreshToken
        self.present(TeacherPhoneViewController, animated: true)
    }
    
    @IBAction func ChangeTelegram(_ sender: Any) {
        let TeacherTelegramViewController = self.storyboard?.instantiateViewController(withIdentifier: "TeacherTelegramViewController") as! TeacherTelegramViewController
        // change to accessToken
        TeacherTelegramViewController.accessToken = refreshToken
        self.present(TeacherTelegramViewController, animated: true)
    }
    
    
    @IBAction func BackToSignIn(_ sender: Any) {
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        ViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(ViewController, animated: true)
    }

    @IBOutlet var ProfileTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(refreshToken ?? "empty")
        view.backgroundColor = UIColor.systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton))
        guard let url = URL(string: "http://localhost:8080/profileApi/activeStep") else { return }

        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                if (code != 500) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
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
                        self.dismiss(animated: true)
                        return
                    }
                }
                else {
                    let data = jsonObject["data"] as! [String: Any]
                    let profile = data["profile"] as! [String: String]
                    
                    
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
        // Do any additional setup after loading the view.
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
