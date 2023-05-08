//
//  TeacherFIOViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 06.05.2023.
//

import UIKit

class TeacherFIOViewController: UIViewController {
    var accessToken: String!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var FIOTextField: UITextField!
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
    
    @IBAction func Confirm(_ sender: Any) {
        if !FIOTextField.hasText {
            showAlert(title: "Ошибка", message: "Введите ФИО")
            return
        }
        showAlert(title: "", message: "ФИО успешно подтверждено")
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
