//
//  SidebarViewController.swift
//  EnglishIOSApp
//
//  Created by Lucas Gvasalia on 29.04.2023.
//

import UIKit

class SidebarViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let MenuVC = MenuViewController()
    var ProfileVC = ProfileViewController()
    var navVC: UINavigationController?
    lazy var settingsVC = SettingsViewController()
    lazy var lessonsVC = LessonsViewController()
    lazy var teacherVC = ChangeTeacherViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        ProfileVC = (storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController)!
        ProfileVC.delegate = self
        let navigationViewController = UINavigationController(rootViewController: ProfileVC)
        addChild(navigationViewController)
        view.addSubview(navigationViewController.view)
        navigationViewController.didMove(toParent: self)
        self.navVC = navigationViewController
    }
}


extension SidebarViewController: ProfileViewControllerDelegate {
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

extension SidebarViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
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
        case .teacher:
            self.resetToHome()
            self.addTeacher()
        }
    }
    
    func addSettings() {
        lessonsVC.view.removeFromSuperview()
        teacherVC.view.removeFromSuperview()
        settingsVC = (storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController)!
        let vc = settingsVC
        ProfileVC.addChild(vc)
        ProfileVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: ProfileVC)
    }
    
    func addLessons() {
        settingsVC.view.removeFromSuperview()
        teacherVC.view.removeFromSuperview()
        lessonsVC = (storyboard?.instantiateViewController(withIdentifier: "LessonsViewController") as? LessonsViewController)!
        let vc = lessonsVC
        ProfileVC.addChild(vc)
        ProfileVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: ProfileVC)
    }
    
    func addTeacher() {
        lessonsVC.view.removeFromSuperview()
        settingsVC.view.removeFromSuperview()
        teacherVC = (storyboard?.instantiateViewController(withIdentifier: "ChangeTeacherViewController") as? ChangeTeacherViewController)!
        let vc = teacherVC
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
        teacherVC.view.removeFromSuperview()
        teacherVC.didMove(toParent: nil)
    }
}
