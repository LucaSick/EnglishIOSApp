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
            string: "Новый пароль еще раз",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
    }

    @IBOutlet weak var CodeTextField: UITextField!
    @IBOutlet weak var NewPassword2TextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var ChangePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextFields()
        ChangePasswordButton.layer.cornerRadius = ChangePasswordButton.frame.height / 2
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
