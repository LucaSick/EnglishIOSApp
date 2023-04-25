//
//  FirstPasswordChangeViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 25.04.2023.
//

import UIKit

class FirstPasswordChangeViewController: UIViewController {
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
