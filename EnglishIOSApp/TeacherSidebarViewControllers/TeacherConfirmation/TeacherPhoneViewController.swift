//
//  TeacherPhoneViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 06.05.2023.
//

import UIKit

class TeacherPhoneViewController: UIViewController {
    var accessToken: String!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var CallRequestButton: UIButton!
    @IBOutlet weak var CodeTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2
        CallRequestButton.layer.cornerRadius = CallRequestButton.frame.height / 2
        
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
    
    @IBAction func Call(_ sender: Any) {
        if !PhoneTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите телефон")
            return
        }
    }
    @IBAction func Confirm(_ sender: Any) {
        if !CodeTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите код")
            return
        }
        showAlert(title: "", message: "Телефон успешно подтвержден")
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
