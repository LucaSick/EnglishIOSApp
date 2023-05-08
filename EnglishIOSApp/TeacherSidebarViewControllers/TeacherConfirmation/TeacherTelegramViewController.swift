//
//  TeacherTelegramViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 06.05.2023.
//

import UIKit

class TeacherTelegramViewController: UIViewController {
    var accessToken: String!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ConfirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = ConfirmButton.frame.height / 2

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Confirm(_ sender: Any) {
        showAlert(title: "", message: "Телеграм успешно подтвержден")
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
