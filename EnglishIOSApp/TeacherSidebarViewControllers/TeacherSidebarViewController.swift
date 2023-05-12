//
//  SidebarViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 29.04.2023.
//

import UIKit

class TeacherSidebarViewController: UIViewController {
    var refreshToken: String!
    var accessToken: String!
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let MenuVC = TeacherMenuViewController()
    var ProfileVC = TeacherProfileViewController()
    var navVC: UINavigationController?
    lazy var settingsVC = TeacherSettingsViewController()
    lazy var lessonsVC = TeacherLessonsViewController()
    lazy var gradeVC = TeacherGradeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(refreshToken ?? "empty")
        addChildVC()
        // Do any additional setup after loading the view.
    }
    
    private func addChildVC() {
        // Menu
        MenuVC.delegate = self
        addChild(MenuVC)
        view.addSubview(MenuVC.view)
        MenuVC.didMove(toParent: self)
        
        // Home
        ProfileVC = (storyboard?.instantiateViewController(withIdentifier: "TeacherProfileViewController") as? TeacherProfileViewController)!
        ProfileVC.delegate = self
        ProfileVC.refreshToken = refreshToken
        ProfileVC.accessToken = accessToken
        let navigationViewController = UINavigationController(rootViewController: ProfileVC)
        addChild(navigationViewController)
        view.addSubview(navigationViewController.view)
        navigationViewController.didMove(toParent: self)
        self.navVC = navigationViewController
    }
}


extension TeacherSidebarViewController: TeacherProfileViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.ProfileVC.view.frame.size.width - 225
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension TeacherSidebarViewController: TeacherMenuViewControllerDelegate {
    func didSelect(menuItem: TeacherMenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .profile:
            self.resetToHome()
        case .lessons:
            self.resetToHome()
            self.addLessons()
        case .settings:
            self.resetToHome()
            self.addSettings()
        case .grade:
            self.resetToHome()
            self.addGrade()
        }
    }
    
    func addSettings() {
        lessonsVC.view.removeFromSuperview()
        gradeVC.view.removeFromSuperview()
        settingsVC = (storyboard?.instantiateViewController(withIdentifier: "TeacherSettingsViewController") as? TeacherSettingsViewController)!
        settingsVC.refreshToken = ProfileVC.refreshToken
        settingsVC.accessToken = ProfileVC.accessToken
        print(settingsVC.refreshToken!)
        let vc = settingsVC
        ProfileVC.addChild(vc)
        ProfileVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: ProfileVC)
    }
    
    func addLessons() {
        settingsVC.view.removeFromSuperview()
        gradeVC.view.removeFromSuperview()
        lessonsVC = (storyboard?.instantiateViewController(withIdentifier: "TeacherLessonsViewController") as? TeacherLessonsViewController)!
        lessonsVC.refreshToken = ProfileVC.refreshToken
        lessonsVC.accessToken = ProfileVC.accessToken
        let vc = lessonsVC
        ProfileVC.addChild(vc)
        ProfileVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: ProfileVC)
    }
    
    func addGrade() {
        lessonsVC.view.removeFromSuperview()
        settingsVC.view.removeFromSuperview()
        gradeVC = (storyboard?.instantiateViewController(withIdentifier: "TeacherGradeViewController") as? TeacherGradeViewController)!
        gradeVC.refreshToken = ProfileVC.refreshToken
        gradeVC.accessToken = ProfileVC.accessToken
        let vc = gradeVC
        ProfileVC.addChild(vc)
        ProfileVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: ProfileVC)
    }
    
    func resetToHome() {
        settingsVC.view.removeFromSuperview()
        settingsVC.didMove(toParent: nil)
        lessonsVC.view.removeFromSuperview()
        lessonsVC.didMove(toParent: nil)
        gradeVC.view.removeFromSuperview()
        gradeVC.didMove(toParent: nil)
    }
}
